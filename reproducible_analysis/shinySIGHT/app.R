#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
library(cowplot)
library(plotly)


# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("shinySIGHT"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
         sliderInput("bins",
                     "Number of bins:",
                     min = 1,
                     max = 1000,
                     value = 10),
         # Input: Specification of range within an interval ----
         sliderInput("range", "Range Particle Size (nm):",
                     min = 1, max = 1000,
                     value = c(50,250)),
         textInput("group_by", "Things to group by"),
         selectInput("calculation", "Select calculation",
                     c("Summarize","Count")),
         selectInput("samples", "Select sample of interest",
                     c("mG15.5","400","200","100","fluorx100","fluor")),
         selectInput("filter", "Filter",
                                 c("Yes","No"))
      ),
      # Show a plot of the generated distribution
      mainPanel(
        helpText("This is an app that allows users to upload .csv files from nanoparticle tracking
             such as the Nanosight by Malvern."),
        
        
        
        br(),
        
         plotOutput("distPlot"),
        
        br(),
        
         plotOutput("nanoPlot"),
        
        br(),
        
         plotlyOutput("plotly")
        
        
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
   
   output$distPlot <- renderPlot({
      # generate bins based on input$bins from ui.R
      x    <- faithful[, 2] 
      bins <- seq(min(x), max(x), length.out = input$bins + 1)
      
      # draw the histogram with the specified number of bins
      hist(x, breaks = bins, col = 'darkgray', border = 'white')
   })
   
   output$nanoPlot <- renderPlot({
     # generate bins based on input$bins from ui.R
     data    <- read_csv("tidy_nano.csv") 
     
     min_range <- input$range[1]
     max_range <- input$range[2]
     user_sample <-  input$samples
     line_size <- input$line
     
     # draw the histogram with the specified number of bins
    data %>%
       filter(sample == user_sample ,
                particle_size >= min_range,
              particle_size <= max_range) %>%
       ggplot(aes( x = particle_size, y = values, color = filter))+
       geom_line() +
       facet_wrap(~tech_rep)
    
   })
   
   output$plotly <- renderPlotly({

     data    <- read_csv("tidy_nano.csv") 
     min_range <- input$range[1]
     max_range <- input$range[2]
     user_sample <-  input$samples
     line_size <- input$line
     
     # draw the histogram with the specified number of bins
     data %>%
       filter(sample == user_sample ,
              particle_size >= min_range,
              particle_size <= max_range) %>%
       ggplot(aes( x = particle_size, y = values, color = filter))+
       geom_line() +
       facet_wrap(~tech_rep)
     
   })
   
   # Generate a summary of the data ----
   # output$summary <- renderPrint({
   #   summary(d())
   # })
   # 
   # # Generate an HTML table view of the data ----
   # output$table <- renderTable({
   #   d()
   # })
}

# Run the application 
shinyApp(ui = ui, server = server)



