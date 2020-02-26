library(geosphere)
library(tibble)
library(dplyr)
library(tidyr)
library(doParallel)

hous<-housing%>%na.omit()
noise<-compliance2019
h1<-hous[1:250,]
h2<-hous[251:500,]
h3<-hous[501:750,]
h4<-hous[751:1000,]
h5<-hous[1001:1250,]
h6<-hous[1251:1500,]
h7<-hous[1501:1750,]
h8<-hous[1751:2000,]
h9<-hous[2001:2250,]
h10<-hous[2251:2482,]
n<-nrow(h8)
m<-nrow(noise)

cl<-makeCluster(12)
registerDoParallel(cl)


output1<- foreach(j=1:m, .combine = "cbind", .packages = "geosphere") %dopar% {
  dist<-double(n)
  for (i in 1:n){
    dist[i]<-distHaversine(c(h1$Longitude[i],h1$Latitude[i]),
                           c(noise$Longitude[j],noise$Latitude[j]), r=6378137)
    
  }
  dist
}
colnames(output1)<-NULL
save(output1, file = "NoiseDist1.RData")
stopCluster(cl)


output2<- foreach(j=1:m, .combine = "cbind", .packages = "geosphere") %dopar% {
  dist<-double(n)
  for (i in 1:n){
    dist[i]<-distHaversine(c(h2$Longitude[i],h2$Latitude[i]),
                           c(noise$Longitude[j],noise$Latitude[j]), r=6378137)
    
  }
  dist
}
colnames(output2)<-NULL
save(output2, file = "NoiseDist2.RData")
stopCluster(cl)


output3<- foreach(j=1:m, .combine = "cbind", .packages = "geosphere") %dopar% {
  dist<-double(n)
  for (i in 1:n){
    dist[i]<-distHaversine(c(h3$Longitude[i],h3$Latitude[i]),
                           c(noise$Longitude[j],noise$Latitude[j]), r=6378137)
    
  }
  dist
}

colnames(output3)<-NULL
save(output3, file = "NoiseDist3.RData")
stopCluster(cl)


output4<- foreach(j=1:m, .combine = "cbind", .packages = "geosphere") %dopar% {
  dist<-double(n)
  for (i in 1:n){
    dist[i]<-distHaversine(c(h4$Longitude[i],h4$Latitude[i]),
                           c(noise$Longitude[j],noise$Latitude[j]), r=6378137)
    
  }
  dist
}

colnames(output4)<-NULL
save(output4, file = "NoiseDist4.RData")
stopCluster(cl)



output5<- foreach(j=1:m, .combine = "cbind", .packages = "geosphere") %dopar% {
  dist<-double(n)
  for (i in 1:n){
    dist[i]<-distHaversine(c(h5$Longitude[i],h5$Latitude[i]),
                           c(noise$Longitude[j],noise$Latitude[j]), r=6378137)
    
  }
  dist
}

colnames(output5)<-NULL
save(output5, file = "NoiseDist5.RData")
stopCluster(cl)



output6<- foreach(j=1:m, .combine = "cbind", .packages = "geosphere") %dopar% {
  dist<-double(n)
  for (i in 1:n){
    dist[i]<-distHaversine(c(h6$Longitude[i],h6$Latitude[i]),
                           c(noise$Longitude[j],noise$Latitude[j]), r=6378137)
    
  }
  dist
}

colnames(output6)<-NULL
save(output6, file = "NoiseDist6.RData")
stopCluster(cl)


output7<- foreach(j=1:m, .combine = "cbind", .packages = "geosphere") %dopar% {
  dist<-double(n)
  for (i in 1:n){
    dist[i]<-distHaversine(c(h7$Longitude[i],h7$Latitude[i]),
                           c(noise$Longitude[j],noise$Latitude[j]), r=6378137)
    
  }
  dist
}

colnames(output7)<-NULL
save(output7, file = "NoiseDist7.RData")
stopCluster(cl)

output8<- foreach(j=1:m, .combine = "cbind", .packages = "geosphere") %dopar% {
  dist<-double(n)
  for (i in 1:n){
    dist[i]<-distHaversine(c(h8$Longitude[i],h8$Latitude[i]),
                           c(noise$Longitude[j],noise$Latitude[j]), r=6378137)
    
  }
  dist
}

colnames(output8)<-NULL
save(output8, file = "NoiseDist8.RData")
stopCluster(cl)

output9<- foreach(j=1:m, .combine = "cbind", .packages = "geosphere") %dopar% {
  dist<-double(n)
  for (i in 1:n){
    dist[i]<-distHaversine(c(h9$Longitude[i],h9$Latitude[i]),
                           c(noise$Longitude[j],noise$Latitude[j]), r=6378137)
    
  }
  dist
}

colnames(output9)<-NULL
save(output9, file = "NoiseDist9.RData")
stopCluster(cl)




n10<-nrow(h10)
output10<- foreach(j=1:m, .combine = "cbind", .packages = "geosphere") %dopar% {
  dist<-double(n10)
  for (i in 1:n10){
    dist[i]<-distHaversine(c(h10$Longitude[i],h10$Latitude[i]),
                           c(noise$Longitude[j],noise$Latitude[j]), r=6378137)
    
  }
  dist
}

colnames(output10)<-NULL
save(output10, file = "NoiseDist10.RData")
stopCluster(cl)



