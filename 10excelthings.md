# 10 Excel-type things to do in R

Why would you use R to do things that you can do in Excel? There are a few reasons why:

* If you already have your data in R, you may not want to export and analyse separately
* Analysing in R makes it easier to show how you arrived at your findings
* Encoding processes in R makes it easier to run again on a new set of data

## Create a pivot table that counts something

The `table` function in R creates a handy pivot table that counts the occurrences of unique values in a specified column. For example:

`table(mydata$category)`

This generates a count of how many times each category occurs in that column. It can be stored in a variable, and/or exported as a CSV, e.g.

`write.csv(table(mydata$category), "categoriespivot.csv")`

## Create a pivot that calculates totals

To do other types of pivot tables you need to use the `tapply` function. This applies a particular calculation (such as `sum`, `mean`, `average`, etc.) to a column of your data, and aggregates it by another. In other words, just like dragging one thing into *Values* in a pivot table (what you want to calculate) and another into *Rows* what you want to aggregate by. Here's an example:

`tapply(mydata$numbers, mydata$category, sum)`

What this does is apply the `sum` function to the values in `mydata$numbers`. But sandwiched in between those two is the column you want to aggregate those sums by: `mydata$category`: the results should be the sums for each category.

Sometimes you will get an error if you specify a non-numeric column. Even if it looks like numbers, R may be seeing it as something else. To correct this, put the column inside `as.numeric` like so:

`tapply(as.numeric(mydata$numbers), mydata$category, sum)`

## Create a pivot that calculates averages

Adapting the above code to calculate an average is relatively straightforward: instead of using `sum`, use a function like `mean`:

`tapply(mydata$numbers, mydata$category, mean)`

## Create a pivot that calculates medians

Excel pivot tables cannot calculate a median - but R can. The function to use is `median`:

`tapply(mydata$numbers, mydata$category, median)`
