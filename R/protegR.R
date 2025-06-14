# UI ----------------------------------------------------------------------


ui <- dashboardPage(
  dashboardHeader(title = "Mini App"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Accueil", tabName = "home", icon = icon("home")),
      menuItem("Graphique", tabName = "plot", icon = icon("chart-line")),
      menuItem("Maintenance", icon = icon("screwdriver-wrench"),
               menuSubItem("AC inspection",tabName = "AC_inspection", icon = icon("list")),
               menuSubItem("Store",tabName = "warehouse", icon = icon("warehouse")))
    )
  ),
  dashboardBody(
    tags$head(
      # Icône par défaut (flèche vers la gauche)
      tags$style(HTML("
        .main-header .sidebar-toggle:before {
          content: none; /* Ne rien afficher par défaut */
        }
      ")),
      # Script pour changer l’icône selon l’état de la sidebar
      tags$script(HTML("
        $(document).on('shiny:connected', function() {
          function updateIcon() {
            if ($('body').hasClass('sidebar-collapse')) {
              $('.sidebar-toggle').html('<i class=\"fa fa-angle-right\"></i>');
            } else {
              $('.sidebar-toggle').html('<i class=\"fa fa-angle-left\"></i>');
            }
          }

          $('.sidebar-toggle').on('click', function() {
            setTimeout(updateIcon, 300); // attendre l'animation
          });

          updateIcon(); // initialisation
        });
      "))
    ),
    tabItems(
      tabItem(tabName = "home",
              h2("Bienvenue dans l'application !")
      ),
      tabItem(tabName = "plot",
              sliderInput("n", "Nombre d'observations", 10, 100, 50),
              plotOutput("hist")
      ),
      tabItem(tabName = "AC_inspection",
              h2("page pour le suivi des avions")),
      tabItem(tabName = "warehouse",
              h2("page pour les pièces"))
    )
  )
)


# SERVER ------------------------------------------------------------------

server <- function(input, output, session) {
  output$hist <- renderPlot({
    hist(rnorm(input$n), main = "Histogramme", col = "steelblue")
  })
}
