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



pal <- colorNumeric("#666699",c(0,1), na.color = "#808080" )

shinyServer(function(input, output,session) {
  
  ## Map Tab section
  hide("crime")
  hide("noise")
  output$map <- renderLeaflet({
    #the base of the map
    m <- leaflet() %>%
      addProviderTiles("CartoDB.Positron", 
                       options = providerTileOptions(noWrap = TRUE)) %>%
      setView(-73.96855,40.77876,zoom = 14)%>%
      addResetMapButton()
    
    #plot kids activities
    leafletProxy("map", data = bus) %>%
      addMarkers(~stop_lon, ~stop_lat,
                 group = "Bus Station",
                 popup = ~ paste0("<b>",stop_name,"</b>",
                                  "<br/>", "Stop ID: ", stop_id) ,
                 label = ~ stop_name ,
                 icon = list(iconUrl = 'https://cdn3.iconfinder.com/data/icons/unigrid-phantom-vehicles-vol-4-3/60/001_183_bus_school_transport-512.png',
                             iconSize = c(10,10)))
    
    leafletProxy("map", data = subway_new) %>%
      addMarkers(~longitude, ~latitude ,
                 group = "Subway Station",
                 popup = ~ paste0("<b>",NAME,"</b>",
                                  "<br/>", "Number of Lines: ", count,
                                  "<br/>", "Notes: ", NOTES),  
                 label = ~ NAME,
                 icon = list(iconUrl = 'https://cdn4.iconfinder.com/data/icons/travel-filled-outline-3/64/transport-train-railway-public-transportation-subway-256.png',
                             iconSize = c(20,20)))
    leafletProxy("map") %>% hideGroup("Bus Station")
    m
  })
    #enable/disable markers of specific group
    observeEvent(input$enable_markers, {
      if("Bus Station" %in% input$enable_markers) leafletProxy("map") %>% showGroup("Bus Station")
      else{leafletProxy("map") %>% hideGroup("Bus Station")}
      if("Subway Station" %in% input$enable_markers) leafletProxy("map") %>% showGroup("Subway Station")
      else{leafletProxy("map") %>% hideGroup("Subway Station")}
      }, ignoreNULL = FALSE)
    
    #show the statistics of the right of mainpanel
    observeEvent(input$map_click, {
      #if(!input$click_multi) 
      leafletProxy("map") %>% clearGroup(c("circles","centroids",color))
      click <- input$map_click
      clat <- click$lat
      clong <- click$lng
      radius <- input$click_radius
      
      #output info
      output$click_coord <- renderText(paste("Latitude:",round(clat,4),", Longitude:",round(clong,4)))
      
      #Subset to draw thestatistics
      housing_within_range   <- housing[distCosine(c(clong,clat),housing[,c("Longitude","Latitude")]) <= radius,]
      crime_within_range     <- crime_mahattan_geo_info[distCosine(c(clong,clat),crime_mahattan_geo_info[,c("Longitude","Latitude")]) <= radius,]
      noise_within_range     <- compliance2019[distCosine(c(clong,clat),compliance2019[,c("Longitude","Latitude")]) <= input$click_radius,]
      park_within_range      <- park_new[(distCosine(c(clong,clat),park_new[,c("Longitude_average","Latitude_average")])-park_new[,c("radius")]) <= radius,]
      restaurant_within_range<- restaurant[distCosine(c(clong,clat),restaurant[,c("Longitude","Latitude")]) <= radius,]
      retail_within_range    <- retail[distCosine(c(clong,clat),retail[,c("Longitude","Latitude")]) <= radius,]
      school_within_range    <- school[distCosine(c(clong,clat),school[,c("Longitude","Latitude")]) <= radius,]
      
      #average price
      {if(nrow(housing_within_range)!=0){
      average_price <- mean(housing_within_range$`SALE PRICE`/housing_within_range$`LAND SQUARE FEET`)
      }
      else average_price<-0}
      
      if(average_price == 0){
        output$click_avg_price_red <- renderText("No Historical Data")
        output$click_avg_price_green <- renderText({})
        output$click_avg_price_orange <- renderText({})
      }
      else if(average_price>quantile[2]){
        output$click_avg_price_red <- renderText(average_price)
        output$click_avg_price_green <- renderText({})
        output$click_avg_price_orange <- renderText({})
      }
      else if(average_price<quantile[1]){
        output$click_avg_price_green <- renderText(average_price)
        output$click_avg_price_red <- renderText({})
        output$click_avg_price_orange <- renderText({})
      }
      else{
        output$click_avg_price_orange <- renderText(average_price)
        output$click_avg_price_green <- renderText({})
        output$click_avg_price_red <- renderText({})
      }
      
      #draw the circle when click
      leafletProxy('map') %>%
        addCircles(lng = clong, lat = clat, group = 'circles',
                   stroke = TRUE, radius = radius,popup = paste("AVERAGE PRICE: ", average_price, sep = ""),
                   color = 'black', weight = 1
                   ,fillOpacity = 0.5)%>%
        addCircles(lng = clong, lat = clat, group = 'centroids', radius = 1, weight = 2,
                   color = 'black',fillColor = 'black',fillOpacity = 1)
      
      leafletProxy('map', data = housing_within_range) %>%
        addCircles(~Longitude,~Latitude, group = ~COLOR, stroke = F,
                   radius = 12, fillOpacity = 0.8,fillColor=~COLOR)
      
      #tables
      output$crime <- renderPlotly({
        ds <- table(crime_within_range$Crime_type)
        type<-names(ds)
        ds[is.na(ds)] <- 0
        #ds <- data.frame(ds)
        #names(ds) <- c("Type", "Frequency")
        plot_ly(labels=type, values=ds, type = "pie") %>%
          layout(title = "Crime Nearby",showlegend=F,
                 xaxis=list(showgrid=F,zeroline=F,showline=F,autotick=T,ticks='',showticklabels=F),
                 yaxis=list(showgrid=F,zeroline=F,showline=F,autotick=T,ticks='',showticklabels=F))
        
      })
      
      output$noise <- renderPlotly({
        ds <- table(noise_within_range$`Complaint Type`)
        type<-names(ds)
        ds[is.na(ds)] <- 0
        #ds <- data.frame(ds)
        #names(ds) <- c("Type", "Frequency")
        plot_ly(labels=type, values=ds, type = "pie") %>%
          layout(title = "Noise Nearby",showlegend=F,
                 xaxis=list(showgrid=F,zeroline=F,showline=F,autotick=T,ticks='',showticklabels=F),
                 yaxis=list(showgrid=F,zeroline=F,showline=F,autotick=T,ticks='',showticklabels=F))
        
      })
      
      if(nrow(park_within_range)!=0){
        park<-head(park_within_range%>%
                     mutate("DISTANCE" = distCosine(c(clong,clat),park_within_range[,c("Longitude_average","Latitude_average")])-park_within_range[,"radius"])%>%
                     arrange(DISTANCE)%>%
                     select(NAME,ACRES,TYPECATEGO,LOCATION),3)
        output$park<-renderTable(park)
      }
      else output$park<-renderTable(park_na)
      
      if(nrow(restaurant_within_range)!=0){
      restaurant<-head(restaurant_within_range%>%
                         mutate("DISTANCE" = distCosine(c(clong,clat),restaurant_within_range[,c("Longitude","Latitude")]))%>%
                         arrange(DISTANCE)%>%
                         select(NAME,GRADE,`CUISINE DESCRIPTION`,DISTANCE),5)
      output$restaurant<-renderTable(restaurant)
      }
      else output$restaurant<-renderTable(restaurant_na)
    
      if(nrow(retail_within_range)!=0){
      Retail<-head(retail_within_range%>%
                     mutate("DISTANCE" = distCosine(c(clong,clat),retail_within_range[,c("Longitude","Latitude")]))%>%
                     arrange(DISTANCE)%>%
                     select(NAME,SIZE,DISTANCE),5)
      output$retail<-renderTable(Retail)
      }
      else output$retail<-renderTable(retail_na)
     
      if(nrow(school_within_range)!=0){
        school<-head(school_within_range%>%
                       mutate("DISTANCE" = distCosine(c(clong,clat),school_within_range[,c("Longitude","Latitude")]))%>%
                       arrange(DISTANCE)%>%
                       select(CATEGORY,ADDRESS,DISTANCE),5)
        output$school<-renderTable(school)
      }
      else output$school<-renderTable(school_na)
      
      hide("park")
      
      #hide the tables
      hide("park")
      hide("restaurant")
      hide("retail")
      hide("school")
      observeEvent(input$click_neighbourhood, {
        if("Crime" %in% input$click_neighbourhood) show("crime")
        else hide("crime")
        if("Noise" %in% input$click_neighbourhood) show("noise")
        else hide("noise")
        if("Park" %in% input$click_neighbourhood) show("park")
        else hide("park")
        if("Restaurant" %in% input$click_neighbourhood) show("restaurant")
        else hide("restaurant")
        if("Retail" %in% input$click_neighbourhood) show("retail")
        else hide("retail")
        if("School" %in% input$click_neighbourhood) show("school")
        else hide("school")
      },ignoreNULL = FALSE) 
      
      
  })
})

