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
    
    if(selected.tag != '') {
      # get all majors associated with tag
      majors <- runQuery(paste0("SELECT MajorName, TagName
                                  FROM MAJOR M
                                    JOIN MAJOR_TAG MT ON MT.MajorID = M.MajorID
                                    JOIN TAG T ON T.TagID = MT.TagID
                                  WHERE TagName = '", selected.tag, "'"))
      
      # create a new matrix for major plan table
      major.plan <- matrix(0, ncol = nrow(majors) + 1, nrow = 0)
      
      # loop through majors associated to tag
      for(major in majors$MajorName){
        # select courses for each major
        courses <- runQuery(paste0("SELECT CourseName
                                    FROM COURSE C
                                      JOIN MAJOR_COURSE MC ON MC.CourseID = C.CourseID
                                      JOIN MAJOR M ON M.MajorID = MC.MajorId
                                    WHERE M.MajorName = '", major, "'"))
        
        if(nrow(courses) != 0) {
          for(course in courses$CourseName) {
            print(course)
            # create course row
            course.row <- c(course, rep(0, nrow(majors)))

            major.plan <- rbind(major.plan, course.row)
            
            
            #major.plan[[major]] = "X"
          }
        }
      }
      
      df <- as.data.frame(major.plan)
      colnames(df) <- c("Courses", majors$MajorName)
      
      df
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