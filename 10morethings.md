# 9 things to do next in R

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

## 4. Import XML data from a URL

Once the XML package has been installed (`install.packages('XML')` and then `library(XML)`), the `readHTMLTable` function will import an XML file into a dataset. However, it does need some attention to the parameters, specifically  `elFun = ...` which needs to specify the part of the XML you want.

The [documentation for the XML package](https://cran.r-project.org/web/packages/XML/XML.pdf)

XML files can be found on the [Food Standards Agency inspections API](http://ratings.food.gov.uk/open-data/en-GB).

A tutorial on using the package to grab an XML file [can be found on R-Bloggers here](https://www.r-bloggers.com/r-and-the-web-for-beginners-part-ii-xml-in-r/)

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

## 8. Get rid of an unwanted column from your data

If you are dealing with a large dataset and don't need certain columns, you can drop them like so:

`mydata$thecolumnname <- NULL`

Obviously the name before the dollar sign (your table name) will be different, and likewise the name after (the name of the field in your table that you want to get rid of). 

## 9. Grab or drop more than one column from your data

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
