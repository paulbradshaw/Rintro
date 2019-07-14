#Define the UI object
ui <- shiny::fluidPage()
#Create a function called 'server' that takes two parameters it calls input and output
server <- function(input, output) {}
#use those two as parameters for the shinyApp function
shiny::shinyApp(ui = ui, server = server)