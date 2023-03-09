# Script for simplifying Shapes for Salish Sea Community Atlas data visualization

# Note: careful not to rerun this script over the same polygon as it may degrade polygon geometry

# Load libraries 

library(sf)
library(rmapshaper)

# Load dependencies

source("scripts/utils.R")

# Read original shape

location <- mx_read("spatial_data/vectors/locations/Salish_Sea")

# Simplify shape

location <- rmapshaper::ms_simplify(input = as(location, 'Spatial')) %>%
  st_as_sf()

# Write shape

st_write(location, dsn = "Salish_Sea.shp", layer = "spatial_data/vectors/locations/Salish_Sea/Salish_Sea.shp", driver = "ESRI Shapefile")