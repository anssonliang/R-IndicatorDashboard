mainPageUI <- function(){
      navbarPage(
            title     = "KPI Monitor"
            ,inverse  = FALSE
            ,position = c("fixed-top")
            ,footer   = column(
                  width  = 12
                  ,style = "text-align: center;"
                  ,"HUAWEI 2016"
            )
            , tabPanel(
                  title = "Dashboard RAN KPIs"
                  ,icon = icon("desktop")
                  ,plotOutput(
                        outputId = "resizer_dash"
                        , width  = "100%"
                        , height = "0px"
                  )
                  ,fluidPage(
                        style = "margin-top: 75px;"
                        ,uiOutput("kpi_dashboard")
                  )
            )
      )
}

debug(mainPageUI)