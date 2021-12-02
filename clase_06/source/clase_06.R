#===========================================#
# author: Eduard Fernando Martínez González
# update: 01-12-2021
# R version 4.1.1 (2021-08-10)
#===========================================#

# initial configuration
rm(list=ls()) # limpiar entorno
Sys.setlocale("LC_CTYPE", "en_US.UTF-8") # Encoding UTF-8

# load packages
require(pacman)
p_load(tidyverse,sf,raster,ggsn,leaflet) # llamar y/o instalar librerias

#================================#
# [4.] Importar datos espaciales #
#================================#

##------------------##
# Leer un shapefile

# read shape
points = st_read("clase_06/input/points_barranquilla.shp")
points
points %>% class() # get class

# geometry
points %>% st_crs() # get CRS

points %>% st_bbox() # get bbox

points %>% st_geometry() # get vertices

# attributes
points %>% colnames() # get column names

points$MPIO_CCDGO %>% table() # frequency table

##------------------##
# Convertir datos de formato sp a sf

# extraer datos
country = getData(name = 'GADM', country = 'HN', level = 2 , download = T , path = "clase_06/input/") 
class(country)

# de sp a sf
country_sf = st_as_sf(x = country)
class(country_sf)

# geometry
country_sf %>% st_crs() # get CRS

country_sf %>% st_bbox() # get bbox

country_sf %>% st_geometry() # get vertices

##------------------##
# CGeorreferenciar datos

# Georreferenciar Tegucigalpa
capital = st_as_sf(x = read.table(text="-87.1943302022471  14.07575421474368"),
                   coords = c(1,2) , crs = 4326)

# Georreferenciar Katrina
storms
storms_df = storms %>% subset(name=="Katrina")
storms_df %>% class()

# df to sf
katrina = st_as_sf(x = storms_df, coords = c("long" , "lat"), crs = 4326)
katrina %>% class()

# geometry
katrina %>% st_crs() # get CRS

katrina %>% st_bbox() # get bbox

katrina %>% st_geometry() # get vertices

#================================#
# [5.] Visualizar la información #
#================================#

# visualizar datos con leaflet
leaflet(data = points) %>% addCircleMarkers(color = "red")
leaflet(data = points) %>% addTiles() %>% addCircleMarkers(color = "red")

# visualizar datos con ggplot
ggplot() + geom_sf(data=points , col="red") + theme_bw()

# Varias capas
leaflet() %>% 
addTiles() %>% 
addCircleMarkers(data = katrina , color = "red") %>% 
addPolygons(data= country , color = "#444444", weight = 1, smoothFactor = 0.5,opacity = 1.0, fillOpacity = 0.5)

# visualizar datos con ggplot
ggplot() + 
geom_sf(data=country_sf , col="blue" , fill="gray" , alpha=0.1) + 
geom_sf(data=katrina , col="red") +
theme_bw()

##------------------##
# Making maps 

# plot basic map
ggplot() + geom_sf(data =  country_sf , col="red") + theme_bw()

p = ggplot() + geom_sf(data =  country_sf , col="black" , size=0.3) + theme_bw()
p

# Agregar el recorrido de Katrina
p = p + 
    geom_sf(data=katrina , col="red")
p

# make zoom
st_bbox(country_sf)
p = p + 
    coord_sf(xlim=c(-89.5,-82),ylim=c(17.5,12.5))
p

# add scalebar and north symbol
p = p + 
    north(data=country_sf , location="topright") + 
    scalebar(data=country_sf , dist=100 , dist_unit="km" , transform=T , model="WGS84" , location = "bottomleft")
p

# remove axis-labels
p = p + labs(x="",y="",title="Mapa de honduras")
p

# save plot
ggsave(plot=p , filename="clase_06/output/honduras_map.pdf" , width=8 , height=6)
  

