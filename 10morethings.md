# 10 things to do next in R

Once you've done [the first 10 things in R detailed here](https://github.com/paulbradshaw/Rintro), it's time to start playing with packages...

## Install a package and use it

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

## Join two datasets from different periods or areas

If you have two different datasets with the same columns, but for different years or time periods, you might want to join those. Or perhaps you have data with the same columns and time period for a number of regions.

As always, you need to import them into variables in R as explained earlier.

To join those you can use the `bind_rows` function from the `dplyr` package.

Here's an example:

`bothyears <- bind_rows(2014data,2015data)`

As always 'bothyears' above can be any name you want to give it, and the two variables named in parentheses need to be the names of *your* data table variables.

If you haven't activated the `dplyr` package you will get the following error:

`Error: could not find function "bind_rows"`

In that case, make sure you go to your Packages list and tick the box next to dplyr, or type this command into R: `library("dplyr")`
