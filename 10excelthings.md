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

## Create pivots to show the biggest or smallest single values in each category

Another option in pivot tables is to show the biggest (`MAX`) or smallest (`MIN`) values. The functions are the same in R:

`tapply(mydata$numbers, mydata$category, max)`

And:

`tapply(mydata$numbers, mydata$category, min)`

## Ordering a pivot table

Typically, after creating a pivot table we might sort it to bring the worst or best, biggest or smallest values to the top. You can do that by storing the results in a variable, and then using `order()` in square brackets to sort it, like so:

```r
newdata <- tapply(mydata$numbers, mydata$category, median)
newdata <- newdata[order(newdata)]
```

The data will be sorted by the numbers, smallest to largest. To order smallest to largest add a minus operator inside the parentheses like so:

`newdata <- newdata[order(-newdata)]`

## Try functions you can't do in normal pivot tables

R allows you to use other mathematical functions too. For example you could create a pivot table of the **standard deviation** for each category using `sd`:

`tapply(mydata$numbers, mydata$category, sd)`

You can calculate the **variance** using `var`

`tapply(mydata$numbers, mydata$category, var)`

(Standard deviation and variance [both measure how spread out a series of values are](https://www.mathsisfun.com/data/standard-deviation.html) - in other words, small values suggest a narrow range of values)

You can even show the **range** of numbers (lowest and highest) for each category:

`tapply(mydata$numbers, mydata$category, range)`

Because this produces two sets of numbers, it cannot be easily exported as a CSV. Some conversion is needed first.

## Try some more advanced exercises

[This series of tutorials](https://www.mathsisfun.com/data/standard-deviation.html) extends the techniques outlined above, and brings in other useful tips such as filtering with `subset`, creating percentages, and turning a table into a data frame.

It also introduces [the gender package](https://github.com/ropensci/gender) that "predicts gender based an algorithm using historical data"
