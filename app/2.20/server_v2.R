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
install.packages("pracma")
library(pracma)

location_range<-function(lng,lat,distance=0.5){
  earthRadius=6378.137    # unit: km
  d_lng=2*asin(sin(distance/(2*earthRadius))/cos(deg2rad(lat)))
  d_lng=rad2deg(d_lng)
  d_lat=distance/earthRadius
  d_lat=rad2deg(d_lat)
  return(c(lat-d_lat,    # start of latitude
           lat+d_lat,
           lng-d_lng,    # start of longtitude
           lng+d_lng))
}


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
<<<<<<< HEAD
      },ignoreNULL = FALSE) ,
=======
      },ignoreNULL = FALSE) 
      
>>>>>>> e8f2fb41d35ac34367e951a644e3dcbf8f2b236e
      
      ## Evaluation
    observeEvent(c(input$caption,input$range,input$prange),{
      # obtaining the longitude and latitude of the address input
      range<-location_range(geocode(paste(input$caption,", New York"),source="google")$lon,
                            geocode(paste(input$caption,", New York"),source="google")$lat)
      output$score<-renderTable({
      # school
      school_score<-unlist(school%>%
            filter(Latitude>range[1],Latitude<range[2],Longitude>range[3],Longitude<range[4])%>%
            count())[[1]]
      school_rank<-ceiling(100*min(which(sort(c(houseallinfo_neighbor$`SCHOOL NEARBY`,school_score),
                                      decreasing = TRUE)
                         ==school_score))/nrow(houseallinfo_neighbor))
      
      # park
      park_score<-unlist(park_new%>%
            filter(Latitude_average>range[1],Latitude_average<range[2],Longitude_average>range[3],Longitude_average<range[4])%>%
            count())[[1]]
      park_rank<-ceiling(100*min(which(sort(c(houseallinfo_neighbor$`PARK NEARBY`,park_score),
                                            decreasing = TRUE)
                                       ==park_score))/nrow(houseallinfo_neighbor))
      
      # subway
      subway_score<-unlist(subway_new%>%
            filter(latitude>range[1],latitude<range[2],longitude>range[3],longitude<range[4])%>%
            summarize(n=sum(count)))[[1]]
      subway_rank<-ceiling(100*min(which(sort(c(houseallinfo_neighbor$`SUBWAY NEARBY`,subway_score),
                                          decreasing = TRUE)
                                     ==subway_score))/nrow(houseallinfo_neighbor))
      
      # bus
      bus_score<-unlist(bus%>%
            filter(stop_lat>range[1],stop_lat<range[2],stop_lon>range[3],stop_lon<range[4])%>%
            count())[[1]]
      bus_rank<-ceiling(100*min(which(sort(c(houseallinfo_neighbor$`BUS NEARBY`,bus_score),
                                            decreasing = TRUE)
                                       ==bus_score))/nrow(houseallinfo_neighbor))
      
      # restaurant
      res_score<-unlist(restaurant%>%
            filter(Latitude>range[1],Latitude<range[2],Longitude>range[3],Longitude<range[4])%>%
            mutate(GRADE=case_when(GRADE=="A" ~ 1,
                                   GRADE=="B" ~ 0.6,
                                   GRADE=="C" ~ 0.2))%>%
           summarize(n=sum(GRADE)))[[1]]
      res_rank<-ceiling(100*min(which(sort(c(houseallinfo_neighbor$`RESTAURANT NEARBY`,res_score),
                                         decreasing = TRUE)
                                    ==res_score))/nrow(houseallinfo_neighbor))
      
      # retail
      retail_score<-unlist(retail%>%
           mutate(Latitude=as.numeric(Latitude),
                  Longitude=as.numeric(Longitude))%>%
           filter(Latitude>range[1],Latitude<range[2],Longitude>range[3],Longitude<range[4])%>%                 
           mutate(SCORE=case_when(Size=="Large" ~ 1,
                                  Size=="Medium" ~ 0.5,
                                  Size=="Small" ~ 0.1))%>%  
           summarize(n=sum(SCORE)))[[1]]
      retail_rank<-ceiling(100*min(which(sort(c(houseallinfo_neighbor$`RETAIL NEARBY`,retail_score),
                                         decreasing = TRUE)
                                    ==retail_score))/nrow(houseallinfo_neighbor))
      
      # crime
      crime_score<-unlist(crime%>%
           filter(Latitude>range[1],Latitude<range[2],Longitude>range[3],Longitude<range[4])%>%
           count())[[1]]
      crime_rank<-ceiling(100*min(which(sort(c(houseallinfo_neighbor$`CRIME NEARBY`,crime_score))
                                       ==crime_score))/nrow(houseallinfo_neighbor))
      
      # noise
      noise_score<-unlist(compliance2019%>%
           filter(Latitude>range[1],Latitude<range[2],Longitude>range[3],Longitude<range[4])%>%
           count())[[1]]
      noise_rank<-ceiling(100*min(which(sort(c(houseallinfo_neighbor$`NOISE NEARBY`,noise_score))
                                      ==noise_score))/nrow(houseallinfo_neighbor))
      
      # evaluate the 8 indexes aroud the address (radius=800m)
      score<-tibble(Type=c("Score","Rank(%)"),
                    School=c(school_score,school_rank),
                    Park=c(park_score,park_rank),
                    Subway=c(subway_score,subway_rank),
                    Bus=c(bus_score,bus_rank),
                    Restaurant=c(res_score,res_rank),
                    Retail=c(retail_score,retail_rank),
                    Crime=c(crime_score,crime_rank),
                    Noise=c(noise_score,noise_rank))
      score})
      output$near<-renderDataTable({
        # it's a filter on the nearest houses arranged by score
        interval<-c(input$range)
        prange<-c(input$prange)
        house_sub<-houseallinfo_neighbor%>%
          filter(Latitude>range[1],Latitude<range[2],Longitude>range[3],Longitude<range[4],
                 `LAND SQUARE FEET`>=interval[1],`LAND SQUARE FEET`<=interval[2],
                 `SALE PRICE`>=prange[1],`SALE PRICE`<=prange[2])%>%
          arrange(desc(as.numeric(total)))%>%
          select(ADDRESS,`SALE PRICE`,`SALE DATE`,`LAND SQUARE FEET`,`Rank(%)`,`SCHOOL NEARBY`,`PARK NEARBY`,`SUBWAY NEARBY`,`BUS NEARBY`,`RESTAURANT NEARBY`,`RETAIL NEARBY`,`CRIME NEARBY`,`NOISE NEARBY`)%>%
          head(5)
        house_sub
      })
      output$like<-renderDataTable({
        # the houses with similar living indexes
        interval<-c(input$range)
        prange<-c(input$prange)
        house_subset<-houseallinfo_neighbor%>%
          filter(`LAND SQUARE FEET`>=interval[1],`LAND SQUARE FEET`<=interval[2],
                 `SALE PRICE`>=prange[1],`SALE PRICE`<=prange[2])%>%
          mutate(school=as.numeric((`SCHOOL NEARBY`-as.numeric(score[1,2]))^2),
                 park=as.numeric((`PARK NEARBY`-as.numeric(score[1,3]))^2),
                 subway=as.numeric((`SUBWAY NEARBY`-as.numeric(score[1,4]))^2),
                 bus=as.numeric((`BUS NEARBY`/2-as.numeric(score[1,5])/2)^2),
                 resturant=as.numeric((`RESTAURANT NEARBY`/10-as.numeric(score[1,6])/10)^2),
                 retail=as.numeric((`RETAIL NEARBY`-as.numeric(score[1,7]))^2),
                 crime=as.numeric((`CRIME NEARBY`/4-as.numeric(score[1,8])/4)^2),
                 noise=as.numeric((`NOISE NEARBY`/200-as.numeric(score[1,9])/200)^2))%>%
          mutate(a=school+park+subway+bus+resturant+retail+crime+noise)%>%
          arrange(a)%>%
          select(ADDRESS,`SALE PRICE`,`SALE DATE`,`LAND SQUARE FEET`,`Rank(%)`,`SCHOOL NEARBY`,`PARK NEARBY`,`SUBWAY NEARBY`,`BUS NEARBY`,`RESTAURANT NEARBY`,`RETAIL NEARBY`,`CRIME NEARBY`,`NOISE NEARBY`)%>%
          head(5)
        house_subset
      })
      output$potential<-renderDataTable({
        house_potential<-houseallinfo_neighbor%>%
          filter(`LAND SQUARE FEET`>=interval[1],`SALE PRICE`<=prange[1])%>%
          mutate(school=scale(`SCHOOL NEARBY`),
                 park=scale(`PARK NEARBY`),
                 subway=scale(`SUBWAY NEARBY`),
                 bus=scale(`BUS NEARBY`),
                 restaurant=scale(`RESTAURANT NEARBY`),
                 retail=scale(`RETAIL NEARBY`),
                 crime=scale(`CRIME NEARBY`),
                 noise=scale(`NOISE NEARBY`))%>%
          mutate(total=school+park+subway+bus+restaurant+retail-crime-noise)%>%
          arrange(desc(as.numeric(total)))%>%
          select(ADDRESS,`SALE PRICE`,`SALE DATE`,`LAND SQUARE FEET`,`Rank(%)`,`SCHOOL NEARBY`,`PARK NEARBY`,`SUBWAY NEARBY`,`BUS NEARBY`,`RESTAURANT NEARBY`,`RETAIL NEARBY`,`CRIME NEARBY`,`NOISE NEARBY`)%>%
          head(20)
        house_potential
      })
    })
      
      
  })
})

