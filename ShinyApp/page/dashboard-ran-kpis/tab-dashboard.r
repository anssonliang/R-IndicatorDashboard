source("page/dashboard-ran-kpis/view-dashboard.r" , local = T)
source("page/dashboard-ran-kpis/query-dashboard.r", local = T)

output$kpi_dashboard <-  renderUI    (dashboardTabUI())

onExtractDashData    <- eventReactive(c(TRUE, autoInvalidate(),input$refresh.dash),{
                query$dashboard(input$dashTech, input$dashGran, input$dashHistPeriod)
})

output$dashGraphs    <- renderUI({
        session$clientData$output_resizer_dash_width
        LogMsg("KPI Dashboard request...") # Log
        list_temp <- plot_output_list(onExtractDashData(), output, input)
        LogMsg("KPI Dashboard processed!") # Log
        list_temp

})

renderPlot <- function(plotname, data, input){
        renderChart({
                #session$clientData$output_dashResizer_width
                validate(
                        need(class(onExtractDashData()) == "data.frame", "Data was not found for the gven parameters"),
                        need(nrow (onExtractDashData()) >= 1, "Data was not found for the gven parameters")
                )
                kpi.cfg.row <-grep( paste("^",plotname,"$", sep = "")
                                    , kpi.cfg$kpi
                )
                mympl <- mymPlot(
                        data
                        ,plotname
                        ,kpi.cfg$msl[kpi.cfg.row]
                        ,kpi.cfg$tsl[kpi.cfg.row]
                        ,kpi.cfg$unit[kpi.cfg.row],
                        isolate(input$dashGran)
                )
                mympl$set(dom = plotname)
                return(mympl)
        })

}

debug(renderPlot)

renderTitle <- function(plotname){
        kpi.cfg.row <- grep( paste("^",plotname,"$", sep = ""), kpi.cfg$kpi)
        title       <- ifelse(length(kpi.cfg$title[kpi.cfg.row]), kpi.cfg$title[kpi.cfg.row], plotname)
        renderText({title})
}

debug(renderTitle)

plot_output_list <- function(data, output, input){
        local({
        max_plots       <- NCOL (data)
        first_data_col  <- grep ("DATETIME", names(data), fixed = T) + 2
        plotname        <- names(data)[first_data_col:max_plots]

        lapply(plotname, function(plotname) {

                title <- paste("title", plotname, sep = '_')

                output[[plotname]] <- renderPlot (plotname, data, input)
                output[[title]]    <- renderTitle(plotname)

                # Create the UI to be rendered in the browser
                column(
                        4,
                        h4(strong(textOutput(title)), align = "center", style ="margin-bottom:0px; margin-top:0px"),#padding-bottom:0px"),
                        showOutput(plotname, graph.params$lib)
                )
        })
        })
}

debug(plot_output_list)

mymPlot <- function (df = data.frame(), kpi = character(), MSL = numeric(), TSL = numeric(), unit = character(), granularity = "Hourly"){

        dat <-  transform(df, DATETIME = as.character(DATETIME))
        if (!is.na(MSL) && !is.na(TSL)){
                ydat <- c(dat[, kpi], MSL, TSL)
                ydat <- ydat[!is.na(ydat)]
                ymax <- ceiling(max(ydat))
                ymin <- floor(min(ydat))
                ymin <- ifelse( (min(ydat))> (ymin + 0.5), ymin + 0.5 ,ymin)

                goals = c(MSL,TSL)
        }else{
                ydat <- dat[, kpi]
                ydat <- ydat[!is.na(ydat)]
                ymax <- ceiling(max(ydat))
                ymin <- floor(min(ydat))

                goals = data.frame()
        }

        dat <- dat[,c("DATETIME", kpi)]
        plot <- mPlot(x = "DATETIME", y = kpi, type = "Line", data = dat)
        plot$set(resize = "true")
        plot$addParams(
                width = graph.params$width,
                height = graph.params$height,
                pointSize = graph.params$pointSize,
                lineWidth = graph.params$lineWidth,
                ymax = ymax,
                ymin = ymin,
                goals = goals,
                goalStrokeWidth	= 2,
                goalLineColors = c("red", "green"),
                labels = "v",
                postUnits = ifelse(length(unit), paste(" ", unit, sep = ""), " v"),
                xLabels = morrisxLabelsmap(granularity),
                xLabelAngle = '45'
                #, resize = "true"
        )

        return(plot)
}

debug(mymPlot)