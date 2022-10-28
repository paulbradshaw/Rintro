# Cleaning data in R

[Wikipedia's entry on dirty data](https://en.wikipedia.org/wiki/Dirty_data) defines it as:

> “Dirty data, also known as rogue data, are inaccurate, incomplete or inconsistent data, especially in a computer system or database.”

We can also add data that is **inconvenient or incompatible** - areas where R, and the `tidyverse` in particular, come in very useful.

This notebook details some techniques in R for working with dirty data.

## Inconvenient data: wrong shape

One of the most common situations that might require us to clean data is when that data is not in the right 'shape' for the analysis we want to perform. Problems include:

* Headings not on the first row
* Headings on multiple rows
* Empty rows
* Wide or long data that we want to be the other way around
* Merged rows

Many of these problems can be fixed by using the **parameters** in functions for importing data.

To illustrate, let's use a spreadsheet with a number of problems. 

## Import the `readxl` package

First, we need to import a package for dealing with spreadsheets. The `readxl` package is a collection of functions for dealing with Excel spreadsheets. It should already be installed in RStudio so you don't need to run the `install.packages` function below - you only need to activate the package using `library`.

We also install the `tidyverse`:

```{r install packages}
#import the readxl package 
##install.packages("readxl")
library(readxl)
#install the tidyverse
library(tidyverse)
```

## Cleaning on import: redundant rows

Let's start with a dataset that has redundant rows. One example would be NHS Digital data on [Potential years of life lost (PYLL) from causes considered amenable to healthcare](https://digital.nhs.uk/data-and-information/publications/statistical/ccg-outcomes-indicator-set/october-2022/domain-1-preventing-people-from-dying-prematurely-ccg/1-1-potential-years-of-life-lost-pyll-from-causes-considered-amenable-to-healthcare).

Specifically, we've downloaded the file named 'Indicator data (.xlsx)'.

There are some other files here which are likely to be important in understanding the data, but for now let's just tackle the first problem: importing the data.

First, we need to specify where the data is. In the code below we store its location in a string variable called 'pylldatafile', and then import that using the `readxl` function `read_excel()`. Finally we use the R function `head()` show the first few rows of the resulting data frame. 

```{r import pyll data}
#data can also be downloaded from "https://files.digital.nhs.uk/32/9733FB/CCG_1.1_I00767_D.xlsx"
#store the filename in a variable
pylldatafile <- "CCG_1.1_I00767_D.xlsx"
#use that variable to read it from that
pylldata <- readxl::read_excel(pylldatafile)
#show the first few rows
head(pylldata)
```
We can see immediately that this data is inconvenient: instead of column headings it has some title information in the first row. This means that the `read_excel()` function has treated that title information as the column names.

To fix that, we can add some optional parameters to the `read_excel()` function. 

Parameters for a function are listed and described in **documentation**. [For the read_excel function](https://readxl.tidyverse.org/reference/read_excel.html) those parameters include a number of extra options.

In particular, `skip =` is a parameter we can use to ask it to skip rows before the header row.

To work out how many rows we need to skip, we could open the file up in Excel, or look at different parts of it in R. 

After doing so, we might see that the column headings are actually in row 22 - so we need to skip the first 21. 

```{r re-import with skip rows}
#import the data again - this time skipping the first 4 rows
pylldata <- readxl::read_excel(pylldatafile, skip = 21)

#show the first few rows
head(pylldata)
```
That seems to have fixed the problem. However, always make sure you take a look at the data that you've left out, in case it might be important in understanding the remaining data. In this case those header rows do include some contextual information on the source, period covered, and methodology.

## Cleaning: empty rows 

Empty rows can be dropped by [using the `drop_na()` function](https://tidyr.tidyverse.org/reference/drop_na.html).

This will remove rows where there is an `NA` in a column you specify. For that reason you need to be absolutely sure that the column in question *always* has a value *apart* from when the entire row is empty.

```{r import and use drop_na}
#import some data - it should have 352 rows
disposals <- readxl::read_excel("Disposals by region 2012-13 Table.xls", skip = 1)
#show the first few rows - note the empty one with NA in it
head(disposals)
disposals_cleaned <- drop_na(disposals, Female)
#remove rows from the data frame 'disposals' where the column 'Female' has NA in it.
#this has 230 rows
head(disposals_cleaned)
#or we can remove by 'piping' the results of using read_excel into the drop_na function
#this time we don't have to name the dataframe because we've 'piped' it already
disposals <- readxl::read_excel("Disposals by region 2012-13 Table.xls", skip = 1) %>%
  drop_na(Female)
```


## Inaccurate data: wrong data type

When data is imported into R, a guess is made about the type of data in each column. It is not possible to have mixed data in a column in an R data frame - so if a column has a mix of numbers and text, it will be categorised as a text ('character') column.

Let's demonstrate with some data - we import it first:

```{r import data again}
#store the filename in a variable
pylldatafile <- "CCG_1.1_I00767_D.xlsx"
#use that variable to read it from that
pylldata <- readxl::read_excel(pylldatafile, skip = 21)
#show the first few rows
head(pylldata)
```

Note at the top of each column under its name is a description of the data type in each column: for the first four columns that type is `<chr>`, or 'character' (strings). 

Later columns are `<dbl>` or 'double' (numeric).

The first column shows years, which are numeric, so why has it classed it as a character field?

We can get an overview of the unique values in that column by using the `table()` function on that field:

```{r table of periods}
#show the values in the Reporting period column
table(pylldata$`Reporting period`)
```

You can see that some reporting periods are not a single year, but instead a period covering multiple years, such as '2009-2011'.

Instead of letting R guess the data types in each data frame we can force it to treat it in a certain way with an extra parameter in the `read_excel` function: `col_types = `

Unless you want to specify that all the columns are the same type, you need to specify the types of columns as a list of strings, using a vector, like so: 

`col_types = c("numeric", "text")`

The number of strings in the vector should be the same as the number of columns, and the types can be "blank", "numeric", "date" or "text".

This data frame has 12 columns, so we need a vector of 12 data types:

```{r import and specify data types}
pylldata <- readxl::read_excel(pylldatafile, skip = 21, col_types = c("numeric","text","text","text","text","text","numeric","numeric","numeric","numeric","numeric","numeric"))
```

When you run that code you'll get a number of warnings where a particular piece of data doesn't fit the type specified. Each will say: 'Expecting numeric in ... got ...'

Where it doesn't find the type of data it expects, the data will be removed and replaced with `NA`. When we repeat the `table()` function to get a count of each value, we'll see the combined year ranges now don't appear. 

```{r repeat table of periods}
#show the values in the Reporting period column
table(pylldata$`Reporting period`)
```

Those numbers don't add up to the same number of rows ('observations') in the data frame, because it's not counting the `NA` values.

To find out how many there are we can use the `is.na()` function. This will return a vector of `TRUE` and `FALSE` for each item in the column, depending on whether it is an `NA` value. 

If we place the results of that inside a `sum()` function it will count each `TRUE` as 1, giving us a total of `NA` entries:

```{r sum na}
#add up all the TRUE values produced by using is.na on the period column
sum(is.na(pylldata$`Reporting period`))
```

### Splitting a column using `separate()`

Now in this example we probably don't want to lose this information, so we might adopt a different approach, but in other cases we might be happy to do so (especially if the data has been copied to another column).

We can split one column into multiple columns [using the `separate()` function](https://tidyr.tidyverse.org/reference/separate.html) from the `tidyr` library.

Below you can see it used to create a new variable. The function has a number of parameters, each separated by a comma. I've put each new parameter onto a new line to make it easier to read, but you don't have to do this. 

The parameters specify: 

* the name of the dataframe, 
* the name of the column being split, 
* the names of the new columns that you want to create to contain the new information that's split out from the existing column (those names have to be in a vector)
* the separator you're splitting on (in this case, a dash)
* whether you want to remove the original column. By default this is set to `TRUE` so if you want to keep the old column then you need to set this to `FALSE`

```{r split years from and to}
#import the data again
pylldata <- readxl::read_excel(pylldatafile, skip = 21)
#use the separate function
pylldata_step2 <- tidyr::separate(data = pylldata, 
                                  col = `Reporting period`, 
                                  into = c("fromyr","toyr"), 
                                  sep = "-",
                                  remove = FALSE)
#show the results
head(pylldata_step2)
```

Now we have two new columns after the old one. 

There's another way to do this, which is to 'pipe' (using `%>%`) the results of the import into a `separate` function. The code is below - note that this time you don't specify the `data =` parameter because the pipe is specifying that for you:

```{r import and pipe separate}
#import the data AND pipe it into the separate function. This time don't specify data =
pylldata <- readxl::read_excel(pylldatafile, skip = 21) %>% 
  tidyr::separate(col = `Reporting period`, into = c("fromyr","toyr"), sep = "-", remove = FALSE)
#show the results
head(pylldata)
```

We can also reformat the columns by using `as.numeric()` like so:

```{r reformat column as numeric}
pylldata$toyr <- as.numeric(pylldata$toyr)
pylldata
```


## Cleaning: headers across multiple rows 

Another common problem is data where headers aren't just in one row, but across several.

Surprisingly, no one seems to have created a simple way of tackling the problem of headers across multiple rows. Instead there is a [series of steps](https://stackoverflow.com/questions/17797840/reading-two-line-headers-in-r) to create a list of column headings. 

Broadly speaking you need to do the following:

1. Download the dataset using `skip =` to skip all but the last row of headings 
2. Download the other heading row(s) separately. 
3. Change the column names of your full/main dataset - typically by combining them with the text you downloaded from the other heading rows

Some functions and parameters you will need to do this include:

* The `skip =` parameter in the `read_excel` function (or similar functions for other formats) 
* The `n_max =` parameter in the `read_excel` function (or similar functions for other formats) 
* The `names()` function, which extracts the names of the columns in a data frame, and can also be used to change those names. The `colnames()` function does the same thing too.
* The `paste()` function for combining two or more pieces of text. If you use it with vectors of text strings then it will combine those with each other too. It will add a space in between - but you can use the function `paste0()` to combine text without a space instead if you prefer.

The `n_max =` parameter specifies a maximum number of rows to import. If it's set to 0 then it won't import any rows - but it will still import the headings. 

```{r import with n_max}
#import the data - skip 21 rows and import 0 rows of data (so just the heading row)
justsomeheadings <- readxl::read_excel(pylldatafile, skip = 21, n_max = 0)

#show the first few rows
print(justsomeheadings)
print(names(justsomeheadings))
```

The `names` function extracts the column names from a dataframe:

```{r show column names}
#show column names
names(pylldata)
```

The result of the `names()` function is a vector - and we can change individual items in that vector by specifying their position in square brackets and assigning a new value to that.


```{r change column names}
#rename the first column name
names(pylldata)[1] <- "report_period"
#show column names
names(pylldata)
```


If we create a vector the same length as the column name vector then we can replace the entire column names vector with that.

We can also combine two vectors by using `paste()` like so:

```{r combine two vectors}
genders <- c("Male","Female")
units <- c("incidents", "percentages")
#combine the two vectors
twocombined <- paste(genders, units)
twocombined
```

Or we can add one string to all the strings in a vector like so:


```{r combine a vector with a string}
genders <- c("Male","Female")
#combine the vector with a string
vecandstring <- paste(genders, "total")
vecandstring
```


If you want a dataset to practise this technique you can download a Google Sheet on missing people from https://docs.google.com/spreadsheets/d/e/2PACX-1vQAkECgBEtlNoqBsupWwaAjG90rbQRqGW9x0qMrNVjwygskoz2keQNy9e2DMlnmSwad8iJprKSyKf1y/pub?output=xlsx - this actually has headings across 3 rows so it's even more fiddly than usual.

