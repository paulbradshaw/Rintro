#Define the UI object
ui <- shiny::fluidPage(
  #Add a table to our UI, specifying various parameters
  h4("Goals by the Bears"), #Set a heading
  shiny::dataTableOutput("dfHead") #this naming means it can be called as output$dfHead below
)
#Create a function called 'server' that takes two parameters it calls input and output
server <- function(input, output) {
  output$dfHead <- shiny::renderDataTable(goals) #render the goals data frame
}
#use those two as parameters for the shinyApp function
shiny::shinyApp(ui = ui, server = server)