# Data for all sessions  ---------------------------------------------------------
# * ------ library --------------------------------------------------------

library(here)
library(shiny)
library(protegR)
library(tidyr)
library(purrr)

addResourcePath("images", "inst/app/www")

#config_s3_location <- read_rds("inst/app/data/config_s3_location.rds")
#config_s3_access <- read_rds("inst/app/data/config_s3_access.rds")
#message("lecturelocale: config_s3_location")

# * ------ AWS connect + load config --------------------------------------
#AWS_connection()
#config_global <- s3readRDS(object = str_c(config_s3_location$s3_main_folder,"/config_files/config_global.rds"),
#                           bucket = config_s3_location$s3_bucket)
#addResourcePath("images", "inst/app/www")


# * ------ load R files ------------------------------------------------------------
list.files("R", full.names = TRUE, pattern = "\\.R$") %>% walk(source)
#list.files("R/internal", full.names = TRUE, pattern = "\\.R$") %>% walk(source)






# START APP ---------------------------------------------------------------
shinyApp(ui, server)
