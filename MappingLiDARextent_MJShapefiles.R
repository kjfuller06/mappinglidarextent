library(sf)
library(mapview)
library(tidyverse)

#coordinate reference systems grabbed from Spatial Services website, it's also the naming system for the "zones"- using just the last two digits of the CRS
LiDAR1 <- st_read(
  "zone54_s3_tiles.shp")
st_crs(LiDAR1)<-28354
LiDAR2 <- st_read(
  "zone55_s3_tiles.shp")
st_crs(LiDAR2)<-28355
LiDAR3 <- st_read(
  "zone56_s3_tiles.shp")
st_crs(LiDAR3)<-28356

a<-st_transform(LiDAR1,crs=28356)
b<-st_transform(LiDAR2,crs=28356)

LiDAR1<-LiDAR1 %>% 
  group_by(year) %>%
  summarise(geometry = sf::st_union(geometry)) %>%
  ungroup() 
  # st_cast("MULTIPOLYGON")
LiDAR2<-LiDAR2 %>% 
  group_by(year) %>%
  summarise(geometry = sf::st_union(geometry)) %>%
  ungroup()
  # st_cast("MULTIPOLYGON")
LiDAR3<-LiDAR3 %>% 
  group_by(year) %>%
  summarise(geometry = sf::st_union(geometry)) %>%
  ungroup()
  # st_cast("MULTIPOLYGON")

# a<-st_union(LiDAR1,by_feature=TRUE)
# d<-st_union(a,b,by_feature=FALSE)
# d<-st_union(d,c,by_feature=FALSE)

expo<-mapview(list(LiDAR1,LiDAR2,LiDAR3),col.regions= rainbow, at = c(2009:2018), alpha=0, legend =FALSE)
expo



mapshot(expo,file="lidarplots2.png")

e<-as_Spatial(d)
gArea(e)/1000000
