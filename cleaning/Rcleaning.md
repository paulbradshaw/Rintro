# Data cleaning tips in R

## Multi-row headings

It's not uncommon for datasets to come with headers split across multiple rows. Here's one way to sort them out.

First, you need to extract each row into its own object. The simplest (but not quickest) way to do that is to do this:

`row1 <- colnames(yourdata)`

Then re-import your data with the second heading row, and repeat the process to create `row2` and so on.

Once you have your 2 or 3 rows in 2 or 3 objects, you can combine them into one using `paste0` like so:

`heads <- paste0(row1,row2,row3)`

Type `heads` to see the results.

Finally, assign that to the column names of your dataset:

`colnames(yourdata) <- heads`

Note that the 
