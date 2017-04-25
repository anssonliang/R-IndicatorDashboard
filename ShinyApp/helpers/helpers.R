library(googleVis)
library(RJDBC)

subSqlParams <- function(sql = "", group_by = "", granularity = "",
                         filter = "", table = "",
                         st_date = "", end_date = ""){
        sql <- gsub(pattern = '\t'    , replacement = " ", x = sql)
        sql <- gsub(pattern = "%group_by"   , replacement = group_by    , x = sql)
        sql <- gsub(pattern = "%filter"     , replacement = filter      , x = sql)
        sql <- gsub(pattern = "%granularity", replacement = granularity , x = sql)
        sql <- gsub(pattern = "%st_date"    , replacement = st_date     , x = sql)
        sql <- gsub(pattern = "%end_date"   , replacement = end_date    , x = sql)
        sql <- gsub(pattern = '\ {2,}'      , replacement = " "         , x = sql)

        sql
}

debug(subSqlParams)

local_trunc_date <- function(date, format){
        date <- strptime(date, format)
        date <- trunc(date, "hours")
        date <- strftime(date, format =  format)
        date <- paste0("'", date, "'")
}

debug(local_trunc_date)

granTableSufix <- function (granularity = character()){
        switch(granularity,
               Hourly  = " "  ,
               Daily   = "_DY",
               Weekly  = "_WK",
               Monthly = "_MO")
}

debug(granTableSufix)

colapseFilterValue <- function (filter){
        if (length(filter) > 0)
                paste0("'",filter, "'", collapse = ',') # transfer into -> 'val1', 'val2', 'val3'
}

debug(colapseFilterValue)

buildFilter <- function(group_by, filter_value){
        if (group_by != "'Whole Network'"){
                filter_value <- paste0(" AND ",group_by, " in (", filter_value, ")") # AND group_by_object in ('val1', 'val2', 'val3')
        }else {
                " "
        }
}

debug(buildFilter)

build_query <- function(kpi, input, jdbcConnection, user){
        group_by    <- if(input$group_by == 'Whole Network') "'Whole Network'" else input$group_by
        granularity <- granTableSufix  (input$granul)           # returns _WK, _DY depending on the granularity
        filter      <- buildFilter     (group_by, colapseFilterValue(input$filter))           # colapse all elements of filter surrounded by
        st_date     <- local_trunc_date(input$start_date , "%Y-%m-%d %H:%M")
        end_date    <- local_trunc_date(input$end_date   , "%Y-%m-%d %H:%M")
        sql_body    <- queryOptima   ("get SQL body in SQL builder", sql$body, kpi, input$tech)[1,1]

        subSqlParams( sql         = sql_body
                     ,group_by    = group_by
                     ,granularity = granularity
                     ,filter      = filter
                     ,st_date     = st_date
                     ,end_date    = end_date)
}

debug(build_query)

extract_KPI_data <- function(kpi, input) {

        sql_local  <- build_query(kpi, input)
        LogMsg("Sql Local is: ", sql_local, show = dev)

        df <- queryOptima(paste0(input$tech, " ", kpi), sql_local)

        validate(
                need(class(df) == class(data.frame()), "Connection expired while retrieving data! Please login again!")
        )
        msl_tsl <- queryOptima(paste0("MSL/TSL' for '",input$tech, " ", kpi),
                               sql$msl_tsl, kpi, input$tech)

        #print(msl_tsl)
        if (nrow(df)){
                names(df) <- c("DATETIME", "element", "value")

                df <- spread(df, element, value)

                if(nrow(msl_tsl) == 1){
                        df <- cbind(df, MSL = c(msl_tsl[1, 1]), TSL = c(msl_tsl[1, 2]))
                        #### Reorder datetime MSL and TSL in front
                        inlist    <- names(df)[  names(df) %in% c(names(df)[1], "MSL", "TSL")]
                        outoflist <- names(df)[!(names(df) %in% c(names(df)[1], "MSL", "TSL"))]
                        df        <- df[,c(inlist, outoflist)]
                }
                df

        }
        df
}

debug(extract_KPI_data)

select <- function(cv = character()){
        cv <- cv[!(cv %in% c("DATETIME", "MSL", "TSL"))]
        cv <- cv[order(cv)]
        cv
}

debug(select)

gvisDataTransform <- function(df = data.frame(), unit = character()){
        unit <- gsub(pattern = " ", replacement = "", unit)
        if (unit == '%')
                df[,-1] <- sapply(df[,-1], function(x){x/100} )
        df
}

debug(gvisDataTransform)

LogMsgTemplate <- function(user = character()){
        function(..., show = T){
                if (show) cat (paste(Sys.time(), " user: '", user, "' ", paste0(...), "\n", sep = "")) # Log
        }
}

debug(LogMsgTemplate)

choose_tab <- function(old_value, new_set){
        if (length(old_value) == 1){
                if (old_value %in% new_set)
                        old_value
                else
                        new_set[1]
        } else{
                new_set[1]
        }
}

debug(choose_tab)

period_back      <- function(granularity = character(), period){
        as.numeric(
                switch(granularity,
                       Hourly  = as.numeric(period)*3600,
                       Daily   = as.numeric(period)*3600*24,
                       Weekly  = as.numeric(period)*3600*24*7)
        )

}

debug(period_back)

granTableSufixDashboard <- function (granularity = character()){
        switch(granularity,
               Hourly = "_RW",
               Daily  = "_DY",
               Weekly = "_WK")
}

debug(granTableSufixDashboard)

morrisxLabelsmap <- function(granularity){
        switch(granularity,
               Hourly  = "hour",
               Daily   = "day",
               Weekly  = "day")
}

debug(morrisxLabelsmap)
