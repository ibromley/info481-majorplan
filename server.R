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
  updateSelectizeInput(session, 'search', choices = c('All', tags$TagName), selected = 'All')
  
  output$major.table <- renderTable({
    selected.tag <- input$search
    majors <- runQuery("SELECT MajorName, TagName
                        FROM MAJOR M
                          JOIN MAJOR_TAG MT ON MT.MajorID = M.MajorID
                          JOIN TAG T ON T.TagID = MT.TagID")
    
    if(selected.tag != 'All') {
      majors <- majors %>% filter(TagName == selected.tag)
    }
    
    majors
  })
})