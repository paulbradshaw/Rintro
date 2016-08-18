# 10 things to do next in R

Once you've done [the first 10 things in R detailed here](https://github.com/paulbradshaw/Rintro), it's time to start playing with packages...

## 1. Install a package and use it

As well as the built in functions in R there are dozens of extra ones you can access by installing **packages** (there are also *methods*, which work in much the same way - don't worry about whether it's a function or a method). 

For example, there are packages to help create particular types of visualisation, packages to deal with particular types of data (including text), packages to do particular forms of statistical analysis, and so on.

If you've used other languages like JavaScript and Python, packages are the same as *libraries* in those languages.

To find a useful package search for 'package R' and your particular challenge, e.g. 'package R text counting'.

To install a package you type `install.packages` followed by the name of the package in parentheses and quotation marks like so:

`install.packages("dplyr")`

Once installed it should appear in your packages list which can be accessed in the bottom right corner, under the 'Packages' tab, or by selecting the **View** menu in R and then **Show Packages**. You'll notice that RStudio comes with a whole bunch of common packages already listed here, so they don't need installing anyway - but they do need activating.

To *use* the package, then, you need to activate it. One way is by using the `library` command like so:

`library("dplyr")`

However, you can also just tick the box next to the particular package in the package list, which will run the same command in the console.

The `dplyr` package is particularly useful for arranging, formatting, and combining data. For example...

## 2. Join two datasets from different periods or areas

If you have two different datasets with the same columns, but for different years or time periods, you might want to join those. Or perhaps you have data with the same columns and time period for a number of regions.

As always, you need to import them into variables in R as explained earlier.

To join those you can use the `bind_rows` function from the `dplyr` package.

Here's an example:

`bothyears <- bind_rows(2014data,2015data)`

As always 'bothyears' above can be any name you want to give it, and the two variables named in parentheses need to be the names of *your* data table variables.

If you haven't activated the `dplyr` package you will get the following error:

`Error: could not find function "bind_rows"`

In that case, make sure you go to your Packages list and tick the box next to dplyr, or type this command into R: `library("dplyr")`

## 3. Import data from a URL

Importing data from a URL is the same as importing data locally, but you just need to put the URL in parentheses after the function `url` like so:

`mynewdata <- read.csv(url('http://thewebsite.com/thefolder/thefile.csv'))`

## 4. Import JSON data from a URL

If the data you want is published by an API, chances are that it's in [JSON format](http://www.w3schools.com/json/). This uses curly brackets, colons and commas to structure the data. (if it's in XML [see this](https://github.com/paulbradshaw/Rintro/blob/master/XMLinR.md)).

To convert JSON data into a data variable that R can work with, use the `jsonlite` library ([documentation here](https://cran.r-project.org/web/packages/jsonlite/jsonlite.pdf)). This should already be installed in RStudio (if not, type `install.packages('jsonlite')`), so you just need to type `library('jsonlite')` to activate it.

Once added to your library, you can use the `fromJSON` function to import JSON data from a URL into a new variable like so:

`mynewjsondata <- fromJSON("https://data.police.uk/api/stops-force?force=avon-and-somerset&date=2015-07")`

All you need to do is replace the URL with the one you've found. (In the example above I'm using data from the UK's police API, which is a good resource to try this out with ([documentation](https://data.police.uk/docs/)).)

You can also use this library to [export data in JSON format too](https://cran.r-project.org/web/packages/jsonlite/vignettes/json-aaquickstart.html): useful if you want to use the data in a JavaScript-based interactive.

If the process above doesn't work it may be that the data is actually in the ['JSON Lines' format](http://jsonlines.org/). [Try the solutions outlined here](https://stackoverflow.com/questions/24514284/how-do-i-import-data-from-json-format-into-r-using-jsonlite-package).

There are also other libraries for handling JSON such as rjson and RJSONIO, [compared with jsonlite here](https://rstudio-pubs-static.s3.amazonaws.com/31702_9c22e3d1a0c44968a4a1f9656f1800ab.html)

## 5. Add comments

It's always a good idea to add comments to your code: partly so you can understand it later, but largely so that others can understand it if they need to. One of the main selling points of R is that it allows you to show your workings, so having comments that explain that is going to be just as important as the code itself.

You can add a comment by just using the hash key like so:

`#This next line imports the data`

`newvar <- read.csv('myfile.csv')`

Anything after a hash is ignored when the code runs. 

You can also add a comment on the same line as the code like so:

`newvar <- read.csv('myfile.csv') #This imports the data`

Python comments are written exactly the same, by the way.

## 6. Import just one sheet from a multi-sheet Excel workbook - and skip annoying irrelevant rows

The [**readxl** package](https://cran.r-project.org/web/packages/readxl/readxl.pdf) is designed to help import Excel files. One of its advantages is the ability to specify which sheet in a workbook you want. First, install it and add it to your library:

`install.packages("readxl")`

`library(readxl)`

To import data you can use the `read_excel` function. This needs two ingredients: the name of the file you want to import (this needs to be in the same working directory as your R project, or you can specify a path), and then the sheet number or name. Here's an example:

`mynewdata <- read_excel('myspreadsheet.xlsx', sheet=3)`

Note that `sheet=3` does indeed mean the 3rd sheet (normally in programming 3 means the 4th item).

You can also specify the name of a sheet by putting it as a string like so:

`mynewdata <- read_excel('myspreadsheet.xlsx', sheet='crimes')`

You actually don't need to specify `sheet=`. Instead you can just write: `mynewdata <- read_excel('myspreadsheet.xlsx', 'crimes')` or `mynewdata <- read_excel('myspreadsheet.xlsx', 3)`

The [documentation](https://cran.r-project.org/web/packages/readxl/readxl.pdf) outlines other parameters you can use. For example, government Excel files often contain many lines of description before the data itself. You can omit these by using the `skip=` parameter like so:

`mynewdata <- read_excel('myspreadsheet.xlsx', sheet=3, skip=4)`

This will skip the first 4 rows, then assume the 5th row contains your headings. If there is no heading row you can also add `col_names=FALSE`

## 7. Import an Excel (or any other) file from a URL

Grabbing an Excel workbook from a URL is similar to importing it from your own computer. The difference is you need to store the workbook somehow. We do this using [the **httr** package](https://cran.r-project.org/web/packages/httr/httr.pdf) for handling URLs and HTTP. Make sure it's installed and added to your library:

`library(httr)`

Now store the URL in a variable: it doesn't matter what it's called but in the example below I've simply called it 'url':

`url <- 'https://www.gov.uk/government/uploads/system/uploads/attachment_data/file/541057/SFR27_2016_Main_Tables.xlsx'`

Next, use `GET`, which is a method from the httr package

`GET(url, write_disk("newfile.xlsx", overwrite=TRUE))`

This actually grabs the file at that location and saves it (`write_disk`) to your project's working directory with the name specified (here it's `"newfile.xlsx"` but can be anything). The `overwrite` bit just allows it to save over anything that has that name.

If you go to your project folder now you should see it there. By the way, you don't really need to store the URL in its own variable: you could write it directly into the `GET` command like so: `GET('https://www.gov.uk/government/uploads/system/uploads/attachment_data/file/541057/SFR27_2016_Main_Tables.xlsx', write_disk("newfile.xlsx", overwrite=TRUE))`

Now you can just import it as you do any local file like so:

`mynewdata <- read_excel("newfile.xlsx", sheet=3, skip=4)`

## 8. Get rid of unwanted columns from your data

If you are dealing with a large dataset and don't need certain columns, you can drop them like so:

`mydata$thecolumnname <- NULL`

Obviously the name before the dollar sign (your table name) will be different, and likewise the name after (the name of the field in your table that you want to get rid of). 

## 9. Getting rid of more than one column based on position

You can also select columns based on their position: for example, the 1st, 2nd, and so on. This, for example, will get rid of all columns apart from the first one:

`mydata <- mydata[ 1 ]`

The code here is taking the first column from `mydata` and putting that in a variable. But because the variable has the same name, this has the effect of overwriting the old one, which means all the other columns now don't exist.

This number in square brackets is called an **index**: it means a position. Often indexes begin counting from 0 in programming (what's called a *zero-based index*) but here it starts from 1 (a *1-based index*), so `[1]` means the first column in this example.

You could of course also store it instead in a new variable like so:

`firstcolumn <- mydata[ 1 ]`

If you're worried about losing data this might be a better option, so you can check the results before deleting the old one.

A negative number allows you to select everything *apart from* the column specified. For example this code will select all columns *except for* the first one, and place it in the new variable: 

`mostofmydata <- mydata[ -1 ]`

Or indeed to change your data variable to remove column 1:

`mydata <- mydata[ -1 ]`

### Selecting multiple columns

You can specify *multiple* columns by using a **vector** like so:

`somecolumns <- mydata[ c(1, 5, 10) ]`

The vector is created with `c( )` and is essentially a list of numbers. So the example above will grab columns 1, 5 and 10 and place them in the variable on the left.

A negative list can be created by placing the minus sign before the `c` like so:

`somecolumns <- mydata[ -c(1, 5, 10) ]`

In that example all columns *apart from* 1, 5 and 10 are put in the variable on the left.

Obviously it would be a bit laborious to type out sequences of numbers like 1, 2, 3 - instead you can just use a colon to indicate a range like so, either within square brackets if it's just one range:

`mydata <- mydata[ 1:4 ]`

Or within a vector if you want to combine a range with other indexes or ranges:

`mydata <- mydata[ c(1:4, 6, 12) ]`

And again you can use a minus to exclude columns. This, for example, will create a new variable containing all columns *apart from* the first four, the 6th and 12th:

`mydata <- mydata[ -c(1:4, 6, 10:12) ]`

Now of course if you're going to be using the same vector (the list of columns to include or exclude) more than once (for example because you have data from different years) you can also store that in a variable like so:

`colstokeep <- c(1:4, 6, 12) `

And then use that much more efficiently:

`mydata <- mydata[ colstokeep ]`

Of course you'll need to be sure that the columns are always in the same position, but if they are this can be very useful.

## 10. Finding the column(s) you need to keep/remove

If you have a spreadsheet with dozens of columns, you don't want to have to count across them in order to work out which ones you need. 
You can use `grep` or `which` to find out the index position of columns that match a particular search criteria. If you are looking for an exact match (you know the exact text in the column heading), `which` is probably best; but if you don't know the exact text, `grep` is going to be better. Here is how they work: first, finding an exact match:

`which(colnames(mydata)=="Expenditure")`

The `which` function tells you *which* items in an object match a particular criteria ([documentation here](https://stat.ethz.ch/R-manual/R-devel/library/base/html/which.html)). In this case the object is the column names in your data variable (called 'mydata' above, but yours will have a different name): `colnames(mydata)`.

To grab the column names you need to use the `colnames` function, [documented here](https://stat.ethz.ch/R-manual/R-devel/library/base/html/colnames.html), followed by your data variable in parentheses.

The criteria is `=="Expenditure"`. The double-equals sign means 'equals to'. This is called an **operator**, and you'll probably be more familiar with other operators like `>` (greater than) and `<` (less than). 

The result of `colnames(mydata)=="Expenditure"` then, is going to be TRUE (yes, the column name is "Expenditure") or FALSE (no, it isn't), for each column. 

What `which` asks, then, is "For which of those items does that test come back TRUE?"

If one of those column headings matches the test, you will get the index position of that column, like so: `[1] 3`. Ignore the `[1]`: that's just a line number. The actual result is after that (`3` in this example).

If none of those column headings matches the test, you will get `integer(0)` - this basically means 'no results'.

If more than one heading matches the test, you'll get more than one number like so: `[1] 2 3` (column 2 and 3 match).

The big weakness of `which` and the `==` operator, however, is that your match must be *exact* - right down to capitalisation and spaces. So for the line `which(colnames(mydata)=="Expenditure")` to work, your column heading cannot be 'expenditure' (small 'e') or 'Expenditure £' or even 'Expenditure ' or ' Expenditure' (note the space at the start or end).

In those cases you need something like `grep`:

`grep("Expenditure", colnames(mydata))`

The `grep` function looks for patterns. You can find more information on [the documentation for `grep` and related functions](https://stat.ethz.ch/R-manual/R-devel/library/base/html/grep.html).

In this case we need to give it 2 ingredients: the text pattern that we're looking for, and the data we're looking for it *in*.

The text pattern is `"Expenditure"` and the data is again `colnames(mydata))`. The two ingredients are separated by a comma.

`grep` will then look through those column names, and if that text pattern appears *anywhere* in that column name, it will return its position.

You can of course store the results of either line of code in a variable to then use to drop or keep columns, like so: 

`colstokeep <- grep("Expenditure", colnames(mydata)) `

`colstokeep <- which(colnames(mydata)=="Expenditure")`

And then change your data so it only has those columns:

`mydata <- mydata[ colstokeep ]`
