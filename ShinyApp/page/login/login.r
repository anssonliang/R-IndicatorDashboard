### Optima Connection credentials
user <- "m51572"
passwd  <- "m51572"

output$page_wrapper    <-  renderUI(mainPageUI())

##### DB helpers   ######
is_dbConnection <- function(conn){
      class(conn)[1] == "JDBCConnection"
}

debug(is_dbConnection)

my_dbConnection <- function(user = character(), pass = character(), jdbcDriver){

      jdbcConnection <- function(){}

      # Make a connection using JDBC driver and connection URL
      jdbcConnection <- tryCatch({
            dbConnect(jdbcDriver, "jdbc:oracle:thin:@//10.117.20.71:1521/optima7.pm.tdctech.dk", user, pass)
      },
      warning = function (w){
            LogMsg("'Login Warning message: ", w$message)
      },
      error   = function (e) {
            LogMsg("'Login Error Message: "  , e$message)
      }
      )

      jdbcConnection
}

debug(my_dbConnection)

my_dbDisconect  <- function(conn){
      function(){
            LogMsg(
                  tryCatch({
                        dbDisconnect(conn)
                        "DB connection Closed!" # Log
                  },
                  warning = function (w){
                        paste0("DB connection dusconnect warning: ", w) # Log
                  },
                  error = function (e) {
                        paste0("DB connection dusconnect error: "  , e) # Log
                  }
                  )
            )
      }
}

debug(my_dbDisconect)

my_dbGetRes    <- function(conn){
      function(query_name, sql_local, ...){

            LogMsg("Sent   '",query_name, "' query....", show = dev) # Log

             validate(
                   need(is_dbConnection(conn), "Connection has expired! Please log in again!", label = 'conn_expired')
             )
            result <- tryCatch({
                  dbGetQuery(conn, sql_local, ...) # Working subtitution SQL
            },
            warning = function (w){
                  LogMsg("warning: SQL Fail to retriev data! ", w$message)
                  data.frame()
            },
            error = function (e) {
                  LogMsg("error: SQL Fail to retriev data! ", e$message, show = dev)
                  data.frame()
            })
            LogMsg( "End of '",query_name, "' query!", show = dev) # Log

            result
      }
}

debug(my_dbGetRes)

my_db_init      <- function(){
      .jinit()
      # Tell R where the JDBC driver is located
      jdbcDriver <- JDBC(driverClass ="oracle.jdbc.OracleDriver",
                         classPath   = file.path(getwd(), "RJDBC_Driver/ojdbc6.jar")
      )
      jdbcDriver
}

debug(my_db_init)

LogMsg           <- LogMsgTemplate (user)
OptimaConnection <- my_dbConnection(user, passwd, my_db_init())
dbConnRelease    <- my_dbDisconect (OptimaConnection)
queryOptima      <- my_dbGetRes    (OptimaConnection)
