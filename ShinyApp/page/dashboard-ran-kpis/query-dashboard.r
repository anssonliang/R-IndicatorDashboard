################# DASHBOARD TAB SQLs                  #################
sql$dash2GKPIs   <-" -- 2G KPIs
                  -- ,CSSR_2G
                  -- ,MIN_DROP
                  -- ,AVAILABILITY_2G

                  -- 2G_Traffic
                  ,TOTAL_TCH_TRAFFIC_SUM
                  ,TRAFFIC_AMR_TCH_HR_SUM
                  ,TRAFFIC_AMR_TCH_FR_SUM

                   -- 2G/3G combined KPIs
                  -- ,Droprate_2G3G"

sql$dash3GKPIs   <-"-- 3G KPIs
                   -- ,CSSR_3G
                   -- ,PS_ACCESSIBILITY_3G
                   -- ,MIN_DROP_3G
                   -- ,MIN_DROP_PS
                   -- ,AVAILABILITY_3G

                   -- 3G TRAFFIC
                   ,CS_Traffic_3G
                   ,PS_DATA_Total_GB"

sql$dash4GKPIs   <-"-- 4G KPIs
                  -- ,AVAILABILITY_4G
                  -- ,Min_Btw_ERAB_Abn_Rel
                  -- ,Estab_4G_SR
                  -- ,Intra_HO_4G_SR

                  -- 4G Traffic
                  ,PS_Data_Volume"

sql$dashboard <- "select T1.DATETIME
                  ,T1.NETWORK

                  %KPIs2G
                  %KPIs3G
                  %KPIs4G

                  from
                  HUAWEI_UTRAN.NETWORK_KPIS%granularity T1
                  join HUAWEI_EUTRAN.NETWORK_KPIS%granularity T2 on T2.DATETIME = T1.DATETIME
                  left join HUAWEI_GERAN.NETWORK_KPIS%granularity T3 on T3.DATETIME = T1.DATETIME
                  where T1.DATETIME >= to_date( '%st_date', 'YYYY-MM-DD HH24:MI:SS') AND T1.DATETIME <= to_date( '%end_date', 'YYYY-MM-DD HH24:MI:SS')
                  Order by T1.DATETIME"


################# Query related to DASHBOARD tab      #################

query$dashboard <- function(technology, granularity, period = numeric()){

      validate(
            need(!is.numeric(period)  , "Numerical value for historical period must be provided!"),
            need(!is.null(granularity), "Granularity must be provided!"),
            need(!is.null(technology) , "At least one technology must be chosen!")
      )

      st_date     <- Sys.time() - period_back(granularity, period)
      end_date    <- Sys.time()
      table_sufix <- granTableSufixDashboard(granularity)

      sql_local <- subSqlParams (sql$dashboard, granularity = table_sufix, st_date = st_date, end_date = end_date)
      sql_local <- gsub(pattern = "%KPIs2G" , replacement = ifelse (("2G" %in% technology), sql$dash2GKPIs, "") , x = sql_local)
      sql_local <- gsub(pattern = "%KPIs3G" , replacement = ifelse (("3G" %in% technology), sql$dash3GKPIs, "") , x = sql_local)
      sql_local <- gsub(pattern = "%KPIs4G" , replacement = ifelse (("4G" %in% technology), sql$dash4GKPIs, "") , x = sql_local)

      df <- queryOptima(query_name = "dashboard", sql_local)
      validate(
            need(class(df) == class(data.frame()), "Connection 2 expired while retrieving data! Please login again!")
      )
      df[,1] <- as.POSIXct(df[,1], format = "%Y-%m-%d %H:%M:%S")
      df
}

debug(query$dashboard)