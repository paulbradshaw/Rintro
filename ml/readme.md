# Machine learning - notes

This file contains notes from the [Udemy course Machine Learning A-Z™: Hands-On Python & R In Data Science](https://www.udemy.com/machinelearning/).

[Download the data and files from here](https://www.superdatascience.com/machine-learning/)

## 8. Data preprocessing

Distinguish between **independent and dependent variables**: in the example dataset, demographics (country, age, earnings) are the independent variables and actions (Purchased: yes or no) are the depending variables.

Once you've imported that data into a variable, you may need to separate independent and dependent variables. In Python's `pandas` package, you access the columns and rows using `.iloc` with the rows specified first, then the columns. If you want *all* rows (or columns) use the colon `:`.

```py
# Importing the dataset
dataset = pd.read_csv('Data.csv')
#put the independent variables in one matrix
#iloc takes rows (: means all)
#and columns (all up to but not including the last one)
#then we extract the values and put in new variable X
X = dataset.iloc[:,:-1].values
#put the dependent variables in another     matrix
#as above, but all rows and just column index 3
y = dataset.iloc[:, 3].values
```

### Classes, objects and methods

[From the course](https://www.udemy.com/machinelearning/learn/v4/t/lecture/5859706?start=0):

> "A class is the model of something we want to build. For example, if we make a house construction plan that gathers the instructions on how to build a house, then this construction plan is the class.

> "An object is an instance of the class. So if we take that same example of the house construction plan, then an object is simply a house. A house (the object) that was built by following the instructions of the construction plan (the class). And therefore there can be many objects of the same class, because we can build many houses from the construction plan.

> "A method is a tool we can use on the object to complete a specific action. So in this same example, a tool can be to open the main door of the house if a guest is coming. A method can also be seen as a function that is applied onto the object, takes some inputs (that were defined in the class) and returns some output.""

## Replacing missing values - imputation

Missing values cause problems, so typically they are replaced with the mean, median or mode value for the dataset as a whole, a process called **imputation**.

*Note: I came across this [chapter on Missing-data imputation ](http://www.stat.columbia.edu/~gelman/arm/missing.pdf) which tackles the topic in more depth*

### Imputation using Python's `scikit` library

[The `scikit` library](http://scikit-learn.org/stable/) (imported as `sklearn`) has a class `Imputer` with properties that can be used to identify what defines `missing_values` and what `strategy` should be used to replace them (mean, median or mode (`most_frequent`)). That is used to create a variable which is then used to transform missing values using the code below:

```py
#import the Imputer class from the sklearn library to handle missing data
from sklearn.preprocessing import Imputer
#specify what the missing values are (Nan)...
#...what strategy to use (apply the mean - alternatives are 'median' or 'most_frequent')
#Press CMD+I in front of Imputer to see Help documentation in window
#...and what axis
imputer = Imputer(missing_values = "NaN", strategy = 'mean', axis = 0)
#use that imputer to fit values from X: all rows (:) and columns index 1-2
imputer = imputer.fit(X[:, 1:3])
#This does the actual transformation based on the settings above
X[:,1:3] = imputer.transform(X[:, 1:3])
```

### Imputation using R and `ifelse`

Replacing missing values in R is simpler: you just need to use [the `ifelse` function](https://www.datamentor.io/r-programming/ifelse-function) to specify that *if* a cell contains a missing value such as `NA` it should be replaced by a mean (or median or mode). Here's the code:

```r
dataset$Age = ifelse(is.na(dataset$Age),
                     ave(dataset$Age, FUN= function(x) mean(x, na.rm = TRUE)),
                     dataset$Age
                     )
```

Like the `IF` function in Excel, `ifelse` takes 3 parameters: a test which will return true or false; what you want to do if the test returns true; and what to do if it returns false.

In the code above the test is `is.na(dataset$Age)`. In other words: if (any) value in the `dataset$Age` field is `NA` (again, there's an Excel equivalent function here, `ISNA`).

If that is true, the code executes the code `ave(dataset$Age, FUN= function(x) mean(x, na.rm = TRUE)`. Back to this in a second.

If `is.na(dataset$Age)` is false, we simply fetch `dataset$Age`.

This needs breaking down. The function `ave` calculates an average. The code `ave(dataset$Age)` would calculate an average of that column. *However*, if the column contains any `NA` errors then the average will also return an `NA` error.

To stop this from happening, we need to specify an *extra* parameter, `FUN = `. This specifies a function to run as part of the calculation.

This function takes `(x)` as its argument: `x` [is the variables being handled by the function](https://www.rdocumentation.org/packages/stats/versions/3.4.3/topics/ave) (the ages, in this case). Next it calculates a `mean` for those variables, but with an important extra parameter: `na.rm = TRUE`. This means *remove any `NA` values* from the calculation (I'm not sure if 'rm' is short for 'remove' but it is at least easy to remember that way).

This prevents the basic `ave()` function from returning `NA`. [A more detailed exploration of NA handling can be found here](https://thomasleeper.com/Rcourse/Tutorials/NAhandling.html)

The results of the `ifelse` function are put in `dataset$Age`. Or, put another way, *for each value in dataset$Age*, the `ifelse` function runs. If the value is an `NA` it is replaced with the results of that `ave()` function which ignores NA values; if the value is *not* (false) then it is replaced with... itself. In other words there is no change; it will only change the NA values.
