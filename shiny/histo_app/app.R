#Define the UI object
ui <- shiny::fluidPage(
  #Add a slider to our UI, specifying various parameters
  sliderInput(inputId = "bins", #store input in bins, i.e. input$bins
              label = "Number of bins:",
              min = 1,
              max = 50,
              value = 30), #default value
  sliderInput(inputId = "colour", #store input in bins, i.e. input$colour
              label = "Colour:",
              min = 1,
              max = 10,
              value = 5), #default value
  #Add an output
  plotOutput(outputId = "hist") #store output in hist, i.e. output$hist
)
#Create a function called 'server' that takes two parameters it calls input and output
server <- function(input, output) {
  #output$hist corresponds to outputId = "hist" above
  output$hist <- shiny::renderPlot(
    {
      x <- games$Goals.for #define the data (vector) being used
      #input$bins corresponds to inputId = "bins" above
      binBreaks <- seq(min(x), max(x), length.out = input$bins + 1)
      hist(x, breaks = binBreaks, col = input$colour)
    }
  )
}
#use those two as parameters for the shinyApp function
shiny::shinyApp(ui = ui, server = server)