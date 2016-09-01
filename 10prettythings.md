# 10 pretty pictures to make in R

One thing R is useful for is generating quick visualisations of your data. Here are some things to do to draw some:

## 1. Create a histogram

The `hist` function generates a **histogram** from specified data.

Here's an example:

`hist(moviesdata$revenue)`

 A histogram is a chart which shows the *distribution* of values across a continuum: for example years, weights, heights, amounts of money, and so on. Note that this is different to a **bar chart**, which shows a *comparison* of amounts in different categories.

If you are generating a histogram of revenue, then, highers bars at the start will show you that most entries spent less money, whereas higher bars at the end mean most spent lots of money.

A histogram of years will show you how often each year appears in the dataset.

The data needs to be numeric or you will get an error saying *Error in hist.default(YOURDATA) : 'x' must be numeric*.

You can [read more about histograms on this R-Bloggers post](https://www.r-bloggers.com/how-to-make-a-histogram-with-basic-r/)

## 2. Create a scatterplot

A scatterplot is also a chart used to show *distribution*. It will plot each data point against an x and y value. For example, x might be weight, and y might be height; or x might be cigarettes smoked, and y might be age at death.

As you can see from those two examples, it is often also used to indicate *relationships*: a scatterplot that shows a clear pattern, such as age of death going down as number of cigarettes goes up, is a good way of showing a relationship.

However, it is not *proof* of a relationship. Remember: **correlation does not mean causation**.

You can generate a scatterplot using `plot` in R like so:

`plot(Movies$budget, Movies$domgross)`

Here we have specified two *numeric* columns in our data frame (in this case, budget spent vs domestic gross). 

## 3. Create multiple scatterplots (scatterplot matrices)

You can also use `plot` to generate *multiple* scatterplots showing *all* relationships between variables in your dataset. In this case just put the name of the dataset like so:

`plot(movies)`

This works best when a) you don't have too many columns and b) most columns are numeric. 

You can [read more about scatterplots and scatterplot matrices on this Quick-R post](http://www.statmethods.net/graphs/scatterplot.html), which also details some other functions.
