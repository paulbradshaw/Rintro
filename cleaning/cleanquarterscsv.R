cleanquartercsv <- function(url){
  csvurl <- "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2017/09/Dementia-Data-Collection-Q1-2017-18-CSV-35KB.csv"
  #using readLines because we cannot easily remove lines using read.csv
  linestoclean <- readLines(url(csvurl))
  #The CSV has column headings in row 12, so we need to remove the first 12 lines
  #see https://stackoverflow.com/questions/31824721/delete-lines-of-a-text-file-in-r
  skip12rows <- linestoclean[-(1:12)]
  #Now convert to datafram, reading the new top line as headings
  #See https://stackoverflow.com/questions/15860071/read-csv-header-on-first-line-skip-second-line
  withheadings = read.csv(textConnection(skip12rows), header = TRUE, stringsAsFactors = FALSE)
  #Each month has 9 columns of data, followed by an empty column. The first 2 columns have the areas. So first we grab the 2 columns of labels...
  monthlabels <- withheadings[c(1,2)]
  #...plus 9 columns of data:
  month1 <- withheadings[c(3:11)]
  month2 <- withheadings[c(13:21)]
  month3 <- withheadings[c(23:31)]
  #Next we add the labels to each sheet
  month1 <- cbind(monthlabels,month1)
  month2 <- cbind(monthlabels,month2)
  month3 <- cbind(monthlabels,month3)
  #Extract the months from the original uncleaned data
  dates <- strsplit(linestoclean[12],",")
  #add a column which specifies the month
  month1name <- dates[[1]][[3]]
  month2name <- dates[[1]][[13]]
  month3name <- dates[[1]][[23]]
  month1$month <- month1name
  month2$month <- month2name
  month3$month <- month3name
  #make the column names all the same - otherwise rbind will throw an error
  colnames(month2) <- colnames(month1)
  colnames(month3) <- colnames(month1)
  #Combine all three
  months1to3 <- rbind(month1, month2, month3)
  #Remove the unneeded months
  rm(month1,month1name,month2,month2name,month3,month3name,monthlabels)
  return (months1to3)
}