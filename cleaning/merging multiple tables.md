# Merging spreadsheets with multiple tables

NHS England publish [data on dementia assessment and referral](https://www.england.nhs.uk/statistics/statistical-work-areas/dementia/dementia-assessment-and-referral-2017-18/) but the data needs cleaning to get into a format that we can work with. Instead of publishing in the same format every month, two different formats are used: one for the two months at the start of each quarter (January, February, April, May and so on), and another for the month that ends each quarter (March, June, September, December) which includes the other two months in that quarter too.

This Notebook outlines how those quarterly datasets are collated, cleaned and combined using R

## Testing the process on one spreadsheet

Below is the code that: 

* Fetches a spreadsheet from a given URL
* Extracts the hospital names within that
* Extracts the different months' data
* Extracts the month names
* Combines the 3 months' data into a usable format for analysis

First, install two packages:

```{r}
#Install the readxl package that we need to work with the Excel file
install.packages("readxl")
library(readxl)
#Install the httr package that we need to fetch a URL
install.packages("httr")
library(httr)
```

Next, grab the XLS file at a specified URL and break it down:

```{r}
testurl <- "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2017/09/Dementia-Data-Collection-Q1-2017-18-XLS-75KB.xlsx"
#Fetch the XLS file and store it locally
GET(testurl, write_disk("testdata.xlsx", overwrite=TRUE))
#Each month has 9 columns of data, followed by an empty column. The first 2 columns have the areas. So first we grab the 2 columns of labels...
monthlabels <- read_excel("testdata.xlsx", sheet=2, skip=12)[1:2]
#...plus 9 columns of data:
month1 <- read_excel("testdata.xlsx", sheet=2, skip=12)[3:11]
month2 <- read_excel("testdata.xlsx", sheet=2, skip=12)[13:21]
month3 <- read_excel("testdata.xlsx", sheet=2, skip=12)[23:31]
#Next we add the labels to each sheet
month1 <- cbind(monthlabels,month1)
month2 <- cbind(monthlabels,month2)
month3 <- cbind(monthlabels,month3)
#add a column which specifies the month
month1name <- read_excel("testdata.xlsx", sheet=2, skip=6)[3]
month2name <- read_excel("testdata.xlsx", sheet=2, skip=6)[13]
month3name <- read_excel("testdata.xlsx", sheet=2, skip=6)[23]
month1$month <- colnames(month1name)
month2$month <- colnames(month2name)
month3$month <- colnames(month3name)
#make the column names all the same - otherwise rbind will throw an error
colnames(month2) <- colnames(month1)
colnames(month3) <- colnames(month1)
#Combine all three
months1to3 <- rbind(month1, month2, month3)
#Remove the unneeded months
rm(month1,month1name,month2,month2name,month3,month3name,monthlabels)
```

## Rewriting for a CSV

The data is also published in CSV format. This is better to use because we know there will only ever be one sheet (revised XLS sheets have 3) and it is simpler to deal with. Here's the amended code:

```{r}
testurl <- "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2017/09/Dementia-Data-Collection-Q1-2017-18-CSV-35KB.csv"
#using readLines because we cannot easily remove lines using read.csv
linestoclean <- readLines(url(testurl))
#The CSV has column headings in row 12, so we need to remove the first 12 lines
#see https://stackoverflow.com/questions/31824721/delete-lines-of-a-text-file-in-r
skip12rows <- linestoclean[-(1:12)]
#Now convert to datafram, reading the new top line as headings
#See https://stackoverflow.com/questions/15860071/read-csv-header-on-first-line-skip-second-line
withheadings = read.csv(textConnection(skip12rows), header = TRUE, stringsAsFactors = FALSE)
#Each month has 9 columns of data, followed by an empty column. The first 2 columns have the areas. So first we grab the 2 columns of labels...
monthlabels <- withheadings[c(1,2)]
#...plus 9 columns of data:
month1 <- withheadings[c(3:11)]
month2 <- withheadings[c(13:21)]
month3 <- withheadings[c(23:31)]
#Next we add the labels to each sheet
month1 <- cbind(monthlabels,month1)
month2 <- cbind(monthlabels,month2)
month3 <- cbind(monthlabels,month3)
#Extract the months from the original uncleaned data
dates <- strsplit(linestoclean[12],",")
#add a column which specifies the month
month1name <- dates[[1]][[3]]
month2name <- dates[[1]][[13]]
month3name <- dates[[1]][[23]]
month1$month <- month1name
month2$month <- month2name
month3$month <- month3name
#make the column names all the same - otherwise rbind will throw an error
colnames(month2) <- colnames(month1)
colnames(month3) <- colnames(month1)
#Combine all three
months1to3 <- rbind(month1, month2, month3)
#Remove the unneeded months
rm(month1,month1name,month2,month2name,month3,month3name,monthlabels)
```



## Storing the steps in a function

Now to take the steps outlined above and store them in two functions - one for XLS and one for CSV. To make it easier to understand, we need to rename a couple of variables: `url` and the XLS file stored locally, which this time we call "workingfile.xlsx".

```{r}
cleanquarterxls <- function(url){
  #Note: you will need the httr and readxl packages installed first
  GET(url, write_disk("workingfile.xlsx", overwrite=TRUE))
  #Each month has 9 columns of data, followed by an empty column. The first 2 columns have the areas. So first we grab the 2 columns of labels...
  monthlabels <- read_excel("workingfile.xlsx", sheet=2, skip=12)[1:2]
  #...plus 9 columns of data:
  month1 <- read_excel("workingfile.xlsx", sheet=2, skip=12)[3:11]
  month2 <- read_excel("workingfile.xlsx", sheet=2, skip=12)[13:21]
  month3 <- read_excel("workingfile.xlsx", sheet=2, skip=12)[23:31]
  #Next we add the labels to each sheet
  month1 <- cbind(monthlabels,month1)
  month2 <- cbind(monthlabels,month2)
  month3 <- cbind(monthlabels,month3)
  #add a column which specifies the month
  month1name <- read_excel("workingfile.xlsx", sheet=2, skip=6)[3]
  month2name <- read_excel("workingfile.xlsx", sheet=2, skip=6)[13]
  month3name <- read_excel("workingfile.xlsx", sheet=2, skip=6)[23]
  month1$month <- colnames(month1name)
  month2$month <- colnames(month2name)
  month3$month <- colnames(month3name)
  #make the column names all the same - otherwise rbind will throw an error
  colnames(month2) <- colnames(month1)
  colnames(month3) <- colnames(month1)
  #Combine all three
  months1to3 <- rbind(month1, month2, month3)
  #Remove the unneeded months
  rm(month1,month1name,month2,month2name,month3,month3name,monthlabels)
  return (months1to3)
}
```

And here's the function for csv:

```{r}
cleanquartercsv <- function(url){
  #using readLines because we cannot easily remove lines using read.csv
  linestoclean <- readLines(url(url))
  #The CSV has column headings in row 12, so we need to remove the first 12 lines
  #see https://stackoverflow.com/questions/31824721/delete-lines-of-a-text-file-in-r
  skip12rows <- linestoclean[-(1:12)]
  #Now convert to datafram, reading the new top line as headings
  #See https://stackoverflow.com/questions/15860071/read-csv-header-on-first-line-skip-second-line
  withheadings = read.csv(textConnection(skip12rows), header = TRUE, stringsAsFactors = FALSE)
  #Each month has 9 columns of data, followed by an empty column. The first 2 columns have the areas. So first we grab the 2 columns of labels...
  monthlabels <- withheadings[c(1,2)]
  #...plus 9 columns of data:
  month1 <- withheadings[c(3:11)]
  month2 <- withheadings[c(13:21)]
  month3 <- withheadings[c(23:31)]
  #Next we add the labels to each sheet
  month1 <- cbind(monthlabels,month1)
  month2 <- cbind(monthlabels,month2)
  month3 <- cbind(monthlabels,month3)
  #Extract the months from the original uncleaned data
  dates <- strsplit(linestoclean[12],",")
  #add a column which specifies the month
  month1name <- dates[[1]][[3]]
  month2name <- dates[[1]][[13]]
  month3name <- dates[[1]][[23]]
  month1$month <- month1name
  month2$month <- month2name
  month3$month <- month3name
  #make the column names all the same - otherwise rbind will throw an error
  colnames(month2) <- colnames(month1)
  colnames(month3) <- colnames(month1)
  #Combine all three
  months1to3 <- rbind(month1, month2, month3)
  #Remove the unneeded months
  rm(month1,month1name,month2,month2name,month3,month3name,monthlabels)
  return (months1to3)
}
```


You can also store the function as an R script by selecting **File > New file > R Script** and pasting the same code in there before saving. This can then be shared.

Now to run the function on a different quarter's data:

```{r}
q4201516 <- cleanquartercsv("https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2016/11/Dementia-Data-Collection-Q4-2015-16-REVISED-CSV-30KB.csv")
```

This time we get an `undefined columns selected` error because there *is* no column 31 - this data only runs to column AC in Excel, or 29. The data is different, so we're going to need to export what we have before dealing with the the rest differently, and combining them manually. First...

## Looping through scraped URLs

I've scraped the URLs separately (see notebook in this repo) and stored in a dataframe called psdfsubset. 

```{r}
#Add the URL
months1to3$url <- "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2017/09/Dementia-Data-Collection-Q1-2017-18-CSV-35KB.csv"
for (i in 1:length(psdfsubset$url)){
  #Run our custom function on the URL
  newdata <- cleanquartercsv(psdfsubset$url[i])
  #Add the URL to our temporary data frame
  newdata$url <- psdfsubset$url[i]
  #Combine the new dataframe to the one we first created
  months1to3 <- rbind(months1to3,newdata)
}
```

This does result in some duplication because in some months there is both an original quarterly CSV and then a revised CSV. An extra column can be created to show whether the data is revised or not, and then filter accordingly:

```{r}
months1to3$revised <- grepl("REVISED", months1to3$url)
table(months1to3$revised)
```

Now to export:

```{r}
write.csv(months1to3, "dementia201617.csv")
```


## Adapting for different data

Here's our problematic line from before:

```{r}
q4201516 <- cleanquartercsv("https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2016/11/Dementia-Data-Collection-Q4-2015-16-REVISED-CSV-30KB.csv")
```

We've checked the CSV in Excel and see it has 29 columns of data. That's 4 sets of 6 columns for each month (24), plus the two columns with the name and code, plus a gap between each month. We just need to adapt the indexes used by the function

```{r}
cleanquartercsv6cols <- function(url){
  #using readLines because we cannot easily remove lines using read.csv
  linestoclean <- readLines(url(url))
  #The CSV has column headings in row 13, so we need to remove the first 13 lines
  #see https://stackoverflow.com/questions/31824721/delete-lines-of-a-text-file-in-r
  skip13rows <- linestoclean[-(1:13)]
  #Now convert to datafram, reading the new top line as headings
  #See https://stackoverflow.com/questions/15860071/read-csv-header-on-first-line-skip-second-line
  withheadings = read.csv(textConnection(skip13rows), header = TRUE, stringsAsFactors = FALSE)
  #Each month has 6 columns of data, followed by an empty column. The first 2 columns have the areas. So first we grab the 2 columns of labels...
  monthlabels <- withheadings[c(1,2)]
  #...plus 6 columns of data:
  month1 <- withheadings[c(3:8)]
  month2 <- withheadings[c(10:15)]
  month3 <- withheadings[c(17:22)]
  #Next we add the labels to each sheet
  month1 <- cbind(monthlabels,month1)
  month2 <- cbind(monthlabels,month2)
  month3 <- cbind(monthlabels,month3)
  #Extract the months from the original uncleaned data
  #print(linestoclean[13])
  dates <- strsplit(linestoclean[13],",")
  #add a column which specifies the month
  #print (dates[[1]])
  month1name <- dates[[1]][[3]]
  month2name <- dates[[1]][[10]]
  month3name <- dates[[1]][[17]]
  month1$month <- month1name
  month2$month <- month2name
  month3$month <- month3name
  #make the column names all the same - otherwise rbind will throw an error
  colnames(month2) <- colnames(month1)
  colnames(month3) <- colnames(month1)
  #Combine all three
  months1to3 <- rbind(month1, month2, month3)
  #Remove the unneeded months
  rm(month1,month1name,month2,month2name,month3,month3name,monthlabels)
  return (months1to3)
}
```

A better way to do this would be to create one function which includes an extra parameter: the number of columns being grabbed. If it was 9 it would grab the relevant columns, and if 6 likewise. However, we also have headings in a different row so for now we leave it as two separate functions.

Now to run that on the problematic CSV:

```{r}
q4201516 <- cleanquartercsv6cols("https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2016/11/Dementia-Data-Collection-Q4-2015-16-REVISED-CSV-30KB.csv")
q4201516$url <- "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2016/11/Dementia-Data-Collection-Q4-2015-16-REVISED-CSV-30KB.csv"
table(q4201516$month)
```

And now on all the other CSVs from that year:

```{r}
q3201516 <- cleanquartercsv6cols("https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2016/05/Dementia-Data-Collection-Q3-2015-16-REVISED-CSV-30KB.csv")
q3201516$url <- "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2016/05/Dementia-Data-Collection-Q3-2015-16-REVISED-CSV-30KB.csv"
table(q3201516$month)
q2201516 <- cleanquartercsv6cols("https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2016/05/Dementia-Data-Collection-Q2-2015-16-REVISED-CSV-30KB.csv")
q2201516$url <- "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2016/05/Dementia-Data-Collection-Q2-2015-16-REVISED-CSV-30KB.csv"
table(q2201516$month)
q1201516 <- cleanquartercsv6cols("https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2015/11/Dementia-Data-Collection-Q1-2015-16-REVISED-CSV-32KB.csv")
q1201516$url <- "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2015/11/Dementia-Data-Collection-Q1-2015-16-REVISED-CSV-32KB.csv"
table(q1201516$month)
```

Now to combine them, and export as a CSV:

```{r}
dementia1516 <- rbind(q1201516,q2201516,q3201516,q4201516)
write.csv(dementia1516,"dementia201516.csv")
```

### 2014-15 data

When it comes to 2014-15 the spreadsheets revert to 9 columns again, but the scraping function doesn't work:

```{r}
urls1415 <- scrapeQuarterlyCsvLinks("https://www.england.nhs.uk/statistics/statistical-work-areas/dementia/dementia-assessment-and-referral-2014-15/")
urls1415
```

We could adapt it, but it's quicker to do it manually again:

```{r}
urls1415 <- c("https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2014/11/Dementia-Data-Collection-Q1-2014-15-REVISED-CSV-35KB.csv","https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2014/07/Dementia-Data-Collection-Q2-2014-15-REVISED-CSV-36KB.csv","https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2014/07/Dementia-Data-Collection-Q3-2014-15-REVISED-CSV-36KB.csv","https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2014/07/Dementia-Data-Collection-Q4-2014-15-CSV-37KB.csv")
#Loop through URLs
for (i in 1:length(urls1415)){
  tempdata <- cleanquartercsv(urls1415[i])
  tempdata$url <- urls1415[i]
  #Create a variable with q followed by the number
  #Run our custom function on the URL, and assign that to the new variable
  assign(paste("q",i,sep=""), tempdata)
}
```

Now we try to combine the datasets - but it throws an error:

```{r}
dementia1415 <- rbind(q1,q2,q3,q4)
```

One of the columns isn't named the same - here's how to find out:

```{r}
#These will return a list of TRUE or FALSE based on whether each column name matches
colnames(q1) == colnames(q2)
colnames(q2) == colnames(q3)
colnames(q2) == colnames(q4)
#It looks like column 8 in quarter 1 isn't the same as the others. Let's compare them:
colnames(q1)[8]
colnames(q4)[8]
```

Remember the other columns all match, so this isn't a column in the wrong place. So now we need a judgement call whether it's just a different term for the same thing. Certainly that seems likely - would they remove one measure and add a different one just for one month? We can see how similar the measurements are, though:

```{r}
(q1)[8]
(q4)[8]
```
The difficulty is that we're comparing different quarters, and seasonal variations may affect this. Ideally we need to compare the same period during the previous year.

Let's play it safe by removing the values and creating an empty column for that month, or at least one which explains why there is no data

```{r}
#First export the data before we change it
write.csv(q1,"q1201415original.csv")
#Now replace the values
q1[8] <- "replaced with 'Percentage.of.cases.further.assessed' in this CSV"
#Give the data the same column names as the others so we can use rbind without error
colnames(q1) <- colnames(q2)
#Combine the 4 data frames
dementia1415 <- rbind(q1,q2,q3,q4)
#Export as CSV
write.csv(dementia1415,"dementia201415.csv")
```

### Grabbing data for 2013-14

Our final set of CSVs is at `https://www.england.nhs.uk/statistics/statistical-work-areas/dementia/dementia-assessment-and-referral-2013-14-2/`. Again it has 9 columns for each month.

```{r}
urls1314 <- c("https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2014/05/Dementia-Data-Collection-Q1-2013-14-Revised-July2015-CSV-39KB.csv","https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2014/05/Dementia-Data-Collection-Q2-2013-14-REVISED-CSV-40KB.csv","https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2014/05/Dementia-Data-Collection-Q3-2013-14-REVISED-CSV-38KB.csv", "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2014/05/Dementia-Data-Collection-Q4-2013-14-CSV-36KB.csv")
#Loop through URLs
for (i in 1:length(urls1314)){
  tempdata <- cleanquartercsv(urls1314[i])
  tempdata$url <- urls1314[i]
  #Create a variable with q followed by the number
  #Run our custom function on the URL, and assign that to the new variable
  assign(paste("q",i,sep=""), tempdata)
}
```

Now we try to combine the datasets - but again it throws an error:

```{r}
dementia1314 <- rbind(q1,q2,q3,q4)
```

Let's try to compare column names again:

```{r}
#These will return a list of TRUE or FALSE based on whether each column name matches
colnames(q1) == colnames(q2)
colnames(q2) == colnames(q3)
colnames(q2) == colnames(q4)
colnames(q1) == colnames(q4)
```

Ouch. This is a mess. At least we know quarters 2 and 3 are the same. Let's get some detail:

```{r}
colnames(q1) 
colnames(q2)
colnames(q4)
```

So it looks like quarters 2 and 3 actually have the column headings from the row above where they normally go. The difference between q1 and q4 is a slight inconsistency in naming, but it's the same data. Let's check the first row of q2, which should contain the *real* column headings:

```{r}
q2[1,]
q3[1,]
```

We could use that to replace the column names like this: `colnames(q2) <- q2[1,]`.

However, it's better to write a new function which takes the correct row - because that function also grabs the months and allocates them to each month, which we can't do so easily at this point.

```{r}
cleanquartercsv.fromrow13 <- function(url){
  #using readLines because we cannot easily remove lines using read.csv
  linestoclean <- readLines(url(url))
  #The CSV has column headings in row 12, so we need to remove the first 12 lines
  #see https://stackoverflow.com/questions/31824721/delete-lines-of-a-text-file-in-r
  skip13rows <- linestoclean[-(1:13)]
  #Now convert to datafram, reading the new top line as headings
  #See https://stackoverflow.com/questions/15860071/read-csv-header-on-first-line-skip-second-line
  withheadings = read.csv(textConnection(skip13rows), header = TRUE, stringsAsFactors = FALSE)
  #Each month has 9 columns of data, followed by an empty column. The first 2 columns have the areas. So first we grab the 2 columns of labels...
  monthlabels <- withheadings[c(1,2)]
  #...plus 9 columns of data:
  month1 <- withheadings[c(3:11)]
  month2 <- withheadings[c(13:21)]
  month3 <- withheadings[c(23:31)]
  #Next we add the labels to each sheet
  month1 <- cbind(monthlabels,month1)
  month2 <- cbind(monthlabels,month2)
  month3 <- cbind(monthlabels,month3)
  #Extract the months from the original uncleaned data
  dates <- strsplit(linestoclean[13],",")
  #add a column which specifies the month
  month1name <- dates[[1]][[3]]
  month2name <- dates[[1]][[13]]
  month3name <- dates[[1]][[23]]
  month1$month <- month1name
  month2$month <- month2name
  month3$month <- month3name
  #make the column names all the same - otherwise rbind will throw an error
  colnames(month2) <- colnames(month1)
  colnames(month3) <- colnames(month1)
  #Combine all three
  months1to3 <- rbind(month1, month2, month3)
  #Remove the unneeded months
  rm(month1,month1name,month2,month2name,month3,month3name,monthlabels)
  return (months1to3)
}
```

Now to run it on those 2 quarters

```{r}
for (i in 2:3){
  tempdata <- cleanquartercsv.fromrow13(urls1314[i])
  tempdata$url <- urls1314[i]
  #Create a variable with q followed by the number
  #Run our custom function on the URL, and assign that to the new variable
  assign(paste("q",i,sep=""), tempdata)
}
```

Now let's test the column headings again:

```{r}
#These will return a list of TRUE or FALSE based on whether each column name matches
colnames(q1) == colnames(q2)
colnames(q2) == colnames(q3)
colnames(q2) == colnames(q4)
colnames(q1) == colnames(q4)
```

This is better. Quarter 1 is the odd one out when it comes to naming columns 1 and 2 right. This will be fixed when we give it the same column names:

```{r}
colnames(q1)  <- colnames(q4) 
#test again
colnames(q1) == colnames(q2)
colnames(q2) == colnames(q3)
colnames(q2) == colnames(q4)
colnames(q1) == colnames(q4)
```

So we can combine them:

```{r}
#Combine the 4 data frames
dementia201314 <- rbind(q1,q2,q3,q4)
#Export as CSV
write.csv(dementia201314,"dementia201314.csv")
```

Now we just need to combine in Open Refine and do final cleaning in Excel...
