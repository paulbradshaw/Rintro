# Dealing with XML in R

XML isn't as easy to deal with as it should be in R. Although there is [an XML package](https://cran.r-project.org/web/packages/XML/XML.pdf), it is not straightforward to use, and worse, XML files rarely play nice with it either.

In reality, then, there are a variety of ways to handle XML files depending on the problems they represent. This page documents those I've come across so far.

First, install `XML`: `install.packages('XML')` and then `library(XML)`.

## Sources of XML files

If you need XML files to play with, here are some suggestions:

* Food inspection ratings data can be found in XML on the [Food Standards Agency inspections API](http://ratings.food.gov.uk/open-data/en-GB).

## Level 1: XML files that play nice

A tutorial on using the package to grab an XML file [can be found on R-Bloggers here](https://www.r-bloggers.com/r-and-the-web-for-beginners-part-ii-xml-in-r/)

This will work if the XML file is nicely formatted. If not...

## Level 2: XML files that don't play nice - converting to lists or using XPath

These solutions [come from Stack Overflow](https://stackoverflow.com/questions/17198658/how-to-parse-xml-to-r-data-frame)

