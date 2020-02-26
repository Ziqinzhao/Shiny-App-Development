
packages.used=c("shiny","leaflet", "data.table","plotly","shinythemes","shinyWidgets","googleVis","geosphere","leaflet.extras","leaflet.extras","ggmap",
                "d3heatmap","shinyjs","readr","DT","pracma","dplyr","tidyr")
packages.needed=setdiff(packages.used,
                        intersect(installed.packages()[,1],
                                  packages.used))

if(length(packages.needed)>0){
  install.packages(packages.needed, dependencies = TRUE)
}




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
library(d3heatmap)
library(shinyjs)
library(readr)
library(DT)
library(pracma)
library(dplyr)
library(tidyr)


load("../output/Data_v2.RData")
load("../output/houseallinfo_neighbor.RData")
load("../output/indextypeUpdate.RData")
load("../output/statistics.RData")


