library(sf)
library(leaflet)
library(raster)
library(rmapshaper)

source("scripts/utils.R")

# Layer 1: Salish Sea Region
boundary <- mx_read("spatial_data/vectors/boundary")

# Layer 2: Salish Sea Islands and Mainland
islands <- mx_read("spatial_data/vectors/islands")

# Layer 3: Location
location <- mx_read("spatial_data/vectors/locations/GINPR")

# Set bounding box

bbox <- st_bbox(location) %>% as.vector()

# Render leaflet map

Map <- leaflet() %>%
  addTiles("https://{s}.basemaps.cartocdn.com/dark_nolabels/{z}/{x}/{y}{r}.png") %>%
  addPolygons(data = boundary, color = "blue", weight = 2, fillOpacity = 0, layerId = "mx_baseMap") %>%
  addPolygons(data = islands, color = "blue", weight = 1, fillOpacity = 0, layerId = "mx_baseMap") %>%
  addPolygons(data = location, color = "yellow", weight = 2, fillOpacity = 0, options = list(mx_locationId = "Howe_Sound")) %>%
  fitBounds(bbox[1], bbox[2], bbox[3], bbox[4])

print(Map)