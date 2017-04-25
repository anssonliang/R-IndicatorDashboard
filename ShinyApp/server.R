package <- c("shiny", "rJava", "googleVis","ggplot2","tidyr","rCharts","RJDBC","reshape2","xlsx","readxl","stringr")
lapply(package, require, character.only = TRUE)

source("./www/config.R")
source("./www/input-date-time.R")
source("./helpers/ShinyComponents.R")

# Run once (manually) to set the default port for a shiny app
options("shiny.port" = 6970)

shinyServer(function(input, output, session) {

      # Initialise functions
      autoInvalidate    <- function(...){}
      OptimaConnection  <- function(...){}
      dbConnRelease     <- function(...){}
      queryOptima       <- function(...){}
      LogMsg            <- function(...){}

      # Initialise values
      user              <- character()
      query             <- list()
      sql               <- list()

      ###### Load lockal helper funtions
      source("helpers/helpers.R"                       , local = T)

      ###### Load the main page backbone
      source("page/main-page/view-main-page.r"         , local = T)

      ###### Login screen and db connection establishment
      source("page/login/login.r"                      , local = T)

      ###### Render 3 Column KPIs dashboard
      source("page/dashboard-ran-kpis/tab-dashboard.r" , local = T)

      ###### DEBUG
      source("page/debug/debug.r"                      , local = T)

      ##### Session ends Output shows a message and stops the app
      session$onSessionEnded(function(){
            isolate({
                  dbConnRelease()
                  LogMsg("Session: closed!")
            })
      })
})
