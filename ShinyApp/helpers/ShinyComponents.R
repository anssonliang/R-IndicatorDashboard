panel <- function(f, contentObj, panelTitle = "", class = ""){
      div(class = paste0("panel ", class),
          div(class = "panel-heading",
              h3(panelTitle, class = "panel-title")
          )
          ,div(class = "panel-body"
               , f(contentObj)
          )
      )
}

debug(panel)

alert <- function(title, content, class){
      div(
            span(
                  strong(title, style = 'font-size : large;')
                  , actionButton(
                        "x", label = "x", class = "close", `data-dismiss` = "alert"
                  )
            )
            ,p(content)
            ,class = paste0("alert alert-dismissible ", class)
      )
}

debug(alert)