library(shiny)

ui <- fluidPage(
  titlePanel("Mon App Shiny simple"),
  sidebarLayout(
    sidebarPanel(
      textInput("nom", "Quel est ton nom ?"),
      actionButton("go", "Dire bonjour")
    ),
    mainPanel(
      textOutput("salutation")
    )
  )
)

server <- function(input, output, session) {
  observeEvent(input$go, {
    output$salutation <- renderText({
      paste("Bonjour", input$nom, "!")
    })
  })
}

shinyApp(ui, server)

