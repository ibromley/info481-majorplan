# import libraries
library(DBI)
library(dplyr)

# read data files
setwd("~/University of Washington/Senior/Fall/Info 481/Final Project/info481-majorplan/SQL")
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

# SPROC: add major course dependencies

# SPROC: add major requirements

# SPROC: add major tags
for(major in names(tags)) {
  tags.of.major <- tags %>%
    select(major) %>%
    na.omit()
  
  numTags <- length(tags.of.major) + 1
  for(i in 1:numTags) { 
    print(tags.of.major[i,])
    paste0("
    BEGIN TRAN
    INSERT INTO TAG(TagName)
    VALUES(", tags.of.major[i,], ")

    INSERT INTO MAJOR_TAG()
    
    IF @@ERROR <> 0
      ROLLBACK TRAN
    ELSE
      COMMIT TRAN"
    )  
  }
}
