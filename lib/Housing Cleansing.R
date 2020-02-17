# Cleansing Housing Data
library(readr)
library(dplyr)
library(tidyr)
library(lubridate)
library(stringr)


# load data
house<-read_csv('../data/NYC_Citywide_Annualized_Calendar_Sales_Update.csv') 
housing<-house%>%filter(!`SALE PRICE`==0,BOROUGH==1,`TAX CLASS AT TIME OF SALE`%in%c(1,2))%>%
  select(`SALE PRICE`,`SALE DATE`,`BOROUGH`,`NEIGHBORHOOD`,
         `BUILDING CLASS CATEGORY`,`ADDRESS`,`ZIP CODE`,`Latitude`,`Longitude`,
         `RESIDENTIAL UNITS`,`COMMERCIAL UNITS`,`LAND SQUARE FEET`,`TAX CLASS AT TIME OF SALE`)%>%
  mutate(year=as.numeric(substr(`SALE DATE`,7,10)))%>%
  filter(year==2018,!`LAND SQUARE FEET`==0,!`SALE PRICE`<100)%>%
  mutate(`RESIDENTIAL UNITS`=ifelse(`RESIDENTIAL UNITS`==0&`COMMERCIAL UNITS`==0,1,`RESIDENTIAL UNITS`))

save(housing, file="../output/housing.RData")

load(file="../output/housing.RData")


salebyneighbor <- housing %>% group_by(NEIGHBORHOOD) %>% count()
