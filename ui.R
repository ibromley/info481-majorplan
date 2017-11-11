library(shiny)
library(DT)

shinyUI(
  fluidPage(
    titlePanel("UW Major Plan"),
    
    selectizeInput('search', label = NULL, choices = NULL, options = list(maxItems = 1)),
    
    tableOutput('major.table')
  )
)