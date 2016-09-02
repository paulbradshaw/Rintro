# 10 pretty pictures to make in R

One thing R is useful for is generating quick visualisations of your data. Here are some things to do to draw some:

## 1. Create a histogram

 A histogram is a chart which shows the *distribution* of values across a continuum: for example years, weights, heights, amounts of money, and so on. Note that this is different to a **bar chart**, which shows a *comparison* of amounts in different categories.
 
 In the histogram below, for example, you can see the frequency distribution of different ages within a dataset (i.e. how often each age appears). It tells you that the most common ages to appear in the dataset are between 30 and 40.

![](http://blog.datacamp.com/wp-content/uploads/2015/03/picture2.png)

The `hist` function generates a **histogram** from specified data.

Here's an example:

`hist(moviesdata$revenue)`

The data needs to be numeric or you will get an error saying *Error in hist.default(YOURDATA) : 'x' must be numeric*.

You can [read more about histograms on this R-Bloggers post](https://www.r-bloggers.com/how-to-make-a-histogram-with-basic-r/)

## 2. Create a scatterplot

![](http://www.ats.ucla.edu/Stat/r/faq/scatte1.gif)

A scatterplot is also a chart used to show *distribution*. It will plot each data point against an x and y value. For example, x might be weight, and y might be height; or x might be cigarettes smoked, and y might be age at death. The scatterplot above, for example, plots writing scores against reading scores. 

As you can see from those two examples, it is often also used to indicate *relationships*: a scatterplot that shows a clear pattern, such as age of death going down as number of cigarettes goes up, is a good way of showing a relationship.

However, it is not *proof* of a relationship. Remember: **correlation does not mean causation**.

You can generate a scatterplot using `plot` in R like so:

`plot(Movies$budget, Movies$domgross)`

Here we have specified two *numeric* columns in our data frame (in this case, budget spent vs domestic gross). 

## 3. Create multiple scatterplots (scatterplot matrices)

![](http://www.statmethods.net/graphs/images/spmatrix1.jpg)

You can also use `plot` to generate *multiple* scatterplots showing *all* relationships between variables in your dataset (see example above). In this case just put the name of the dataset like so:

`plot(movies)`

This works best when a) you don't have too many columns and b) most columns are numeric. 

You can [read more about scatterplots and scatterplot matrices on this Quick-R post](http://www.statmethods.net/graphs/scatterplot.html), which also details some other functions.

## 4. Create a box and whiskers chart (boxplots)

A box and whiskers chart - or **boxplot** - is another way of showing distribution. The 'box' shows the range within which the middle half of numbers fall: in other words, the lower and upper quartiles. The line through the middle of the box shows the **median**: in other words, the point at which half of your numbers are higher, and half are lower. 

Reaching out from the box are two lines called 'whiskers'. These show you the **range** of numbers: the highest and lowest ones. [This explanation from BBC Bitesize is useful in explaining them](http://www.bbc.co.uk/bitesize/standard/maths_ii/relationships/boxplots/revision/1/)

![](http://www.statmethods.net/graphs/images/boxplot1.jpg)

You create these with the `boxplot` function, like so:

`boxplot(mydata)`

This will create a box and whiskers chart for each column in the dataset. But you can also generate for one column like so:

`boxplot(Movies$budget)`

Or for specified columns like so:

`boxplot(Movies$budget, Movies$gross)`

## 5. Create a bar chart

You'll notice that all the examples above relate to distribution. To show a comparison you need a bar chart, and this involves a little extra work. 

The function to create a bar chart is `barplot`, but to use *that* we first need to create a vector which has a **count** of the number of items in each category we want to compare (even if the category is a number).

That function is `table`. Use it like so:

`years <- table(Movies$year)`

And then use that variable with `barplot` like so:

`barplot(years)`

You can find [a more in-depth tutorial that adds other features here](http://www.theanalysisfactor.com/r-11-bar-charts/). You should also, strictly speaking, order bars from largest to smallest in a bar chart. So here's a challenge: find out how to do that (tip: you might need a different function from a package like ggplot).

## 6. Create a polar histogram

![](http://chrisladroue.com/wp-content/uploads/2012/02/polarHistogramFudged.png)

Christophe Ladroue has a [post on creating a polar histogram in R using the ggplot package](http://chrisladroue.com/2012/02/polar-histogram-pretty-and-useful/). This is very pretty, but remember that circular charts like this and pie charts tend to be much harder for people to interpret than standard histograms and bar charts.
