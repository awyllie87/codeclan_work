library(shiny)
library(tidyverse)
library(shinydashboard)

students_big <- CodeClanData::students_big

regions <- unique(students_big$region)
genders <- unique(students_big$gender)

ui <- dashboardPage(
  dashboardHeader(title = "Students Info"),
  dashboardSidebar(),
  dashboardBody(
    # inputs
    
    fluidRow(
      column(width = 2,
             fluidRow(
               radioButtons("handed", 
                            label = "Handedness", 
                            choices = c("R", "L", "B"),
                            inline = TRUE)),
             fluidRow( 
               actionButton("update", "Update View"))
      ),
      
      column(width = 4,
             selectInput("region",
                         label = "Region",
                         choices = regions)
      ),
      
      column(width = 1,
             selectInput("gender",
                         label = "Gender",
                         choices = genders)
      ),
      column(width = 4,
             selectInput("colour",
                         label = "Colour",
                         choices = colours(distinct = TRUE)))
    ),
    
    # outputs
    
    fluidRow(
      column(width = 6,
             plotOutput("travel_plot")),
      column(width = 6,
             plotOutput("languages_plot"))
    ),
    
    fluidRow(
      DT::DTOutput("students_table")
    )
  )
)

server <- function(input, output, session) {
  
  filtered_students <- eventReactive(
    eventExpr = input$update,
    {students_big %>% 
        filter(handed == input$handed,
               region == input$region,
               gender == input$gender)}
  )
  
  output$students_table <- DT::renderDT({
    filtered_students()
  })
  
  output$travel_plot <- renderPlot({
    filtered_students() %>% 
      ggplot() +
      geom_bar(aes(x = travel_to_school), fill = input$colour)
  })
  
  output$languages_plot <- renderPlot({
    filtered_students() %>% 
      ggplot() +
      geom_bar(aes(x = languages_spoken), fill = input$colour)
  })
}

shinyApp(ui, server)