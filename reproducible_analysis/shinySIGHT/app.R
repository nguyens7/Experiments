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
library(shinythemes)
library(cowplot)
library(plotly)
library(DT)

df    <- read_csv("tidy_nano.csv")
# Define UI for application that draws a histogram
ui <- fluidPage(
   
  theme = shinytheme("flatly"),
   # Application title
   titlePanel("shinySIGHT"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
     
      sidebarPanel(
         # Input: Specification of range within an interval ----
         # Input: Select a file ----
         fileInput("file1", "Choose CSV File",
                   multiple = TRUE,
                   accept = c("text/csv",
                              "text/comma-separated-values,text/plain",
                              ".csv")),
         
         # Horizontal line ----
         tags$hr(),
         
         sliderInput("range", "Range Particle Size (nm):",
                     min = 1, max = 1000,
                     value = c(50,250)),
         textInput("group_by", "Things to group by"),
         selectInput("calculation", "Select calculation",
                     c("Summarize","Count")),
         selectInput("samples",
                     "Sample:",
                       unique(as.character(df$sample))),
         selectInput("filter",
                     "Filter:",
                     c("All",
                       unique(as.character(df$filter)))),
         submitButton("Apply Changes")
      ),
      # Show a plot of the generated distribution
      mainPanel(
        helpText("This is an app that allows users to upload .csv files from nanoparticle tracking
             such as the Nanosight by Malvern."),
        
        br(),
        
        tabsetPanel(type = "tabs",
                    tabPanel("Plot", plotOutput("nanoPlot")),
                    
                    br(),
                    
                    tabPanel("Plotly", plotlyOutput("plotly")),
                    
                    br(),
                    
                    tabPanel("Calculations", DT::dataTableOutput("calc_table")),
                    
                    br(),
                    
                    fluidRow(DT::dataTableOutput("table"))
        
                )
                   )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
# Plots -------------------------------------------------------------------

   output$nanoPlot <- renderPlot({
     df    <- read_csv("tidy_nano.csv") 
     
     min_range <- input$range[1]
     max_range <- input$range[2]
     user_sample <-  input$samples
     line_size <- input$line
     
     df %>%
       filter(sample == user_sample ,
              particle_size >= min_range,
              particle_size <= max_range) %>%
       ggplot(aes( x = particle_size, y = values, color = filter)) +
       geom_line() +
       scale_y_continuous(expand = c(0,0)) +
       facet_wrap(~tech_rep)
    
   })
   
   output$plotly <- renderPlotly({

     df    <- read_csv("tidy_nano.csv") 
     
     min_range <- input$range[1]
     max_range <- input$range[2]
     user_sample <-  input$samples
     line_size <- input$line
     
     p <- df %>%
       filter(sample == user_sample ,
              particle_size >= min_range,
              particle_size <= max_range) %>%
       ggplot(aes( x = particle_size, y = values, color = filter)) +
       geom_line() +
       scale_y_continuous(expand = c(0,0)) +
       facet_wrap(~tech_rep)

      p
      
   })
   
   output$table <- DT::renderDataTable(DT::datatable({
     
     req(input$file1)
     
     data <- read_csv(input$file1$datapath)
     
     if (input$samples != "All") {
       data <- data[data$sample == input$samples,]
     }
     if (input$filter != "All") {
       data <- data[data$filter == input$filter,]
     }
     data
   }))
   
   
   output$calc_table <- DT::renderDataTable(DT::datatable({
     req(input$file1)
     
     data <- read_csv(input$file1$datapath)
     
     groups <- input$group_by
     
     data %>% 
       group_by_(.dots = groups) %>% 
       summarize(count = n())
   }))
   
}

# Run the application 
shinyApp(ui = ui, server = server)



