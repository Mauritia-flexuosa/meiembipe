# Mapa da ReViS Meiembipe com Zona de Amortecimento e pontos de referência
# Desenvolvido por Marcio Baldissera Cure
# Atualizado em 05/03/2023

setwd("/home/mcure/Documents/meiembipe/meiembipe_limites")

dsn <- "/home/mcure/Documents/meiembipe/meiembipe_limites"

library(rgdal)
library(sp)
library(tidyverse)
library(leaflet)
library(leaflet.extras)
library(rgeos)

# Lê o shape file que contém os limites das unidades de conservação de Florianópolis
revis <- readOGR(dsn = dsn, layer = "ma_uc", verbose = F, GDAL1_integer64_policy = F)

# Separa apenas a ReViS Meiembipe
ne_revis <- subset(revis, revis$nm_uc %in% c(
  "MEIEMBIPE"
))

# Transforma as coordenadas para latitude e longitude
shapeRevis <- spTransform(ne_revis, CRS("+proj=longlat +ellps=GRS80"))

# Cria o shape com a zona de amortecimento (ZA)
za <- gBuffer(shapeRevis, width = 0.0003, byid = TRUE, quadsegs = 2)

# Coordenadas da Cachoeira do ponto 16
lon <- -48.46367913
lat <- -27.54353368

# Coordenadas do Engenho
lat1 <- -27.5657798
lon1<- -48.463697

# Labels e informações para cada um dos marcadores.
label <- "Cachoeira do 16"
cachu <- paste0("<b>Engenho do ponto 8</b>", "</br><img width='60%', src = 'http://static.ndmais.com.br/2016/11/cropped/29aba30080aef98036711f783f2d8d79470c5186.jpg'>",
                " </br>Fonte da imagem: https://ndmais.com.br/noticias/costa-da-lagoa-uma-heranca-colonial-esta-ameacada/","</br>",
                "</br><b>Visite a Costa da Lagoa!</b>")

label1 <- "Engenho do ponto 8"
engenho <-  paste0("<b>Cachoeira do ponto 16</b>", "</br><img width='60%', src = 'https://trilhasconectam.com.br/wp-content/uploads/2018/03/trilha-costa-da-lagoa-canto-dos-aracas-floripa13.jpg'>",
                   " </br>Fonte da imagem: https://trilhasconectam.com.br/trilha-costa-da-lagoa/trilhasconectam/","</br>",
                   "</br><b>Visite a Costa da Lagoa!</b>")

# Combina as informações para os dois pontos de referência
pontos <- data.frame(cachu, engenho)  
labels <- data.frame(label, label1)
lons <- c(lon, lon1)
lats <- c(lat, lat1)

# Adiciona perfumarias
mydrawPolylineOptions <- function(allowIntersection = TRUE, 
                                   drawError = list(color = "#b00b00", timeout = 2500), 
                                   guidelineDistance = 20, metric = TRUE, feet = FALSE, zIndexOffset = 2000, 
                                   shapeOptions = drawShapeOptions(fill = FALSE), repeatMode = FALSE) {
  leaflet::filterNULL(list(allowIntersection = allowIntersection, 
                           drawError = drawError, guidelineDistance = guidelineDistance, 
                           metric = metric, feet = feet, zIndexOffset = zIndexOffset,
                           shapeOptions = shapeOptions,  repeatMode = repeatMode)) }

# Gera o mapa interativo com as informações
UC <- leaflet()  %>% addTiles() %>% 
#  setView(lng = -106.363590, lat=31.968483,zoom=11) %>% 
  addPolygons(data=za,weight=2,col = 'blue') %>%
    addPolygons(data=shapeRevis,weight=2,col = 'red') %>%
    addProviderTiles('Esri.WorldImagery') %>% 
    addScaleBar(position = "topright") %>% 
    addDrawToolbar(
      polylineOptions = mydrawPolylineOptions(metric=TRUE, feet=FALSE),
      editOptions=editToolbarOptions(selectedPathOptions=selectedPathOptions()))%>% 
    addCircles(lng=lons, lat=lats) %>%
    addMarkers(lons,lats,popup = c(engenho, cachu), label = labels)