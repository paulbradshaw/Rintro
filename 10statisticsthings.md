# 10 statistical things to do in R

R is an extremely powerful statistical analysis language, and is increasingly used instead of more traditional tools like SPSS. Here are some statistical analyses to try.

## 1. Summary statistics

I've already mentioned this in '10 things to do first' but it's good to revisit again here.

The `summary()` function returns summary statistics for a variable (such as a data frame) or a column, like so:

`summary(yourdata)`

Or:

`summary(yourdata$onecolumn)`

For columns containing numerical data you will see:

* The minimum value
* The first quartile
* The median
* The mean
* The third quartile
* The maximum value
* How many N/A values

For columns containing text data you will see a frequency count for the most common text entries.

## Standard deviation

Standard deviation and variance [both measure how spread out a series of values are](https://www.mathsisfun.com/data/standard-deviation.html) - in other words, small values suggest a narrow range of values, and larger ones suggest a wider range of values.

The `sd()` function will tell you the standard deviation, like so:

`sd(yourdata$yourcolumn)`

## Correlation

A strong correlation between two sets of numbers indicates a possible relationship - but it doesn't prove causation. There are plenty of strong correlations where there is no causal relationship, as [demonstrated by the website and book Spurious Correlations](http://www.tylervigen.com/spurious-correlations).

In Excel you can generate a [**correlation coefficient**](http://www.dummies.com/education/math/statistics/how-to-interpret-a-correlation-coefficient-r/) for two sets of numbers using the `CORREL` function. A **correlation coefficient** is a number between -1 and 1 which indicates the *strength* of the correlation between those numbers. A negative number means a negative correlation (one thing goes down as the other goes up).

A correlation coefficient above 0.8 or below -0.8 represents a very strong correlation; 0.5 or -0.5 is the threshold for a moderate to strong correlation.

To calculate a correlation in R use the `cor()` function. This needs at least two parameters: the two columns of numbers you want to correlate, like so:

`cor(yourdata$yourcolumn, yourdata$yourothercolumn)`

You can [read more about correlation and regression in the R Cookbook here](http://www.cookbook-r.com/Statistical_analysis/Regression_and_correlation/)

## Regression
