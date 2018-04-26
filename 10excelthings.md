# 10 Excel-type things to do in R

Why would you use R to do things that you can do in Excel? There are a few reasons why:

* If you already have your data in R, you may not want to export and analyse separately
* Analysing in R makes it easier to show how you arrived at your findings
* Encoding processes in R makes it easier to run again on a new set of data

## 1. Access columns, rows, and cells

Cells are accessed in Excel using cell references like `A1` and `C4`: the letter identifies the column and the number the row. Cell ranges can be specified using a colon between the first and last cell like so: `A1:C4`

Rows and columns can be identified this way, too, though, e.g. `A:A` will select the whole of column `A`, and `2:2` will select the whole of the second column.

Cells can be accessed in a similar way in R by using square brackets, only this time letters aren't used at all - just one number for the row, and another number for the column, separated by commas. For example, if you want to access the first cell (the equivalent of A1) in a data frame called `mydata` you would do it like this:

`mydata[1,1]`

To access the equivalent of C4 (the third column, and fourth row) you would use:

`mydata[4,3]`

Note that the ordering is the reverse of Excel: row, then column.

To access a whole row or column, just omit the other number - but retain the comma. For example to grab the first row you would use:

`mydata[1,]`

And to access the first column you would use:

`mydata[,1]`

## 2. Create a pivot table that counts something

The `table` function in R creates a handy pivot table that counts the occurrences of unique values in a specified column. For example:

`table(mydata$category)`

This generates a count of how many times each category occurs in that column. It can be stored in a variable, and/or exported as a CSV, e.g.

`write.csv(table(mydata$category), "categoriespivot.csv")`

By the way, you can store a list of all unique values in a column by using `unique()`, e.g.

`categorylist <- unique(mydata$category)`

## 3. Create a pivot that calculates totals

To do other types of pivot tables you need to use the `tapply` function. This applies a particular calculation (such as `sum`, `mean`, `average`, etc.) to a column of your data, and aggregates it by another. In other words, just like dragging one thing into *Values* in a pivot table (what you want to calculate) and another into *Rows* what you want to aggregate by. Here's an example:

`tapply(mydata$numbers, mydata$category, sum)`

What this does is apply the `sum` function to the values in `mydata$numbers`. But sandwiched in between those two is the column you want to aggregate those sums by: `mydata$category`: the results should be the sums for each category.

### Troubleshooting: when numbers aren't numbers

Sometimes you will get an error if you specify a non-numeric column. Even if it looks like numbers, R may be seeing it as something else (for example if it also contains text values like #NA or No entry). To test this, put the column inside `is.numeric()` like so:

`is.numeric(mydata$numbers)`

If it is numeric you should get `TRUE`. If it is not numeric (`FALSE`), try generating a summary of the column like so:

`summary(mydata$numbers)`

This will treat each value as a character object, and give you a count of each value - if it was numeric then you would instead get quartiles, mean and median.

Note that `as.numeric()` will not directly convert those values to equivalent numbers. Instead they will be converted into ordinal numbers: `1` for the first unique value, `2` for the second, and so on.

[One solution](https://stackoverflow.com/questions/4931545/converting-string-to-numeric) is this: put the column name in the parentheses of `levels()`, and then put the whole thing in `as.numeric()`, *and* then put the column name *again* in square brackets after that expression. Here's each step in turn:

1. `levels(mydata$numbers)`
2. `as.numeric(levels(mydata$numbers))`
3. `as.numeric(levels(mydata$numbers))[mydata$numbers]`

This can then be stored in a new variable, or re-stored in the same column like so:

`mydata$numbers <- as.numeric(levels(mydata$numbers))[mydata$numbers]`

An alternative solution is to import the data again with the setting `stringsAsFactors=FALSE`. If the data was created within R you would first have to export it using an expression like `write.csv(mydata, "mydata.csv")`

You would then import it using an expression like `read.csv("mydata.csv", stringsAsFactors=FALSE)`

Then use `is.numeric()` to test the column that was wrongly interpreted as a factor (text) before.  

## 4. Create a pivot that calculates averages

Adapting the above code to calculate an average is relatively straightforward: instead of using `sum`, use a function like `mean`:

`tapply(mydata$numbers, mydata$category, mean)`

## 5. Create a pivot that calculates medians

Excel pivot tables cannot calculate a median - but R can. The function to use is `median`:

`tapply(mydata$numbers, mydata$category, median)`

## 6. Create pivots to show the biggest or smallest single values in each category

Another option in pivot tables is to show the biggest (`MAX`) or smallest (`MIN`) values. The functions are the same in R:

`tapply(mydata$numbers, mydata$category, max)`

And:

`tapply(mydata$numbers, mydata$category, min)`

## 7. Ordering a pivot table - or any table

Typically, after creating a pivot table we might sort it to bring the worst or best, biggest or smallest values to the top. You can do that by storing the results in a variable, and then using `order()` in square brackets to sort it, like so:

```r
newdata <- tapply(mydata$numbers, mydata$category, median)
newdata <- newdata[order(newdata)]
```

The data will be sorted by the numbers, smallest to largest. To order smallest to largest add a minus operator inside the parentheses like so:

`newdata <- newdata[order(-newdata)]`

## 8. Try functions you can't do in normal pivot tables

R allows you to use other mathematical functions too. For example you could create a pivot table of the **standard deviation** for each category using `sd`:

`tapply(mydata$numbers, mydata$category, sd)`

You can calculate the **variance** using `var`

`tapply(mydata$numbers, mydata$category, var)`

(Standard deviation and variance [both measure how spread out a series of values are](https://www.mathsisfun.com/data/standard-deviation.html) - in other words, small values suggest a narrow range of values)

You can even show the **range** of numbers (lowest and highest) for each category:

`tapply(mydata$numbers, mydata$category, range)`

Because this produces two sets of numbers, it cannot be easily exported as a CSV. Some conversion is needed first.

## 9. `COUNTIF` in R

In Excel you can use the `COUNTIF` function to count how many cells in a range meet a particular condition. You can do the same in R - *and* calculate that as a proportion of a particular column (data frame field) or vector by using `mean` and an operator like so:

`mean(mydata$mycolumn > 65)`

The result will be a decimal, e.g. `0.21` for 21%.

To understand this it's best to start simple with a `sum` function:

`sum(mydata$mycolumn > 65)`

This goes through each item in the column and tests if it's above 65. If it is, it returns TRUE. If not, it returns FALSE. TRUE = 1 and FALSE = 0, so a `sum` of all those results will be a total of the number of data points which are TRUE.

Now, imagine if that `sum` is 21 and the total items is 100.

The `mean` function will divide that 21 by the total items to get 0.21, or 21%.

## 10. `IF` in R

In Excel the `IF` function performs a test (typically on a cell) and then does one thing if the test comes back as true, or a second thing if it is false. It is often used for generating new columns which assign categories to the value in another column. For example the formula `=IF(A2>5,"Above 5","5 or below")`, when repeated down a column will fill each cell with either 'Above 5' or '5 or below'.

In R you can do the same with `ifelse`, and the construction is the same: first the test you want to perform, then a parameter saying what to do if it's true, and third parameter is what to do if it's false.

The big difference is that you do this with *an entire column* rather than cell-by-cell. Here's an example which creates a vector:

`whiteornot <- ifelse(testdata$self_defined_ethnicity == "White - White British (W1)","White","Not white")`

And here's one which adds a new column:

`testdata$whiteornot <- ifelse(testdata$self_defined_ethnicity == "White - White British (W1)","White","Not white")`


## Try some more advanced exercises

[This series of tutorials](https://www.mathsisfun.com/data/standard-deviation.html) extends the techniques outlined above, and brings in other useful tips such as filtering with `subset`, creating percentages, and turning a table into a data frame.

It also introduces [the gender package](https://github.com/ropensci/gender) that "predicts gender based an algorithm using historical data"
