#load packages for HIEv data
.libPaths("C:/Users/90946112/R/win-library/3.6.2")
library(tidyverse)
library(sf)
library(raster)
library(tmap)


extent = st_read("bmtn_wollemi_tiles.gpkg")

dplyr::filter(ccodes(), NAME %in% "Australia")
poly = getData("GADM", country = "AUS", level = 1)

tmap_mode("view")
qtm(extent, fill = "point_density",
    borders = NULL)

high_density = extent[extent$point_density > 2,]
qtm(high_density, fill = "point_density",
    borders = NULL)

tot_area = sum(extent$area)/1000
