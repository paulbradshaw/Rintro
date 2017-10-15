cleanquarter <- function(url){
  #Note: you will need the httr and readxl packages installed first
  GET(url, write_disk("workingfile.xlsx", overwrite=TRUE))
  #Each month has 9 columns of data, followed by an empty column. The first 2 columns have the areas. So first we grab the 2 columns of labels...
  monthlabels <- read_excel("workingfile.xlsx", sheet=2, skip=12)[1:2]
  #...plus 9 columns of data:
  month1 <- read_excel("workingfile.xlsx", sheet=2, skip=12)[3:11]
  month2 <- read_excel("workingfile.xlsx", sheet=2, skip=12)[13:21]
  month3 <- read_excel("workingfile.xlsx", sheet=2, skip=12)[23:31]
  #Next we add the labels to each sheet
  month1 <- cbind(monthlabels,month1)
  month2 <- cbind(monthlabels,month2)
  month3 <- cbind(monthlabels,month3)
  #add a column which specifies the month
  month1name <- read_excel("workingfile.xlsx", sheet=2, skip=6)[3]
  month2name <- read_excel("workingfile.xlsx", sheet=2, skip=6)[13]
  month3name <- read_excel("workingfile.xlsx", sheet=2, skip=6)[23]
  month1$month <- colnames(month1name)
  month2$month <- colnames(month2name)
  month3$month <- colnames(month3name)
  #make the column names all the same - otherwise rbind will throw an error
  colnames(month2) <- colnames(month1)
  colnames(month3) <- colnames(month1)
  #Combine all three
  months1to3 <- rbind(month1, month2, month3)
  #Remove the unneeded months
  rm(month1,month1name,month2,month2name,month3,month3name,monthlabels)
  return (months1to3)