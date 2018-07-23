# 10 more Excel-type things to do in R

This page contains notes from Steph Locke's [Excel to R](https://notebooks.azure.com/stephlocke/libraries/exceltor) session at the Data and Computational Journalism conference in Cardiff 2018.

## File structure

It's a good idea to have files organised across at least 3 folders:

* Data for the raw inputs (this remains untouched so you can always return to it)
* Clean or intermediate for processing/analysis
* Outputs for the final results and reports

You might have other folders or subfolders for visualisation, scraping, etc.

## Using Jupyter Notebooks for R

Use the **Data > Download** menu to download files from the remote folder.

## Starting with `dplyr` and CSVs with `read_csv`

`read.csv` has some annoying defaults, e.g. text data is treated as factors and loads more slowly than the `reads_csv` function from `dplyr`.

This message tells you that you have imported some functions whose names conflict with functions in other active packages:

```r
── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
✖ dplyr::filter() masks stats::filter()
✖ dplyr::lag()    masks stats::lag()
```

It will assume you want to use the more recently imported functions, but you can specify by prefixing the function with the package name and two colons, e.g. `stats::filter()`

The code describing the data can also be reused to change the data:

```r
cols(
  X1 = col_integer(),
  name = col_character(),
  Gender = col_character(),
  `Eye color` = col_character(),
  Race = col_character(),
  `Hair color` = col_character(),
  Height = col_double(),
  Publisher = col_character(),
  `Skin color` = col_character(),
  Alignment = col_character(),
  Weight = col_double()
)
```

To see what parameters you can use in a function, type a comma after one of the parameters and press the TAB button.

In `read_csv` useful parameters incude:

* `na =` which specifies what to use instead of #N/A values.
* `trim_ws =` which trims white space if set to `TRUE`
* `skip =` which skips the specified number of lines
* `n_max =` sets the maximum number of lines to import if you want a test dataset
* `colnames =` sets the column names when given a vector to use instead


## Excel files with `readxl` package and its `read_excel` function

*Optional: can you read in the data to exclude -99 values in Weight*

## Saving data as a file

`write_csv` can be used to create a CSV file; for Excel files import the `writexl` package and use `write_xlsx`  or import `openxlsx` (which needs Java so best avoided).

The `dir.create` function can be used to create a directory.

```r
dir.create("outputs", showWarnings = FALSE) # this stops it from making red text if the directory already exists
write_csv(heroes, "outputs/heroes_information.csv")
```

## Other data sources

Here are some links for next steps when it comes time to work different sources:

- [googlesheets docs](https://github.com/jennybc/googlesheets/blob/master/vignettes/basic-usage.md)
- [a great webscraping demo](https://masalmon.eu/2018/06/18/mathtree/)
- [a nifty pdf scraping demo](http://www.brodrigues.co/blog/2018-06-10-scraping_pdfs/)

## Summarising data with `skimr`

The `head` function shows you the first few rows; `summary` provides details on each column/field; and `str` gives detail on the structure (types of data etc.).

The `skimr` library and its `skim` function is more useful than `summary()` - among other things it shows for character fields:

* How many values are missing
* Min and max lengths
* Unique values

For numeric fields it shows statistical summaries - and a histogram

## Summarising with `DataExplorer`

The `DataExplorer` package includes the `create_report` function which generates a data profile report:

`create_report(heroes, output_file="heroes.html", output_dir="outputs")`

You need to specify the output directory.

## Cleaning data

The `naniar` package is for cleaning missing (N/A) values.

```
install.packages("naniar")
library(naniar)
```

The `gg_miss_var` function identifies missing variables. Here it is used with the visualisation package `ggthemes` to show the results:

`gg_miss_var(heroes) + ggthemes::theme_few()`

### Using `mutate_if` to clean all values that match a criteria

This checks:

* For each column in the dataset specified (`heroes` below)
* Test if a condition (`is.character` below) is TRUE
* For any column that returned TRUE applies a function to it (`fct_explicit_na` below, which turns NA values into 'missing')

`heroes = mutate_if(heroes, is.character, fct_explicit_na)`

You can create a custom function to transform instead - below we apply a new function which converts <0 values to NA.

```r
#LT0 refers to Less Than 0  
# x will be the column
replaceLT0 = function(x) ifelse(x < 0, NA, x) # This is like an Excel if statement that will do the condition for every row
```

Here it is being used in `mutate_if`:

```r
heroes = mutate_if(heroes, is.numeric, replaceLT0)
#Show the results
gg_miss_var(heroes) + ggthemes::theme_few()
```

Here's an example of using the same approach to clean up text values (not integers):

```r
# We use summary() to test what type of information is contained in Gender column
summary(heroes)
# This is the 'before' summary
table(heroes$Gender)
#Now create a function which replaces those dashes
replacehyphens <- function(x) ifelse (x == "-", NA, x)
#Then apply that function as part of a mutate_if formula - results are put in a new variable
heroes2 <- mutate_if(heroes,is.character,replacehyphens)
# This is the 'after' summary
table(heroes2$Gender)
```

## Tidying values ([by Steph Locke](https://exceltor-paulbradshaw.notebooks.azure.com/nb/notebooks/02_CleaningData.ipynb))

We'll often need to do text, date, and numeric manipulation to clean up values. Key packages that we have because of the `tidyverse` are:
- `stringr` for working with text
- `forcats` for working with text that has fairly low amounts of unique values
- `lubridate` for working with dates

An alternative to our trusty `mutate_if()` is `mutate_at()` which will allow us to say what range of columns we want to process. Oh, and I forgot to mention before because we're killing it with amazing coding multipliers but there's also a `mutate()` function you can use for changing or adding columns when you need to think about a few named columns.

### Converting "true" (as string) to an R-meaningful True

This function is deceptively simple: it means if x is the string "True" (if that is TRUE) then... what? Well it defaults to saying TRUE.

`boolConversion = function(x) x == "True"`

```r
# mutate_at needs to know which variables to include or exclude. HEre I'm using the super nifty exclude option
powers = mutate_at(powers, vars(-hero_names), boolConversion)
str(powers)
```

## Reshaping data
Often we get data in a summary form that makes it hard to be able to do visualisations and analysis.

It's usually better if we can get our data into a *long* format where instead of lots of columns, we have lots of rows instead. This is what I think of as *unpivoting* my data because *pivoting* it means ending up with many columns.

In R, the function for unpivoting data is `gather()`, like gathering all your data up, and the function for pivoting your data is `spread()`.

`gather()` will need to know what the name should be for column containing our old headers, what the column name should be for the one holding our old cell values, and what columns we do/don't want to unpivot.

```r
#powers is the data frame, power is the
powers_long = gather(powers, power, present, -hero_names)
str(powers_long)
```

## Grammar of graphics: `ggplot` 
