library(sf)
library(tidyverse)
library(mapview)
library(rgeos)

gons<-read_csv(file.choose())
gons1<-gons %>%
  select(c(dataset,lon_westbound,lon_eastbound,lat_southbound,lat_northbound)) %>% 
  glimpse()

gons2<-gons1[,c(1,2,4)]
gons3<-gons1[,c(1,3,5)]
names(gons2)<-c("dataset","lon","lat")
names(gons3)<-c("dataset","lon","lat")
gons4<-rbind(gons2,gons3)

gons5<-gons4 %>% 
  group_by(dataset) %>%
  expand(lat,lon) %>%
  arrange(dataset,lat,lon) %>% 
  ungroup()

gons_names<-c(unique(gons5$dataset))
gons_list<-list()
polygon<- gons5[c(1,2,4,3),] %>%
  st_as_sf(coords = c("lon", "lat"), crs = 4326) %>%
  summarise(geometry = st_combine(geometry)) %>%
  st_cast("POLYGON")
gons_list[1]<-polygon
names(gons_list)[1]<-gons_names[1]
# assign(paste(gons5$dataset[1]),polygon)
for(i in c(1:41)){
  a<-c(1,2,4,3)+i*4
  polygon<- gons5[a,] %>%
    st_as_sf(coords = c("lon", "lat"), crs = 4326) %>%
    summarise(geometry = st_combine(geometry)) %>%
    st_cast("POLYGON")
  gons_list[i+1]<-polygon
  names(gons_list)[i+1]<-gons_names[i+1]
}

gons_all<-st_union(gons_list[[1]],gons_list[[2]])
for(i in gons_list){
  gons_all<-st_union(gons_all,i)
}

# pts = st_centroid(gons_all,byid=TRUE)
# pts <- st_transform(gons_list, 4326) %>% 
#   st_centroid()
#   mapview(pts)

map_aus<-st_read("aust_cd66states.shp")
a<-mapview(gons_all,col.regions="blue")
mapshot(a,file="lidarplots.png")
