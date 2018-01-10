#Function to grab ccgs for each postcode in a list, and return a list
#This creates an empty list called 'resultslist'
resultslist = c()
#loop through the list of postcodes - this must be a vector
for (i in postcodes){
  url <- paste("http://api.postcodes.io/postcodes/",i, sep="")
  #This tries the lines of code in curly brackets first, but if there's an error, it moves on to the error = part after the comma
  tryCatch({
    jsoneg <- fromJSON(url)
    status <- jsoneg[['status']]
    print(status)
    print(jsoneg[['result']][['ccg']])
    #This time we store the results of drilling down into part of the JSON
    ccg <- jsoneg[['result']][['ccg']]
    #Then we add it to the list
    resultslist = c(resultslist, ccg)
  },
  #what happens if there's an error
  error = function(cond) {
    resultslist = c(resultslist, "no data")
  }
  )
  return(resultslist)
}