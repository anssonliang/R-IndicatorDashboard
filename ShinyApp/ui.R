

#Bootshtrap theme downloaded from "https://bootswatch.com/cerulean/"
#Bootshtrap theme downloaded from "https://bootswatch.com/slate/"

# Define the UI backbone of the App
shinyUI(
      fluidPage(
            title   = "KPI Dashboard"
            , theme = "bootstrap.css"
            , style = "padding: 0"
            , width = "100%"
            , uiOutput("page_wrapper")
            , uiOutput("debug_wrapper")
      )
)
