grabseats <- function(url){
  #Note: this is designed to grab seat numbers from pages on planefinder, e.g. "https://planefinder.net/data/flight/FR3105"
  #Store the page
  page <- read_html(testurl)
  #This grabs every table cell (in <td> tags)
  cells_html <-html_nodes(testpage,xpath='//td')
  #Convert to text
  cells_text <- html_text(seats_html)
  #Grab the 9th one, which is the seats
  seats <- seats_text[[9]]
  return(seats)
}