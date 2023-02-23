library(sf)
library(leaflet)
library(raster)
library(rmapshaper)

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
location <- mx_read("spatial_data/vectors/locations/Salish_Sea")

location <- rmapshaper::ms_simplify(input = as(location, 'Spatial')) %>%
  st_as_sf()

bbox <- st_bbox(location) %>% as.vector()

# Create raster palette

pal <- colorNumeric(c("#0C2C84", "#41B6C4", "#FFFFCC"), values(SS_DSM),
                    na.color = "transparent")

# Render leaflet map

# Don't output raster again to avoid bloating output

Map <- leaflet() %>%
  addTiles("https://{s}.basemaps.cartocdn.com/dark_nolabels/{z}/{x}/{y}{r}.png") %>%
#  addRasterImage(SS_DSM, colors = pal, opacity = 0.8) %>% 
  addPolygons(data = boundary, color = "blue", weight = 2, fillOpacity = 0, layerId = "mx_baseMap") %>%
  addPolygons(data = islands, color = "blue", weight = 1, fillOpacity = 0, layerId = "mx_baseMap") %>%
  addPolygons(data = location, color = "yellow", weight = 2, fillOpacity = 0, options = list(mx_locationId = "Salish_Sea")) %>%
  fitBounds(bbox[1], bbox[2], bbox[3], bbox[4])
  
print(Map)
