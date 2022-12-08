library(shiny)
library(leaflet)
library(tidyverse)

whisky <- CodeClanData::whisky

ui <- fluidPage(
  selectInput("region", "Region:", unique(whisky$Region)),
  leafletOutput("distillery_map")
)

server <- function(input, output, session) {
  
  output$distillery_map <- renderLeaflet(
    whisky %>% 
      filter(Region == input$region) %>% 
      leaflet() %>% 
      addTiles() %>% 
      addCircleMarkers(lng = ~Longitude, lat = ~Latitude))
}

shinyApp(ui, server)