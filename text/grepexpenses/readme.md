# Using grep and regex in R

The `grep` function and related functions like `grepl` can be used to check if data matches a particular pattern. For example, you might want to classify data based on whether it contains a date, or a phone number, or one of a list of words.

When used on a vector (such as the column of a dataframe) the `grep` function will return a list of indices (positions, i.e. each index) or any items in that vector that match.

For example in this code...

```{r}
hereisavector <- c("Bob Jones","Sam Smith","Jane Jones")
grep("Jones",hereisavector)
```

...the `grep()` function is looking for the string "Jones" in the vector `hereisavector`.

It finds that string in two of the three items: the first and third ones.

The result of running that function, then, is a list of the indices for those positions: `1 3`

The `grepl` function is slightly different. Instead of returning the *positions* of any matches, it returns a list (vector) of `TRUE` or `FALSE` values - one for each item in the list.

So this code using `grepl` instead...

```{r}
hereisavector <- c("Bob Jones","Sam Smith","Jane Jones")
grepl("Jones",hereisavector)
```

...will return: `TRUE FALSE  TRUE`

In other words: the first item contains the string "Jones" (TRUE); the second one doesn't (FALSE); and the third one does (TRUE).

**Regex** can be used to broaden what you're looking for. Let's say that our list contained both "Smith" and "Smyth". With regex we can specify that we are happy with either spelling:

```{r}
hereisavector <- c("Bob Jones","Sam Smith","Jane Jones","Jane Smyth")
grepl("Sm[iy]th",hereisavector)
```

The square brackets indicate either character is accepted as a match.

We could also use the pipe symbol `|` to express the same sort of thing differently:

```{r}
hereisavector <- c("Bob Jones","Sam Smith","Jane Jones","Jane Smyth")
grepl("Smith|Smyth",hereisavector)
```

Or indeed use that to say we are interested in either Smiths or Joneses:

```{r}
hereisavector <- c("Bob Jones","Sam Smith","Jane Jones","Jane Smyth")
grepl("Smith|Jones",hereisavector)
```



## Using `grepl` for a story about expenses 

The scenario here is that you want to dig into MPs' expenses to see what they've been claiming. You want to be able to identify MPs' based on key words in their constituency - or you might look for particular expressions in their claim details.

First, let's get our data into R

```{r}
exesdata <- read.csv("Individual_claims_for_16_17.csv")
```

Now let's create a list of TRUE/FALSE values saying whether each row contains a particular pattern:

```{r}
#This looks for any match for Birmingham OR Sutton Coldfield
wmconstituency <- grepl("Birmingham,|Sutton Coldfield", exesdata$MP.s.Constituency)
```

Next, add it to the original data:

```{r}
exesdata$westmids <- wmconstituency
```

Now use that to create a subset:

```{r}
wmexes <- subset(exesdata, exesdata$westmids == TRUE)
```

## Advanced: doing this in fewer lines of code

In fact, instead of using 2 lines - one to create a TRUE/FALSE list, and another to add that to our data frame - we could have done both in one line like this:

```{r}
exesdata$westmids <- grepl("Birmingham,|Sutton Coldfield", exesdata$MP.s.Constituency)
```

And going further, we could actually *nest* part of the earlier line of code to do all 3 lines of the above code in one line: 

```{r}
westmidsonly <- subset(exesdata, grepl("Birmingham,|Sutton Coldfield", exesdata$MP.s.Constituency))
```

## Advanced: using `grep` to fetch values

The `grep` function will tell you *which* items in a vector (column) contain a match *or* - if `value=TRUE` is added - will return the text that matches. 

In the first case, that result is a list of numbers (indices indicating which row the matches are in). In the second case it is a list of strings, as shown below (I've added `head()` so you don't get lots of results):

```{r}
print("First the indexes")
head(grep("Const",westmidsonly$Expense.Type, value=FALSE))
print("Now with value set to false")
head(grep("Const",westmidsonly$Expense.Type, value=TRUE))
```

We can use `table()` to summarise the results instead and get a list of matching 'expense type' descriptions:

```{r}
table(grep("Const",westmidsonly$Expense.Type, value=TRUE))
```

This can be exported as a CSV to use in Excel as a lookup table:

```{r}
write.csv(table(grep("Const",westmidsonly$Expense.Type, value=TRUE)), "constituencytypes.csv")
```

[More on regex and grep functions can be found in this chapter of R Programming for Data Science](https://bookdown.org/rdpeng/rprogdatascience/regular-expressions.html)

