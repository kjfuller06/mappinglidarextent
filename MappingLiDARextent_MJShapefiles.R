library(sf)
library(mapview)

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

a<-st_union(LiDAR1,by_feature=FALSE)
a<-st_transform(a,crs=28356)
b<-st_union(LiDAR2,by_feature=FALSE)
b<-st_transform(b,crs=28356)
c<-st_union(LiDAR3,by_feature=FALSE)

d<-st_union(a,b,by_feature=FALSE)
d<-st_union(d,c,by_feature=FALSE)

expo<-mapview(d, alpha=0)

mapshot(expo,file="lidarplots.png")

e<-as_Spatial(d)
gArea(e)/1000000
