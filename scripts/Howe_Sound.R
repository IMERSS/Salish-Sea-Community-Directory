library(sf)
library(leaflet)
library(raster)

source("scripts/utils.R")

# Layer 1: Salish Sea DSM
SS_DSM <- raster("spatial_data/rasters/SS_DEM_200x200.tif")

# Layer 2: Salish Sea Region
boundary <- mx_read("spatial_data/vectors/boundary")

# Layer 3: Salish Sea Islands and Mainland
islands <- mx_read("spatial_data/vectors/islands")

# Layer 4: Location
location <- mx_read("spatial_data/vectors/locations/Howe_Sound")

#Render leaflet map

#Create palette
# pal <- colorNumeric(
# palette = "Blues",
# domain = SS_DSM$values)

Map <- leaflet() %>%
  addTiles(options = providerTileOptions(opacity = 0.5)) %>%
  addRasterImage(SS_DSM, opacity = 0.8) %>% 
  addPolygons(data = boundary, color = "blue", weight = 2, fillOpacity = 0) %>%
  addPolygons(data = islands, color = "blue", weight = 1, fillOpacity = 0) %>%
  addPolygons(data = location, color = "red", weight = 2, fillOpacity = 0) %>%

print(Map)