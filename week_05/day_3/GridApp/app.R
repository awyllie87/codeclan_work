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
library(bslib)

medals <- CodeClanData::olympics_overall_medals
seasons <- unique(medals$season)
all_teams <- unique(medals$team)

ui <- fluidPage(
  #  theme = bs_theme(bootswatch = "slate"),
  theme = "style.css",
  titlePanel(h1("Title")),
  
  fluidRow(
    plotOutput("medal_plot"),
  ),
  
  fluidRow(
    column(width = 1, offset = 1,
           radioButtons(inputId = "season_input",
                        label = tags$i("Season"),
                        choices = seasons)),
    
    column(width = 5, align = "center",
    tags$a("Olympics Website", href = "https://www.Olympic.org/")),
    
    column(width = 4,
           selectInput(inputId = "country_input",
                       label = tags$b("Select Country"),
                       choices = all_teams))
  ),
  
)

server <- function(input, output) {
  output$medal_plot <- renderPlot({
    medals %>% filter(team == input$country_input,
                      season == input$season_input) %>%
      ggplot(aes(medal, count, fill = medal)) +
      geom_col()
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
