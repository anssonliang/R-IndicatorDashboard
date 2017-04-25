graph.params <- list()

dev <- T

graph.params$height <- 220
graph.params$width <- "100%"
graph.params$pointSize <- 3
graph.params$lineWidth <- 2
graph.params$lib <- "morris"


refreshMins <- 5 # mins
refreshTimerValue <- function(min = numeric()){
        min*60000
} # min = refTime/60000 -> reftime = min*60000

kpi.cfg <- data.frame()
kpi.cfg <- data.frame(kpi=
              c("TOTAL_TCH_TRAFFIC_SUM",
              "TRAFFIC_AMR_TCH_HR_SUM",
              "TRAFFIC_AMR_TCH_FR_SUM",
              "CS_TRAFFIC_3G",
              "PS_DATA_TOTAL_GB",
              "PS_DATA_VOLUME"), stringsAsFactors = F)

kpi.cfg$msl <-  c(rep(NA, 6))

kpi.cfg$tsl <- c(rep(NA, 6))

kpi.cfg$unit <-c(rep("Erl",4),
                 rep("GB",2))

kpi.cfg$title <-c("2G TCH Traffic",
                  "2G TCH Traffic Half Rate",
                  "2G TCH Traffic Full Rate",
                  "3G CS Traffic",
                  "3G PS Data Traffic",
                  "4G PS Data Traffic")
