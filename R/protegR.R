library(shinydashboard) # sur EC2: lu avant shinydashboard

# UI ----------------------------------------------------------------------


ui <- dashboardPage(
  skin = "blue",
  dashboardHeader(title = uiOutput("dynamic_header")),
  dashboardSidebar(uiOutput("dynamic_sidebar")),
  dashboardBody(uiOutput("dynamic_body"))
)


# SERVER ------------------------------------------------------------------

server <- function(input, output, session) {
   ns <- session$ns


  output$hist <- renderPlot({
    hist(rnorm(input$n), main = "Histogramme", col = "steelblue")
  })



  # APP CONTROL  -------------------------------------------------------
  # * ------ initialisation -------------------------------------------------
#  session$userData$config_s3_location <- config_s3_location
#  session$userData$config_global <- config_global
  session$userData$timestamp_activity <- reactiveVal(Sys.time())
  session$userData$timestamp_cookie <- reactiveVal(Sys.time())

  session$userData$user_info <- list(
    valid_user = reactiveVal(NULL),
    #    valid_user = NULL,
    token_value = NULL,
    user_auth = reactiveVal(NULL),  # uniquement cette partie est réactive
    user_role = reactiveVal(NULL)
  )

  just_logged_out <- reactiveVal(FALSE) # pour éviter de lire les cookies au logout, juste avant qu'ils soient effacés

  #  session$userData$user_role <- reactiveVal(NULL)
  #  session$userData$user_auth <- reactiveVal(NULL)

  # Fonction pour ne pas à devoir modifier ce fichier (load tous les modules utilisés par l'app)
#  protegR_load_modules_servers(config_s3_location,session)

  # * ------ login ----------------------------------------------------------
  observeEvent(input$login, {
#    req(input$username, input$password)  # Assure que les champs sont remplis

    just_logged_out(FALSE)
    valid_user <- as.list(TRUE)

    session$userData$user_info$valid_user(valid_user)
    #perform_login(valid_user,
    #              token_value,
    #              session)

  })

  observeEvent(session$userData$user_info$valid_user(), {
    session$userData$user_info$user_auth(input$username)
  })

  observeEvent(input$logout, {
    just_logged_out(TRUE)
    perform_logout(session = session )
  })

  # DYNAMIC DASHBOAD ----------------------------------------------
  # * ------ LOAD DATA -------------------------------------------------

  # * ------ header construction ----------------------------------------------
  output$dynamic_header <- renderUI({
    if (is.null(session$userData$user_info$user_auth())) {
      dashboardHeader(title = "ProtegR DEMO")
    } else {
      NULL
    }
  })

  # * ------ sidebar construction ---------------------------------------------
  output$dynamic_sidebar <- renderUI({
    if (is.null(session$userData$user_info$user_auth())) {
      dashboardSidebar(collapsed = TRUE,disable = TRUE)

    } else{
      dashboardSidebar(
        sidebarMenu(
          menuItem("Accueil", tabName = "home", icon = icon("home")),
          menuItem("Graphique", tabName = "plot", icon = icon("chart-line")),
          menuItem("Maintenance", icon = icon("screwdriver-wrench"),
                   menuSubItem("AC inspection",tabName = "AC_inspection", icon = icon("list")),
                   menuSubItem("Store",tabName = "warehouse", icon = icon("warehouse")))
        )
      )
    }
  })

  # * ------ Body construction ------------------------------------------------------

  output$dynamic_body <- renderUI({
    if (is.null(session$userData$user_info$user_auth())) {
      # Écran de login simple
      fluidPage(
        h2("Connexion"),
        protegR_login_ui()
      )
    } else {  tagList(
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
    }
  })

  # ACTIVITIES/COOKIE -------------------------------------------------------
  # * ------ for cookie in config menu --------------------------------------


  # * ------ check inactivity -----------------------------------------------


  # * ------ login automatique si cookie -------------------------------------------------------------




}
