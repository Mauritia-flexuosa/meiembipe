
setwd("/home/marcio/Documentos/Doutorado/Meiembipe/")

library(rgdal)
library(sp)
library(tidyverse)
library(leaflet)

# Lê as coordenadas que o Mateus me passou.
revis <- readOGR(dsn = "/home/marcio/Documentos/Doutorado/Meiembipe", layer = "ma_uc", verbose = F, GDAL1_integer64_policy = F)

ne_revis <- subset(revis, revis$nm_uc %in% c(
  "MEIEMBIPE"
))


shapeRevis <- spTransform(ne_revis, CRS("+proj=longlat +ellps=GRS80"))

UC <- leaflet()  %>% addTiles() %>% 
#  setView(lng = -106.363590, lat=31.968483,zoom=11) %>% 
  addPolygons(data=shapeRevis,weight=2,col = 'red') %>%
  addProviderTiles('Esri.WorldImagery')
