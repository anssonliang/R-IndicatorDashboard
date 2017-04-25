if(dev){
        output$debug_wrapper <- renderUI(verbatimTextOutput("client_data_text") )# Debug
        c_data <- session$clientData
        output$client_data_text <- renderText({
                cnames <- names(c_data)

                all_values <- lapply(cnames, function(name) {
                        paste(name, c_data[[name]], sep=" = ")
                })
                paste(all_values, collapse = "\n")
        })

        observe( LogMsg("Resizer KPI  width is: ", session$clientData$output_resizer_kpi_width))
        observe( LogMsg("Resizer Dash width is: ", session$clientData$output_resizer_dash_width))
}