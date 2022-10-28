# Cleaning a huge postcodes lookup CSV

This notebook describes the process of converting a 164MB CSV containing postcode data, into a smaller file for converting postcode district into local authority.

The data is downloaded from the ONS: [Postcode to Output Area to Lower Layer Super Output Area to Middle Layer Super Output Area to Local Authority District (December 2011) Lookup in England and Wales](https://ons.maps.arcgis.com/home/item.html?id=ef72efd6adf64b11a2228f7b3e95deea).

That zip file is then unzipped, and the CSV file renamed as `postcodeslookup.csv` for easy importing into R:

```{r}
#import CSV
postcodeslookup <- read.csv('postcodeslookup.csv')
```

We can split the postcodes column, and create a new data frame containing the results, all in one:

```{r}
districtsonly <- as.data.frame(str_split_fixed(postcodeslookup$PCD8, " ", 2))
```

The `str_split_fixed(postcodeslookup$PCD8, " ", 2)` part splits the column `PCD8` on the space `" "`, and creates 2 columns. On its own this creates a matrix, so we make sure it is a data frame by wrapping it in parentheses after `as.data.frame`. Finally the results are put in a new variable called `districtsonly`

That gives us a new data frame with 2 column: the first part of the postcode and (sometimes with a space) the second part. We just need to add the local authorities back in. Here's how we do that:

```{r}
districtsonly$authority <- postcodeslookup$LSOA11NM
```

Finally, write the result as a CSV:

```{r}
write.csv(districtsonly,'postcodedistrictlookup.csv')
```

