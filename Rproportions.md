# Calculating proportions in R

You can quickly calculate what proportion of a particular column (data frame field) or vector meet a particular condition by using `mean` and an operator like so:

`mean(mydata$mycolumn > 65)`

The result will be a decimal, e.g. `0.21` for 21%.

To understand this it's best to start simple with a `sum` function:

`sum(mydata$mycolumn > 65)`

This goes through each item in the column and tests if it's above 65. If it is, it returns TRUE. If not, it returns FALSE. TRUE = 1 and FALSE = 0, so a `sum` of all those results will be a total of the number of data points which are TRUE.

Now, imagine if that `sum` is 21 and the total items is 100.

The `mean` function will divide that 21 by the total items to get 0.21, or 21%.

