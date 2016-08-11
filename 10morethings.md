# 10 things to do next in R

Once you've done [the first 10 things in R detailed here](https://github.com/paulbradshaw/Rintro), it's time to start playing with packages...

## 1. Install a package and use it

As well as the built in functions in R there are dozens of extra ones you can access by installing **packages**. For example, there are packages to help create particular types of visualisation, packages to deal with particular types of data (including text), packages to do particular forms of statistical analysis, and so on.

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

Once the XML package has been installed, the `readHTMLTable` function will import an XML file into a dataset. However, it does need some attention to the parameters, specifically  `elFun = ...` which needs to specify the part of the XML you want.

The [documentation for the XML package](https://cran.r-project.org/web/packages/XML/XML.pdf)

XML files can be found on the [Food Standards Agency inspections API](http://ratings.food.gov.uk/open-data/en-GB).

## 5. Add comments

It's always a good idea to add comments to your code: partly so you can understand it later, but largely so that others can understand it if they need to. One of the main selling points of R is that it allows you to show your workings, so having comments that explain that is going to be just as important as the code itself.

You can add a comment by just using the hash key like so:

`#This next line imports the data`

`newvar <- read.csv('myfile.csv')`

Anything after a hash is ignored when the code runs. 

You can also add a comment on the same line as the code like so:

`newvar <- read.csv('myfile.csv') #This imports the data`

Python comments are written exactly the same, by the way.

## 6. Import one sheet in an Excel workbook

The [**readxl** package](https://cran.r-project.org/web/packages/readxl/readxl.pdf) is designed to help import Excel files. One of its advantages is the ability to specify which sheet in a workbook you want. First, install it and add it to your library:

`install.packages("readxl")`

`library(readxl)`

To import data you can use the `read_excel` function. This needs two ingredients: the name of the file you want to import (this needs to be in the same working directory as your R project, or you can specify a path), and then the sheet number or name. Here's an example:

`mynewdata <- read_excel('myspreadsheet.xlsx', sheet=3)`

Note that `sheet=3` does indeed mean the 3rd sheet (normally in programming 3 means the 4th item).

You can also specify the name of a sheet by putting it as a string like so:

`mynewdata <- read_excel('myspreadsheet.xlsx', sheet='crimes')`
