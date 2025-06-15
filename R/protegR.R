ui <- dashboardPage(
  dashboardHeader(title = "Mini Dashboard"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Accueil", tabName = "accueil", icon = icon("home")),
      menuItem("Stats", tabName = "stats", icon = icon("chart-bar"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "accueil",
              h2("Bienvenue sur la page d'accueil"),
              actionButton("btn", "Clique ici")
      ),
      tabItem(tabName = "stats",
              h2("Statistiques"),
              verbatimTextOutput("compteur")
      )
    )
  )
)

server <- function(input, output, session) {
  compteur <- reactiveVal(0)

  observeEvent(input$btn, {
    compteur(compteur() + 1)
  })

  output$compteur <- renderText({
    paste("Bouton cliqué", compteur(), "fois")
  })
}
