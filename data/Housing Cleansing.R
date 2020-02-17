# Cleansing Housing Data
library(readr)
library(dplyr)
library(tidyr)

# load data
house<-read_csv('../data/NYC_Citywide_Annualized_Calendar_Sales_Update.csv') 
housing<-house%>%filter(!`SALE PRICE`==0)%>%
  select(`SALE PRICE`,`SALE DATE`,`BOROUGH`,`NEIGHBORHOOD`,
         `BUILDING CLASS CATEGORY`,`ADDRESS`,`Latitude`,`Longitude`,
         `RESIDENTIAL UNITS`,`COMMERCIAL UNITS`,`TOTAL UNITS`,`LAND SQUARE FEET`,
         `GROSS SQUARE FEET`)

save(housing, file="../output/housing.RData")
