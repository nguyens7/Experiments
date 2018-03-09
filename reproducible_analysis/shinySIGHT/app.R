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
         # Input: Specification of range within an interval ----
         sliderInput("range", "Range Particle Size (nm):",
                     min = 1, max = 1000,
                     value = c(50,250)),
         textInput("group_by", "Things to group by"),
         selectInput("calculation", "Select calculation",
                     c("Summarize","Count")),
         selectInput("samples",
                     "Sample:",
                     c("All",
                       unique(as.character(df$sample)))),
         selectInput("filter",
                     "Filter:",
                     c("All",
                       unique(as.character(df$filter))))
      ),
      # Show a plot of the generated distribution
      mainPanel(
        helpText("This is an app that allows users to upload .csv files from nanoparticle tracking
             such as the Nanosight by Malvern."),

        br(),
        
        tabsetPanel(type = "tabs",
                    tabPanel("Plot", plotOutput("nanoPlot")),
                    tabPanel("Plotly", plotlyOutput("plotly")),
                    tabPanel("Calculations", DT::dataTableOutput("calc_table")),
                    
                    fluidRow(DT::dataTableOutput("table"))
        
                )
                   )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

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
       scale_y_continuous(expand = c(0,0)) +
       facet_wrap(~tech_rep)
    
   })
   
   output$plotly <- renderPlotly({

     df    <- read_csv("tidy_nano.csv") 
     
     min_range <- input$range[1]
     max_range <- input$range[2]
     user_sample <-  input$samples
     line_size <- input$line
     
     # draw the histogram with the specified number of bins
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
     data <- read_csv("tidy_nano.csv")
     
     if (input$samples != "All") {
       data <- data[data$sample == input$samples,]
     }
     if (input$filter != "All") {
       data <- data[data$filter == input$filter,]
     }
     data
   }))
   
   
   output$calc_table <- DT::renderDataTable(DT::datatable({
     data <- read_csv("tidy_nano.csv")
     
     groups <- input$group_by
     
     summary_stat <- function(df, ..., param_var) {
       param_var <- enquo(param_var)
       df %>% 
         group_by_(.dots = lazyeval::lazy_dots(...)) %>% 
         summarise(N = length(!!param_var, na.rm = TRUE),
                   mean = mean(!!param_var, na.rm = TRUE),
                   sd = sd(!!param_var),
                   se = sd/sqrt(N))
     }

     data %>% 
       group_by_(groups) %>% 
       summarize(count = n())
   }))
   
   
}

# Run the application 
shinyApp(ui = ui, server = server)



