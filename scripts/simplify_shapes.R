# Script for simplifying Shapes for Salish Sea Community Atlas data visualization

# Note: careful not to rerun this script over the same polygon as it may degrade polygon geometry

# Load libraries 

library(sf)
library(rmapshaper)

# Load dependencies

source("scripts/utils.R")

# Read original shape

location <- mx_read("spatial_data/vectors/locations/Galiano_Island")

# Simplify shape

location <- rmapshaper::ms_simplify(input = as(location, 'Spatial')) %>%
  st_as_sf()

# Export simplified shape
# Note: cannot set path for writing new layer; by default writes to root directory

st_write(location, dsn = "Galiano_Island.shp", layer = "Galiano_Island.shp", driver = "ESRI Shapefile")