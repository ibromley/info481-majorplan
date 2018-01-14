library(shinydashboard)
library(shiny)
library(DT)

header <- dashboardHeader(
  title = span(img(src="uwlogo.png", height = 50), "UW Major Plan"),
  titleWidth = 250,
 
  dropdownMenu(type = "tasks", badgeStatus = "success",
               taskItem(value = 90, color = "green",
                        "Prerequisite Completion"
               ),
               taskItem(value = 17, color = "aqua",
                        "Application Status"
               ),
               taskItem(value = 20, color = "red",
                        "Graduation Progress"
               )
  ),
  dropdownMenu(type = "notifications",
               notificationItem(
                 text = "12 course prequisites met",
                 icon("file-text"),
                 status = "success"
               ),
               notificationItem(
                 text = "Admission Decision Pending",
                 icon = icon("exclamation-triangle"),
                 status = "warning"
               )
  ),
  dropdownMenu(type = "messages",
               messageItem(
                 from = "Academic Advising ",
                 message = "Your appointment is confirmed.",
                 time = "12/8/17"
               ),
               messageItem(
                 from = "New User",
                 message = "How do I register?",
                 icon = icon("question"),
                 time = "13:45"
               ),
               messageItem(
                 from = "Degree Progress",
                 message = "Your transcript has been processed.",
                 icon = icon("arrow-right"),
                 time = "12:21"
               )
  )
)


body <- dashboardBody(
  fluidRow(
    # A static valueBox
    valueBox(2 * 2, "Majors Compared", icon = icon("balance-scale")),
    
    # Dynamic valueBoxes
    valueBoxOutput("progressBox"),
    
    valueBoxOutput("approvalBox")
  ),
  fluidRow(
    # Clicking this will increment the progress amount
    box(width = 4, actionButton("count", "Increment progress"))
  ),

    box(title = "Interest Navigator", solidHeader = TRUE, 
        status = "primary",
        "Find related majors",
        selectizeInput(
          'search',
          label = NULL,
          choices = NULL,
          options = list(
            placeholder = "Search an area of interest...",
            maxItems = 1
          )
        ),
        uiOutput("major.table")
    ),
    
    tabBox(
      tabPanel("How to Choose a Major", 
               "Familiarize yourself with all the majors offered at UW. You'll likely be able to identify those that you'd like to explore futher, and conversely, those that you are not interested in. Narrowing it down to 10 or 20 possible areas of interest is a great first step. Follow the links to the General Catalog for more information about each of these possible majors to review admission and graduation requirements. Reviewing majors by interest area is another great way to explore your options. "),
      tabPanel("Visit departmental websites", 
               "Almost every program and department at the UW has its own website which you should be able to find by searching for it (i.e., 'uw geography'). These sites, all different, will include an introduction to the subject for new students, and will suggest the best way for you to learn more about the majors they offer.")
    )
    
  )

sidebar <- dashboardSidebar(
  width = 250,
  sidebarMenu(
    menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
    menuItem("Find Courses", icon = icon("search"), tabName = "widgets",
             badgeLabel = "new", badgeColor = "green"),
    menuItem("Schedule Finder", icon = icon("calendar")),
    menuItem("Admission Plan", icon = icon("graduation-cap"), tabName = "widgets")
  )

)

dashboardPage(
  skin = "purple",
  header,
  sidebar,
  body
)