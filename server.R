library(shinydashboard)
library(DBI)
library(dplyr)

runQuery <- function(query) {
  # establish database connection
  conn <- dbConnect(
    drv = RMySQL::MySQL(),
    dbname = "majorplan",
    host = "info481-db.ibromley.net",
    username = "application",
    password = "9QEdAfhOYtksJYfp"
  )
  
  # defer close database connection
  on.exit(dbDisconnect(conn))
  
  # run query and return result
  result <- dbGetQuery(conn, query)
  return(result)
}

shinyServer(function(input, output, session) {
  # get all tags in a database
  tags <- runQuery("SELECT * FROM TAG")
  updateSelectizeInput(session, 'search', choices = c('', tags$TagName))
  
  output$major.table <- renderTable({
    selected.tag <- input$search
    
    if(selected.tag == 'data science') {
      read.csv('data/fake_ds.csv')
    } else if(selected.tag == 'med') {
      read.csv('data/fake_med.csv')
    }
  })
  
  output$progressBox <- renderValueBox({
    valueBox(
      paste0(25 + input$count, "%"), "Prerequisite Progress", icon = icon("list"),
      color = "green"
    )
  })
  
  output$approvalBox <- renderValueBox({
    valueBox(
      "20%", "Degree Completion", icon = icon("university"),
      color = "yellow"
    )
  })
})