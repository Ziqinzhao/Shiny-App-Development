library(readr)
library(lubridate)
library(dplyr)
library(tidyr)
library(stringr)

compliance<-read_csv('../data/311compliance.csv')
compliance2019<-compliance%>%mutate(year=substr(`Created Date`,7,10))%>%
  filter(year=="2019",`Borough`=="MANHATTAN",!Agency%in%c("HPD","DOB"),
         grepl("Noise",`Complaint Type`),!`Incident Address`=="INTERSECTION")%>%
  select(year,`Complaint Type`,`Incident Zip`,`Incident Address`,Latitude,Longitude)%>%
  na.omit()

save(compliance2019,file="../output/noise.RData")
load(file="../output/noise.RData")
