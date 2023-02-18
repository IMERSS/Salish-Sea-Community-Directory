library(sf)
library(leaflet)
library(raster)

source("scripts/utils.R")

# Layer 1: Salish Sea DSM
SS_DSM <- raster("spatial_data/rasters/SS_DEM_200x200.tif")

# Convert floating point to integers
dataType(SS_DSM)="INT4S"

SS_DSM <- round(SS_DSM)

# Layer 2: Salish Sea Region
boundary <- mx_read("spatial_data/vectors/boundary")

# Layer 3: Salish Sea Islands and Mainland
islands <- mx_read("spatial_data/vectors/islands")

# Layer 4: Location
location <- mx_read("spatial_data/vectors/locations/Howe_Sound")

# Create raster palette

pal <- colorNumeric(c("#0C2C84", "#41B6C4", "#FFFFCC"), values(SS_DSM),
                    na.color = "transparent")

# Render leaflet map

Map <- leaflet() %>%
  addTiles(options = providerTileOptions(opacity = 0.5)) %>%
  addRasterImage(SS_DSM, colors =pal, opacity = 0.8) %>% 
  addPolygons(data = boundary, color = "blue", weight = 2, fillOpacity = 0) %>%
  addPolygons(data = islands, color = "blue", weight = 1, fillOpacity = 0) %>%
  addPolygons(data = location, color = "yellow", weight = 2, fillOpacity = 0) %>%

print(Map)