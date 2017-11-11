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
  tags <- runQuery("SELECT * FROM TAG")
  updateSelectizeInput(session, 'search', choices = tags$TagName, server = TRUE)
  
  #output$major.table <- renderTable(data.frame(majors))
})