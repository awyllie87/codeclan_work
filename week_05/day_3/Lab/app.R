library(shiny)
library(tidyverse)
library(bslib)

olympics <- CodeClanData::olympics_overall_medals
seasons <- unique(olympics$season)
medals <- unique(olympics$medal)

ui <- fluidPage(
  theme = bs_theme(bootswatch = "lux"),
  titlePanel("Five Country Medal Comparison"),
  
  sidebarLayout(
    sidebarPanel(
      radioButtons(inputId = "season_input",
                   label = tags$b("Season"),
                   choices = seasons
      ),
      
      radioButtons(inputId = "medal_input",
                   label = tags$b("Medal Type"),
                   choices = medals
      )
    ),
    
    mainPanel(
      plotOutput("olympics_plot"),
    )
  )
  
)

server <- function(input, output) {
  output$olympics_plot <- renderPlot({
    olympics %>%
      filter(team %in% c("United States",
                         "Soviet Union",
                         "Germany",
                         "Italy",
                         "Great Britain")) %>%
      filter(medal == input$medal_input) %>%
      filter(season == input$season_input) %>%
      ggplot() +
      aes(x = team, y = count, fill = medal) +
      geom_col() +
      scale_fill_manual(values = c(Gold = "gold", Silver = "lightgrey", Bronze = "brown"))
  })

}

# Run the application 
shinyApp(ui = ui, server = server)