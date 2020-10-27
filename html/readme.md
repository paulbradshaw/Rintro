# Creating HTML in R

Some packages in R allow you to generate HTML webpages. These can then be published online.

The simplest way to generate HTML webpages is with an R Notebook. Here's how:

## Turning an R Notebook into a HTML webpage

First, in an R project create your R Notebook by going to **File > New File > R Notebook**. 

The notebook will be created with some template text: a 'metadata' section that starts and ends with `---`; some narrative in R Markdown; and a code block.

Look at the metadata section. It should have a `title` attribute and an `output` attribute:

```
---
title: "R Notebook"
output: html_notebook
---
```

By default the output is `html_notebook` which means you can create a HTML output of the notebook. If the output is something else then make sure you change it so it reads `output: html_notebook`.

From your notebook you can use the **Preview** menu (just above the first line of the notebook) to 'knit' the notebook to HTML or other formats. 

Click on **Preview > Knit to HTML** to start the process.

If you haven't already saved your notebook you will be asked to give the HTML file a name (the same name will be used for the .Rmd file). It will save it in the project folder by default.

If you have saved your notebook first it will create a HTML file with the same name.

![](images/knithtml.png)

Once the HTML file has been 'knitted' it will appear in a new window. You should also be able to see it in the project folder, and upload it to any website hosting you have.

The 'Preview' button will now change to a 'Knit' button. Whenever you want to update the HTML file to reflect the latest version of the notebook, click **Knit > Knit to HTML**.

## Generating a HTML version using R code

Rather than clicking on the 'Knit' button, you may need to automate the process by using R code. 

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
