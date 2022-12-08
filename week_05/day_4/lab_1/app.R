library(shiny)
library(tidyverse)

students_big <- CodeClanData::students_big
age <- unique(students_big$ageyears)

ui <- fluidPage(
  fluidRow(radioButtons("age_input",
                        label = "Age",
                        choices = age,
                        inline = TRUE)),
  fluidRow(
    column(width = 6,
           plotOutput("height_plot")),
    column(width = 6,
           plotOutput("armspan_plot")))
)

server <- function(input, output, session) {
  
  students_filtered <- eventReactive(
    eventExpr = input$age_input,
    valueExpr = { 
      students_big %>% 
        filter(ageyears == input$age_input)}
  )
  
  output$height_plot <- renderPlot({
    students_filtered() %>% 
      ggplot() +
      geom_histogram(aes(x = height), bins = 30)
  })
  
  output$armspan_plot <- renderPlot({
    students_filtered() %>% 
      ggplot() +
      geom_histogram(aes(x = arm_span), bins = 30) 
    
  })
}

shinyApp(ui, server)