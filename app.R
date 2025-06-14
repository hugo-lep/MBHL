library(shiny)

# Définition de l'interface utilisateur (UI)
ui <- fluidPage(
  titlePanel("Mini App Shiny"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("num", "Choisissez un nombre :", 1, 100, 50)
    ),
    mainPanel(
      textOutput("result")
    )
  )
)

# Définition du serveur (Server)
server <- function(input, output) {
  output$result <- renderText({
    paste("Vous avez choisi le nombre :", input$num)
  })
}

# Exécution de l'application Shiny
shinyApp(ui = ui, server = server)
