# Cleaning data on GP surgeries

This notebook details the process of cleaning a dataset on GP surgeries. The data comes from over 9000 pages across the NHS Choices service.

First, we import the data, which has been exported to CSV:

```{r}
surgerydata <- read.csv('https://premium.scraperwiki.com/lwymkqp/p4qu9fjxnhi67o8/cgi-bin/csv/surgerydetails.csv')
```

Let's get an idea of the data:

```{r}
head(surgerydata)
```

We're particularly interested in opening times. But the data here is mixed:

* We have a day of the week
* We have at least one period of opening on that day
* Sometimes there is at least one more period of opening on the day

There is an assumption that we have grabbed the right day. For example, the field 'openingmonclean' is for Monday opening hours - but we've made sure to grab the full text just in case. Let's test if they are indeed all Mondays.

To do that we're using the `stringr` library and its `str_match` function. The results are then put in a summary to provide a count of different instances...

```{r}
library(stringr)
summary(str_match(surgerydata$openingmonclean, ".*day"))
```

We can see that there are almost 7000 saying 'Monday'. What about the other columns?

```{r}
table(str_match(surgerydata$openingtueclean, ".*day"))
table(str_match(surgerydata$openingwedclean, ".*day"))
table(str_match(surgerydata$openingthuclean, ".*day"))
table(str_match(surgerydata$openingfriclean, ".*day"))
table(str_match(surgerydata$openingsatclean, ".*day"))
table(str_match(surgerydata$openingsunclean, ".*day"))
```

They all tally, which is a good sign. Let's put it in a new column:

```{r}
#Grab matches 
surgerydata$daymon <- str_match(surgerydata$openingmonclean, ".*day")
surgerydata$daymon <- sub(" ","",surgerydata$daymon)
summary(surgerydata$daymon)
```


Looking at some of those rows it is likely that these surgeries do not show opening hours at all. We can test this by creating a subset using `is.na` to filter those with NA results:

```{r}
nomonday <- subset(surgerydata,is.na(surgerydata$daymon))
table(nomonday$tableheading)
#this uses !is.na to indicate NOT NA
monday <- subset(surgerydata,!is.na(surgerydata$daymon))
table(monday$tableheading)
```

## Extracting the gender

The gender column is pretty structured so we can split it at the word 'male' using the `tidyr` package

```{r}
library("tidyr", lib.loc="/Library/Frameworks/R.framework/Versions/3.4/Resources/library")
#using https://stackoverflow.com/questions/7069076/split-column-at-delimiter-in-data-frame
gendersplit <- separate(data = monday, col = gender, into = c('male','female'), sep = " male")
#Select just some columns to make a smaller file
gendersplitsmall <- gendersplit[c(1,6,7,9,10,12,15,17,20,21,22)]
write.csv(gendersplitsmall,"gendersplit.csv")
```


## Extracting the times

The opening hours look like this: "Monday 08:40 - 13:0014:00 - 19:15". How can we convert that into a number of hours? It might help to identify the pattern in those cells:

* There's the day and a space: "Monday "
* There's 2 numbers, followed by a colon, and another two numbers
* A space and dash
* There's another 2 numbers, followed by a colon, and another two numbers
* Sometimes another pair of 2 numbers separated by a dash - but without a space
* There may be a third pair of numbers

Here's a stab at a sequence:

* Remove the word 'Monday', and any spaces
* 



```{r}
#Let's create a smaller dataset to experiment with
monsmall <- monday[c(1,2)]
monsplit <- separate(data = monsmall, col = openingmonclean, into = c('delete','keep'), sep = "Monday")
#Instead we can use extract https://stackoverflow.com/questions/32119963/r-split-string-using-tidyrseparate
monsplit <- separate(data = monsplit, col = keep, into = c('first','second'), sep = "[0-9][0-9]:[0-9][0-9]")

#grep("Monday [0-9][0-9]:[0-9][0-9]","Monday 08:40 - 13:0014:00 - 19:15", value=T)
#Pull times into a separate data frame to play with

```

