<<<<<<< HEAD


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
=======
library(shiny)
library(leaflet)
library(data.table)
library(plotly)
library(shinythemes)
library(shinyWidgets)
library(googleVis)
library(geosphere)
library(leaflet.extras)
library(ggmap)



shinyUI(
  div(id="house",
      
      navbarPage(strong("Manhattan House Finder",style="color: white;"), 
                 theme=shinytheme("flatly"),
                 #theme = "bootstrap.min.css",
                 #theme="styles.css",
                 
                 tabPanel("Intro",
                          
                          mainPanel(width=12,
                                    setBackgroundImage(
                                      src = "../background_1.jpg"
                                    ),
                                    
                                    style = "color: white",
                                    
                                      h2("Are Children Safe During After-school Activities?"),
                                      h3("News:"),
                                      h3("Dulce Maria Alavez, A 5-Year-Old Girl Went Missing From a Playground in New Jersey"),
                                      p("Dulce went missing on the afternoon of Sept. 
                                      16 while her mother in the car with the 8-year-old son, roughly 30 yards away. The mother is still seeking 
                                      for information about her daughter two weeks after the girl is believed to have been abducted from a local park."),
                                      p(em(a("New York Times",href="https://www.nytimes.com/2019/10/01/nyregion/missing-child-nj-dulce-alavez.html"))),
                                    
                                    h2("Are Children Safe During After-school Activities?"),
                                    p("Diego, a boy who was critically injured last week after being sucker-punched at school 
                                      in an assault captured on video died Tuesday night. Diego appears to hit his head on a concrete.He died after sending 
                                      to the hospital in a extremely critical condition.
                                      "),
                                    p(em(a("Los Angeles Times",href="https://www.latimes.com/california/story/2019-09-25/boy-sucker-punched-moreno-valley-school-dies-from-injuries"))),
                                    
                                    h2("Are Children Safe During After-school Activities?"),
                                    p("Developing an App that relates the crimes related to kids or teenagers with places where children spend the most, for instance, after-school activities spots. Inspired by how the Amber Alarm works, We want to develop visualization and give children warnings of certain areas even before they are in danger.
                                      "),
                                    p(),
                                    p(em(a("Github link",href="https://github.com/TZstatsADS/fall2019-proj2--sec2-grp8"))),
                                    div(class="footer", "Group Project by Lihao Xiao, Dingyi Fang, Mo Yang, Thomson Batidzirai, Sixuan Li")
                 )),
                 
                 tabPanel("Map",
                          div(class="outer",
                              leafletOutput("map",width="100%",height=700),
                              
                              
                              absolutePanel(id = "control", class = "panel panel-default", fixed = TRUE, draggable = TRUE,
                                            top = 170, left = 20, right = "auto", bottom = "auto", width = 250, height = "auto",
                                            
                                            ##Possible to change to subway station and bus station
                                            checkboxGroupInput("enable_markers", "Traffic:",
                                                               choices = c("Bus Station","Subway Station"),
                                                               selected = c("Subway Station")),

                                            checkboxGroupInput("click_neighbourhood", "Neighbourhood",
                                                               choices =c("Crime","Noise","Park","Restaurant","Retail","School"), selected =c("Crime","Noise", "Park","Restaurant","Retail","School")),
                                            actionButton("click_all_crime_types", "Select ALL"),
                                            actionButton("click_none_crime_types", "Select NONE"),
                                            
                                            sliderInput("click_radius", "Radius of area around  the selected address", min=50, max=500, value=250, step=10),
                                            
                                            style = "opacity: 0.80"
                                            ),
                              
                              #the panel on the right to show the statistics
                              absolutePanel(id = "Statistics", class = "panel panel-default", fixed= TRUE, draggable = TRUE,
                                            top = 70, left = "auto", right = 20, bottom = "auto", width = 320, height = "auto",
                                            h3("Summary of Chosen Area"),
                                            
                                            br(),
                                            h4("The Geographical Information"),
                                            p(textOutput("click_coord")),
                                            
                                            br(),
                                            h4("Average House Price"),
                                            p(strong(textOutput("click_avg_price_red", inline = T))),
                                            tags$head(tags$style("#click_avg_price_red{color: red;
                                            font-size: 20px;
                                            font-style: italic;
                                            }"
                                            )
                                            ),
                                            p(strong(textOutput("click_avg_price_orange", inline = T))),
                                            tags$head(tags$style("#click_avg_price_orange{color: orange;
                                            font-size: 20px;
                                            font-style: italic;
                                            }"
                                            )
                                            ),
                                            p(strong(textOutput("click_avg_price_green", inline = T))),
                                            tags$head(tags$style("#click_avg_price_green{color: green;
                                            font-size: 20px;
                                                                 font-style: italic;
                                                                 }"
                                            )
                                            ),
                                            
                                            br(),
                                            h4("Restaurant Nearby"),
                                            div(tableOutput("restaurant"), style = "font-size:45%")
                              )
                              )        
                        )
                 
      )
  )
)
>>>>>>> 23f1dab2720615b756878fc5090e4214bef2412e

