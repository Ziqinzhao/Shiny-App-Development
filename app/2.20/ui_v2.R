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
library(shinyjs)


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
                                            
                                            useShinyjs(),
                                            ##Possible to change to subway station and bus station
                                            checkboxGroupInput("enable_markers", "Traffic:",
                                                               choices = c("Bus Station","Subway Station"),
                                                               selected = c("Subway Station")),

                                            checkboxGroupInput("click_neighbourhood", "Neighbourhood",
                                                               choices =c("Crime","Noise","Park","Restaurant","Retail","School"), selected =c()),
                                            
                                            sliderInput("click_radius", "Radius of area around  the selected address", min=50, max=500, value=250, step=10),
                                            
                                            style = "opacity: 0.80"
                                            ),
                              
                              #the panel on the right to show the statistics
                              absolutePanel(id = "Statistics", class = "panel panel-default", fixed= TRUE, draggable = TRUE,
                                            top = 90, left = "auto", right = 20, bottom = "auto", width = 320, height = "auto",
                                            style = "overflow-y:scroll;height:500px;max-height:550px",
                                           
                                            useShinyjs(),
                                            
                                            h3("Summary of Chosen Area"),
                                            
                                            h4("The Geographical Information"),
                                            p(textOutput("click_coord")),

                                            h4("Average House Price/Square Feet"),
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
                                            div(p(">1221.48 (3rd quantile);"),style = "color:red;font-size:12px"),
                                            div(p("<70.92 (1st quantile);"),style = "color:green;font-size:12px"),
                                            
                                            h4("Crime Nearby"),
                                            plotlyOutput("crime"),
                                            
                                            h4("Noise Nearby"),
                                            plotlyOutput("noise"),
                                            
                                            h4("Parks Nearby"),
                                            div(tableOutput("park"), style = "font-size:60%"),
                                            
                                            h4("Restaurants Nearby"),
                                            div(tableOutput("restaurant"), style = "font-size:60%"),
                                        
                                            h4("Retails Nearby"),
                                            div(tableOutput("retail"), style = "font-size:60%"),
                                            
                                            h4("Schools Nearby"),
                                            div(tableOutput("school"), style = "font-size:60%")
                              )
                              )        
                        ),
                 tabPanel("Evaluation",
                          fluidPage(
                            fluidRow(
                            column(5,textInput("caption", "Search Google Maps", "50W 97th Street",width=600)),
                            column(3,sliderInput("range", "Preferred Foot Square:",min = 436, max = 149560, value = c(40000,100000))),
                            column(3,sliderInput("prange", "Price Interval:",min = 2500, max = 416100000, value = c(100000000,300000000)))
                             ),
                            h3("Index Evaluation:"),
                            tableOutput("score"),
                            h3("Similiar Houses:"),
                            dataTableOutput("like"),
                            h3("Nearest High Score Houses:"),
                            dataTableOutput("near"),
                            h3("Potential Houses:"),
                            dataTableOutput("potential")
                                  )
                         )
                 
      )
  )
)


