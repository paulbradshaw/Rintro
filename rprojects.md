# R projects, R scripts and R markdown

As you come to share your R projects, collaborate with others, or want to re-use code, you'll need to know more about project files, scripts and markdown. Here's a summary:

* .Rproj (R project) files store the 'workspace' of your project (its files) and the entire history of your code. This shows how you got to where you are now, and allows you or others to track back through your code.
* .R (R script) files store a series of R commands, which can then be re-used within the same project or others. You can also share it with others so they can use it and build on it.
* .Rmd (R markdown) files store both commands and a commentary and narrative, and can be exported as a HTML, Word or PDF document to be published alongside the final results.

The R project file is the one you should have already encountered, as whenever you create a project in RStudio you are prompted to select a directory where RStudio creates a project file, ending in the extension `.Rproj` (you're prompted again to save your 'workspace' when you exit too).

However, I'm going to start with the other two as the R project file has some 

## `.R` files: R script

The code that you've been writing in the Console can instead be stored in an external file. This is particularly useful if you want to share it with others, use it more than once, or use it in another project.

Once code is saved in an external R file, it can then be run directly from that file, instead of you having to type it or copy it. 

To create an R script select **File > New File > R Script**. A new tab should open in the upper right with an untitled document. Save it and give it a name (it will default to the same directory, and automatically give it a .R extension) and then write your code just as you would in the Console. The main difference is that it won't run yet - it's just a file.

To *run* an R file use the `source` command like so:

`source("mycode.R")`

Note that the name of your R file should be in quotes. It also has to be in the same directory as your project, otherwise you have to specify the path to the file.

There are easy ways of copying code that you've already written into an R script, which I'll cover below.

## Rmd files

R markdown allows you to combine code and output with an accompanying narrative. 

You can use R markdown to [create notebooks within RStudio](http://rmarkdown.rstudio.com/r_notebooks.html). Notebooks can then be exported as PDF documents, HTML files or Word documents.

R notebooks use a particular form of markdown called R Markdown - the files created use the extension `.Rmd`.

To create a notebook in RStudio, select **File > New file > R Markdown...**. The first time you do this, RStudio will install a bunch of packages (specifically `knittr` and `rmarkdown`) to allow you to create notebooks.

When you create a notebook it will be generated with some template code that explains how they work. This includes **chunks** of working code. Each chunk of code starts and ends with ```. The language of the code is also specified, like so: 

````{r}`

Each chunk of code is then coloured grey. In the upper right corner of that grey chunk you should see a settings button, a downward arrow and a 'play' button. The settings button allows you to specify whether each piece of code runs or not, is visible or not, and whether the output is shown or not. The other two buttons allow you to run just that piece of code or all previous chunks.

Notably, you can also run other languages within an R notebook, as long as they are installed on your computer. For example to run Python just use ````{python}` at the start of the chunk of code.

A [cheatsheet for R markdown is available here](https://www.rstudio.com/wp-content/uploads/2016/03/rmarkdown-cheatsheet-2.0.pdf)

Again, there are easy ways of copying code you've already written, covered below.


## All the lines of R you've typed so far

Now to that R project file. 

At its most basic, double-clicking on this file will open up your project in RStudio, and you will still have all the objects you created previously. 

But where have all your commands gone? 

You can still access previous commands by pressing the up and down arrow keys. Then press Enter to run the line you've accessed.

But more broadly, you will find a history of all previous commands in the **History** tab in the upper right corner (next to **Environment**, where all your objects are listed). If you can't see this, select **View > Show History** to make that area active, or type `history()` in the console.

If there are lines in your history that you want to delete - either because they're irrelevant or embarrassing - you can select them and click the delete icon to do so.

If there are lines in your history you want to run again, you can select them in the History window and then click **To Console** to copy them into your Console area. Press Enter and those lines will run.

Likewise, if there are lines you want to save as a standalone file of R code, you can copy them across to a new file by clicking **To Source**.

This should open a new tab in the upper right area, called *Untitled1* (or similar) with the code in it. Press the Save icon in the area above and it will save as a new file with a `.R` extension, indicating that it contains R code.

You can also run the code from here in Console by clicking **Run** under the tab name. 

Note: if you already have an R Markdown file open, it will copy it into that instead. If you don't want it to do that, create a new R script first by selecting **File > New File > R Script**. 

## Rhistory files

Notably, you can save your entire history (everything you did on a project so far) by clicking the Save icon in that area, or by typing the `savehistory` function followed by the path to where you want to save it, and the filename you want to give it, like so:

`savehistory("~/Desktop/history.Rhistory")`

Either way the file is saved with the extension `.Rhistory`, which means it can be opened in an R project.


