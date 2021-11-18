# author: Eduard F. Martínez-González
# update: 11-11-2021
# R version 4.1.1 (2021-08-10)

# initial configuration
rm(list=ls()) # limpiar entorno
Sys.setlocale("LC_CTYPE", "en_US.UTF-8") # Encoding UTF-8

# install/load packages
require(pacman)
p_load(tidyverse,rio,skimr,data.table,viridis,ggthemes,png,grid)

## Hoy veremos

### ***1.*** Aplicación GEIH: Importar, exportar 

### ***2.*** group_by() y summarize()

### ***3.*** Visualizaciones


#=====================#
#1.Importemos la GEIH #
#=====================#

## importar los archivos 
cat("Vectores con las rutas de los archivos")

jun_2019 = list.files("clase_04/input/2019/Junio.csv",full.names=T)
jun_2020 = list.files("clase_04/input/2020/Junio.csv",full.names=T)
files = c(jun_2019,jun_2020)

# función grep()
grep("rea -",files)
files[grep("rea -",files)]
files = files[grep("rea -",files)]

#-------------------#
## importar datos

#### Importar caracteristicas generales 
cg = import_list(file = files[grep("Cara",files)]) 

#### Importar ocupados
ocu = import_list(file = files[grep("Ocu",files)])

#### Importamos base de desocupados
deso = import_list(file = files[grep("Deso",files)])

#### Importamos la base de inactivos 
inac =  import_list(file = files[grep("Inac",files)])

#### Importamos la base de fuerza de trabajo
ft = import_list(file = files[grep("Fuerza",files)])

#-----------------------#
## limpiar variables
source("clase_04/source/clean_data.R") # ejecutar un código auxiliar

#-----------------------#
## función rbindlist()
cat("rbind permite unir los elementos de una listas (agregar observaciones)")

cg_bind = rbindlist(l=cg, use.names = TRUE, fill = TRUE)

ocu_bind = rbindlist(l=ocu,use.names = TRUE,fill = TRUE)

deso_bind = rbindlist(l=deso,use.names = TRUE,fill = TRUE)

inac_bind = rbindlist(l=inac,use.names = TRUE,fill = TRUE)

ft_bind = rbindlist(l=ft,use.names = TRUE,fill=TRUE)
 
#--------------------------#
#### gaih completa
cat("unir bases de datos (agregar variables)")

geih = left_join(x = cg_bind, y = ft_bind, by = c("secuencia_p","directorio","orden")) %>% 
       left_join(x = ., y = inac_bind, by = c("secuencia_p","directorio","orden")) %>% 
       left_join(x = ., y = ocu_bind, by = c("secuencia_p","directorio","orden")) %>% 
       left_join(x = ., y = deso_bind, by = c("secuencia_p","directorio","orden")) %>% as_tibble()

# limpiar entorno
grep("geih",ls())
ls()[grep("geih",ls())]
rm(list=ls()[-grep("geih",ls())])

#=============================#
# 2. Collapsar bases de datos #
#=============================#

# inspeccionar conjunto de datos
skim(geih)

# limpiar el factor de expansion
geih$fex_c_2011 = gsub(",","\\.",geih$fex_c_2011) %>% as.numeric()

geih = geih %>%
       mutate(inac = ifelse(is.na(inac),0,1),
              ocu = ifelse(is.na(ocu),0,1),
              deso = ifelse(is.na(deso),0,1),
              fuerza = ifelse(is.na(fuerza),0,1))

#-------------------------#
## summarise 

#### Media
mean(geih$p6500, na.rm = T)
geih %>% summarise(media = mean(p6500, na.rm = TRUE)) 

#### Mediana
median(geih$p6500, na.rm = TRUE)
geih %>% summarise(media = mean(p6500, na.rm = T) ,
                   mediana = median(p6500, na.rm = T)) 

#### frecuencia
table(geih$p6020) 
geih %>% summarise(total = table(p6020)) 

#### Quartiles
quantile(geih$p6500, na.rm = TRUE)
geih %>% summarise(quartiles = quantile(p6500, na.rm = TRUE)) 


#-------------------------#
# group_by() + summarise() 
desocupados = geih  %>% group_by(p6020, year) %>% subset(deso==1) %>% summarise(total_desempleados = sum(fex_c_2011))

p_activa = geih  %>% group_by(year, p6020) %>% subset(deso == 1 | ocu == 1) %>% summarise(total_activa = sum(fex_c_2011))

#-------------------------------------#
# group_by() + mutate() + summarize 
t_des = desocupados %>% left_join(., p_activa, by = c("p6020", "year")) %>% 
                        mutate(p6020 = case_when(p6020== 1 ~ "hombre",
                                                 p6020== 2 ~ "mujer"),
                               unemployment = total_desempleados/total_activa*100)


#====================#
# 3. Visualizaciones #
#====================#

cat("ggplot funciona por medio de capas y se usa el signo + para adiccionar un atributo al gráfico")
ggplot(t_des) 

#### pintamos sobre la primera capa
ggplot() + geom_bar(data = t_des) 

#### pintamos sobre la segunda capa
ggplot(data = t_des, aes(x = unemployment, y = as.factor(year))) + 
geom_bar(position="dodge", stat="identity") 

#### para mantener cambiar los ejes
ggplot(data = t_des, aes(x = unemployment, y = as.factor(year))) + 
geom_bar(position="dodge", stat="identity") + coord_flip()

#### podemos incluir colores
ggplot(data = t_des, aes(x = unemployment, y = as.factor(year), fill = as.factor(p6020))) + 
geom_bar(position="dodge", stat="identity") + coord_flip()


#================#
# ggplot:advance #

cat("para simplificar pondremos este código lo pondremos dentro de una variable de tal manera que cuando llamemos a la variable nos de la gráfica")

graph_1 = ggplot(data = t_des, aes(x = unemployment, y = as.factor(year), fill = as.factor(p6020))) + 
                 geom_bar(position="dodge", stat="identity") + coord_flip()
graph_1

#----------------------------#
## scale colour
cat("se puede definir los colores en uso manual mente un por una scala de color") 

#### scale_fill_manual
graph_1 + scale_fill_manual(values  = c("blue", "green"))


#### scale_fill_brewer
graph_2 = graph_1 + scale_fill_brewer(palette = "Blues") # reescribimos variable para simplificar

graph_2

#----------------------------#
## agregar temas 
cat("hay temas predeterminados que se pueden usar")

graph_2 + theme_solarized(light = FALSE) # Tema solarized
graph_3 = graph_2 + theme_few() # Tema few

#----------------------------#
## precaucion
cat("WANING!!!! recuerde que ggplot funcion por capas, capas nuevas puedes eliminar capas anteriores.")
graph_2 + theme_pander() + scale_fill_pander() # Tema few


#----------------------------#
## Labels
graph_4 = graph_3 + labs(title = "Tasa de Desempleo por Sexo", 
                         subtitle = "2019/2020 (junio)",
                         caption = "Fuente: GEIH, calculo de autores",
                         y = "Año", 
                         x = "Tasa de desempleo %", 
                         fill = "Sexo")
graph_4







