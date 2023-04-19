library(sf)
library(leaflet)
library(raster)
library(rmapshaper)

source("scripts/utils.R")

# Layer 1: Salish Sea Region
boundary <- mx_read("spatial_data/vectors/boundary")

# Layer 2: Location
location <- mx_read("spatial_data/vectors/locations/ICO")

points.coordinates <- data.frame(st_coordinates(location))

location$X <- points.coordinates$X
location$Y <- points.coordinates$Y

# Set bounding box

bbox <- st_bbox(location) %>% as.vector()

# Render leaflet map

Map <- leaflet() %>%
  addTiles("https://{s}.basemaps.cartocdn.com/dark_nolabels/{z}/{x}/{y}{r}.png") %>%
  addPolygons(data = boundary, color = "blue", weight = 2, fillOpacity = 0, layerId = "mx_baseMap") %>%
  addCircleMarkers(data = points.coordinates, ~X, ~Y, label = paste(location$GEONAME),
                   fillColor = "#d5b43c",
                   fillOpacity = 1,
                   stroke = F,
                   radius = 3)  %>% 
  fitBounds(bbox[1], bbox[2], bbox[3], bbox[4])

print(Map)