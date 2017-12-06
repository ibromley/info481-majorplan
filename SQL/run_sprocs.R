# import libraries
library(DBI)
library(dplyr)

# read data files
setwd("~/University of Washington/Senior/Fall/Info 481/Final Project/info481-majorplan/SQL")
majors <- read.csv("../data/majors.csv", na.strings=c("","NA"))
courses <- read.csv("../data/major_courses.csv", na.strings=c("","NA"))
reqs <- read.csv("../data/major_reqs.csv", na.strings=c("","NA"))
tags <- read.csv("../data/major_tags.csv", na.strings=c("","NA"))

# reformat first column name
colnames(courses)[1] <- "ACMS"
colnames(reqs)[1] <- "ACMS"
colnames(tags)[1] <- "ACMS"

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

# add majors
for(i in 1:nrow(majors)) {
  runQuery(paste0("CALL uspAddMajors('", majors[i,], "')"))
}

# add major course dependencies
for(major in names(courses)) {
  courses.of.major <- courses %>%
    select(major) %>%
    na.omit()
  
  if(nrow(courses.of.major) != 0) {
    for(i in 1:nrow(courses.of.major)) {
      if(grepl(";", courses.of.major[i,])){
        split <- strsplit(toString(courses.of.major[i,]), ";")
        runQuery(paste0("CALL uspAddCourses('", split[[1]][1], "', '", split[[1]][2] , "', '", major, "')"))
      } else {
        runQuery(paste0("CALL uspAddCourses('", split[[1]][1], "', NULL, '", major, "')"))
      }
    }
  }
}

# add major requirements
for(major in names(reqs)) {
  reqs.of.major <- reqs %>%
    select(major) %>%
    na.omit()
  
  if(nrow(reqs.of.major) != 0) {
    for(i in 1:nrow(reqs.of.major)) {
      runQuery(paste0("CALL uspAddReqs('", reqs.of.major[i,], "', '", major, "')"))
    }
  }
}

# add major tags
for(major in names(tags)) {
  tags.of.major <- tags %>%
    select(major) %>%
    na.omit()
  
  if(nrow(tags.of.major) != 0) {
    for(i in 1:nrow(tags.of.major)) { 
      runQuery(paste0("CALL uspAddTags('", tags.of.major[i,], "', '", major, "')"))
    }
  }
}


