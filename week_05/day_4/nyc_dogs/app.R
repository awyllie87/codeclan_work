library(shiny)
library(tidyverse)

nyc_dogs <- CodeClanData::nyc_dogs
gender <- unique(nyc_dogs$gender)
breed <- unique(nyc_dogs$breed)

ui <- fluidPage(
  fluidRow(
    column(width = 2,
           fluidRow(
             radioButtons("gender",
                          label = "Gender",
                          choices = gender)
           ),
           fluidRow(
             actionButton("update", "Update View"))
    ),
    column(width = 4,
           fluidRow(
             selectInput("breed",
                         label = "Breed",
                         choices = breed)))
  ),
  fluidRow(
    DT::DTOutput("dogs_table")
  )
)

server <- function(input, output, session) {
  
  dogs_filtered <- eventReactive(
    eventExpr = input$update,
    {nyc_dogs %>% 
        filter(gender == input$gender,
               breed == input$breed)})
  
  output$dogs_table <- DT::renderDT({
    dogs_filtered()})
  
}

shinyApp(ui, server)

nyc_dogs %>% 
  group_by(borough, dog_name) %>% 
  filter(dog_name != "N/A") %>% 
  summarise(count = n()) %>% 
  slice_max(count, n = 3)
