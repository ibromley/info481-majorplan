# import libraries
library(DBI)
library(dplyr)

# read data files
setwd("~/University of Washington/Senior/Fall/Info 481/Final Project/info481-majorplan/SQL")
majorcourses <- read.csv("../data/major_courses.csv")

# runs a query against the database
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

# SPROC: add majors and course prereqs

