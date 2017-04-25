dashboardTabUI <- function(){
      fluidRow(
            wellPanel ( style = "padding-bottom:0px; padding-top:5px;",
                        fluidRow(
                              column(2,
                                     checkboxGroupInput(  inputId  = "dashTech"
                                                          , label    = "Technology"
                                                          , choices  = c("2G", "3G", "4G")
                                                          , selected = c("2G", "3G", "4G")
                                                          , inline   = T),
                                     style = "margin-bottom:0px; "
                              ),
                              column(2,
                                     selectInput( inputId    = "dashGran"
                                                  , label    = "Granularity"
                                                  , choices  = c("Hourly", "Daily", "Weekly")
                                                  , selected = c("Hourly")
                                     ),
                                     style = "margin-bottom:0px; "
                              ),
                              column(2,
                                     selectInput( inputId    = "dashHistPeriod"
                                                  , label    = "Historical period"
                                                  , choices  = seq(1:168)
                                                  , selected = 72
                                     ),
                                     style = "margin-bottom:0px; "
                              ),
                              column(1,
                                     actionButton(
                                           "refresh.dash", label = "Refresh"
                                           , class = "btn btn-info"
                                           , icon  = icon("fa fa-refresh")
                                           , style = "margin-top: 23px;" # width: 98%; height:36px; margin-left: 1%;
                                     )
                              )
                        )
            ),
            fluidRow(htmlOutput("dashGraphs"))
      )
}

debug(dashboardTabUI)