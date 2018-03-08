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
library(DT)

df    <- read_csv("tidy_nano.csv")
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
        
        tabsetPanel(type = "tabs",
                    tabPanel("Histogram", plotOutput("distPlot")),
                    tabPanel("Plot", plotOutput("nanoPlot")),
                    tabPanel("Plotly", plotlyOutput("plotly")),
                    tabPanel("Data", 
        fluidRow(
          
          
          column(4,
                 selectInput("TESTfilter",
                             "Filter:",
                             c("All",
                               unique(as.character(df$filter))))
          ),
          column(4,
                 selectInput("TESTsample",
                             "Sample:",
                             c("All",
                               unique(as.character(df$sample))))
          )
        
        ),
        # Create a new row for the table.
        fluidRow(
          DT::dataTableOutput("table")
        )))
        
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
     df    <- read_csv("tidy_nano.csv") 
     
     min_range <- input$range[1]
     max_range <- input$range[2]
     user_sample <-  input$samples
     line_size <- input$line
     
     # draw the histogram with the specified number of bins
    df %>%
       filter(sample == user_sample ,
                particle_size >= min_range,
              particle_size <= max_range) %>%
       ggplot(aes( x = particle_size, y = values, color = filter))+
       geom_line() +
       facet_wrap(~tech_rep)
    
   })
   
   output$plotly <- renderPlotly({

     df    <- read_csv("tidy_nano.csv") 
     min_range <- input$range[1]
     max_range <- input$range[2]
     user_sample <-  input$samples
     line_size <- input$line
     
     # draw the histogram with the specified number of bins
     df %>%
       filter(sample == user_sample ,
              particle_size >= min_range,
              particle_size <= max_range) %>%
       ggplot(aes( x = particle_size, y = values, color = filter))+
       geom_line() +
       facet_wrap(~tech_rep)
     
   })
   
   output$table <- DT::renderDataTable(DT::datatable({
     data <- read_csv("tidy_nano.csv")
     
     if (input$TESTsample != "All") {
       data <- data[data$sample == input$TESTsample,]
     }
     if (input$TESTfilter != "All") {
       data <- data[data$filter == input$TESTfilter,]
     }
     data
   }))
}

# Run the application 
shinyApp(ui = ui, server = server)



