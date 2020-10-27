# Creating HTML in R

Some packages in R allow you to generate HTML webpages based on your work in R. These can then be published online.

[The `rmarkdown` package](https://rmarkdown.rstudio.com/docs/) is a good place to start: this can be used to convert your R notebook into a HTML webpage. 

Here's an example of some code with uses the `render()` function from that package to create a HTML webpage from a specified R Markdown (.Rmd) file:

`rmarkdown::render("index.Rmd", output_format="all")`

There are two parameters being used here. The first is the name of the R Markdown file that you want to render into HTML. 

This file needs to be in the same folder as the project where you are writing the code (if it's not, you'll have to specify a path to it).

The second parameter specifies what format you want to render the notebook in. 

*Note: If you try to render a notebook from within itself it will generate an error. Instead create two notebooks: one with the material you want to publish as a HTML page, and another which will 'render' the first notebook.*

The second notebook will need the following at the top

```
---
title: 'ENTER TITLE HERE'
output:
  html_document:
    df_print: paged
---
```


## Using the DT (datatables) package to generate interactive tables

[The `DT` - datatables - package](https://rstudio.github.io/DT/) is a particularly useful one. This will generate interactive tables.
