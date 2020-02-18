
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
                                    ),
                            
                            #details
                            tabItem(tabName = "Details",
                                    ),
                            
                            #prediction and recommendation
                            tabItem(tabName = "Prediction and Recommendation",
                                    ),
                            
                            #data
                            tabItem(tabName = "Data",
                                    )
                        )))

