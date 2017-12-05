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
  tags <- runQuery("SELECT * FROM TAG")
  updateSelectizeInput(session, 'search', choices = c('Search an area of interest...', tags$TagName), selected = 'Search an area of interest...')
  
  output$major.table <- renderTable({
    # get all tags in a database
    selected.tag <- input$search
    majors <- runQuery("SELECT MajorName, TagName
                       FROM MAJOR M
                       JOIN MAJOR_TAG MT ON MT.MajorID = M.MajorID
                       JOIN TAG T ON T.TagID = MT.TagID")
    
    if(selected.tag != 'Search an area of interest...') {
      # filter tags on search
      majors <- majors %>% filter(TagName == selected.tag)
      
      # create new dataframe for major plan
      major.plan <- data.frame(matrix(0, ncol = nrow(majors) + 1, nrow = 0))
      
      # loop through majors associated to tag
      for(major in majors$MajorName){
        # select courses for each major
        courses <- runQuery(paste0("SELECT CourseName
                                    FROM COURSE C
                                      JOIN MAJOR_COURSE MC ON MC.CourseID = C.CourseID
                                      JOIN MAJOR M ON M.MajorID = MC.MajorId
                                    WHERE M.MajorName = '", major, "'"))
        
        if(nrow(courses) != 0) {
          for(i in 1:nrow(courses)) {
            # add course as row if unique
            course.row <- data.frame(matrix(0, ncol = nrow(majors) + 1, nrow = 0))
            colnames(course.row) <- c("Courses", majors$MajorName)
            
            major.plan <- rbind(major.plan, course.row)
            
            
            #major.plan[[major]] = "X"
          }
        }
        
        # set column names to names of majors
        colnames(major.plan) <- c("Courses", majors$MajorName)
      }
      
      major.plan
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