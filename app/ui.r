

library(shiny)
library(shinydashboard)
ui <- dashboardPage(skin = "blue",
                    dashboardHeader(title = "Manhattan House Finder",titleWidth = 280),
                    dashboardSidebar(sidebarMenu(
                        menuItem("Introduction", tabName = "Introduction", icon = icon("home")),
                        menuItem("Map", tabName = "Map", icon = icon("map")),
                        menuItem("Details", tabName = "Details", icon = icon("search-location")),
                        menuItem("Prediction and Recommandation", tabName = "Prediction & Recommandation", icon = icon("chart-line")),
                        menuItem("Source", tabName = "Source", icon = icon("table"))
                    ),
                    width = 280),
                    dashboardBody(
                        tabItems(
                            #introduction
                          tabItem(tabName = "Introduction",
                                  fluidPage(
                                    fluidRow(
                                      box(width = 12, title = "Introduction",status = "primary",
                                          h4("NYC Shooting Crime Map")
                                      )),
                                    fluidRow(
                                      box(width = 12, title = "User Guide",status = "primary",
                                          h4("What Does This Map Do?")
                                      )),
                                    fluidRow(
                                      box(width = 4, title = "User Guide",color = "blue",
                                          solidHeader = TRUE, 
                                          h4("What Does This Map Do?")),
                                      box(width = 4, title = "User Guide",color = "blue",
                                          solidHeader = TRUE, 
                                          h4("What Does This Map Do?")),
                                      box(width = 4, title = "User Guide",color = "blue",
                                          solidHeader = TRUE, 
                                          h4("What Does This Map Do?"))),
                                    fluidRow(
                                      img(src = "../background.jpg",width = 580))
                                  )),
                          
                            
                            #map
                          tabItem(tabName = "Map",
                                  fluidPage(
                                    fluidRow(
                                      column(3,
                                             sliderInput("check2_pr", "Price Per Room:",min = 850, max = 5400, value = 5400)),
                                      column(3,
                                             sliderInput("check2_ty", "Size:",min = 10, max = 200, value = 100)),
                                      column(3,
                                             selectInput("check2_re", "Restaurant Type:", c("Food I Like"="",list("American", "Chinese", "Italian", "Japanese", "Pizza", "Others")), multiple=TRUE)),
                                      column(3,
                                             selectInput("check2_tr", "Transportation:", list("Don't Care","It's everything")))),
                                    
                                    fluidRow(
                                      column(3,
                                             selectInput(" cv ", "School nearby:",list("K-8","other"))),
                                      
                                      column(3,
                                             selectInput("check2_cb", "Retail & Market:", list("Just Amazon","Important!"))),
                                      column(3,
                                             selectInput("check2_ct", "Crime:",list("Don't care","Safety more"))),
                                      column(3,
                                             selectInput("check2_ma","Noise:",list("Who cares.","No noise")))),
                                    
                                    fluidRow(
                                      column(3,
                                             h1("Choose What You Like"),
                                             fluidRow(
                                               column(2,
                                                      div(id = "action",actionButton("no_rec2", "Reset"))),
                                             )),
                                      column(3,
                                             selectInput("check2_cb", "Park:", list("Always stay at home","I love park!")))
                                    ),
                                    
                                    hr(),
                                    
                                    
                                    
                                    fluidRow(
                                      column(6,
                                             leafletOutput("map3", width = "auto", height = 490),
                                             fluidRow(column(1,actionButton("click_back_buttom",label="Click here back to original view")))
                                      ),
                                      column(6,
                                             dataTableOutput("recom")
                                      )))
                          ),
                          
                          
                          
                          
                          
                          
                          
                          
                          
                            #tabItem(tabName = "Map",
                                    #),
                            
                            #details
                            tabItem(tabName = "Details",
                                  
                                    ),
                            
                            #prediction and recommendation
                            tabItem(tabName = "Prediction and Recommendation",
                                    fluidPage(
                                      fluidRow(
                                        column(3,
                                               sliderInput("check2_pr", "Price Per Room:",min = 850, max = 5400, value = 5400)),
                                        column(3,
                                               selectInput("check2_ty", "Size:",c("Types I Like"="",list("Studio","1B","2B", "3B","4B")), multiple=TRUE)),
                                        column(3,
                                               selectInput("check2_re", "Restaurant Type:", c("Food I Like"="",list("American", "Chinese", "Italian", "Japanese", "Pizza", "Others")), multiple=TRUE)),
                                        column(3,
                                               selectInput("check2_tr", "Transportation:", list("Don't Care","It's everything")))),
                                      
                                      fluidRow(
                                        column(3,
                                               selectInput(" cv ", "School nearby:",list("K-8","other"))),
                                      
                                        column(3,
                                               selectInput("check2_cb", "Retail & Market:", list("I'm allergic.","Drink one or two.","Let's party!"))),
                                        column(3,
                                               selectInput("check2_ct", "Crime:",list("Don't care","Safety more"))),
                                        column(3,
                                               selectInput("check2_ma","Noise:",list("Who cares.","No noise")))),
                                    
                                      fluidRow(
                                        column(3,
                                               h1("Choose What You Like"),
                                               fluidRow(
                                                 column(2,
                                                        div(id = "action",actionButton("no_rec2", "Reset"))),
                                               )),
                                        column(3,
                                               selectInput("check2_cb", "Park:", list("I'm allergic.","Drink one or two.","Let's party!")))
                                        ),
                                      
                                      hr(),
                                      
                                      
                                      
                                      fluidRow(
                                        column(6,
                                               leafletOutput("map3", width = "auto", height = 490),
                                               fluidRow(column(1,actionButton("click_back_buttom",label="Click here back to original view")))
                                        ),
                                        column(6,
                                               dataTableOutput("recom")
                                        )))
                                    ),
                                    
                                    
                                    
                                    
                        
                        
                            
                            #data
                            tabItem(tabName = "Data",
                                    )
                        )))

