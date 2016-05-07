#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
ui <- shinyUI(fluidPage(
   
   # Application title
   titlePanel("Book Word Clouds"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
        selectInput("book", "Choose a book:", 
                    choices = c("Frankenstein", "The Jungle", "Walden")),
        actionButton("update", "Change"),
        hr(),
        sliderInput("max",
                    "Number of Words:",
                    min = 1,  max = 100, value = 25)
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
         plotOutput("plot")
      )
   )
))

# Define server logic required to draw a histogram
server <- shinyServer(function(input, output) {
   
      # generate bins based on input$book from ui.R
     bookInput <- reactive({
       # Change when the "update" button is pressed...
       input$update
       # ...but not for anything else
       isolate({
         withProgress({
           setProgress(message = "Processing corpus...")
           switch(input$book,
                  "Frankenstein" = frank,
                  "The Jungle" = jungle,
                  "Walden" = walden)
         })
       })
     })
       
      
     
     output$plot <- renderPlot({
      wordcloud(bookInput(), scale=c(5,0.5), max.words=input$max, random.order=FALSE,
                rot.per=0.35, use.r.layout=FALSE, colors=brewer.pal(8, "BuPu"))
     })
   })


# Run the application 
shinyApp(ui = ui, server = server)

