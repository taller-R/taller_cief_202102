# author: Eduard F. Martínez-González
# update: 11-11-2021
# R version 4.1.1 (2021-08-10)

# initial configuration
rm(list=ls()) # limpiar entorno
Sys.setlocale("LC_CTYPE", "en_US.UTF-8") # Encoding UTF-8

# install/load packages
require(pacman)
p_load(tidyverse,rio,skimr,png,grid,data.table,viridis,ggthemes)

## Hoy veremos

### ***1.*** Aplicación GEIH: Importar, exportar 

### ***2.*** group_by() y summarize()♥

### ***3.*** ggplot()


#=====================#
#1.Importemos la GEIH #
#=====================#

## importar los archivos 

cat("Vectores eje de las rutas de los archivos")

jun_2019 = list.files("clase_04/input/2019/Junio.csv",full.names=T)
jun_2020 = list.files("clase_04/input/2020/Junio.csv",full.names=T)
files = c(jun_2019,jun_2020)

cat("Filtramos para quedarnos con solo datos de areas metropolitanas")

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


#---------------------------#
## agregamos variables
cat("Agregamos la variable años y una variable identificadora")

#### Caracteristicas Generales
cg[[1]]$year=2019
cg[[2]]$year=2020

#### Ocupados
ocu[[1]]$ocu=1
ocu[[2]]$ocu=1

#### Desocupados
deso[[1]]$deso=1
deso[[2]]$deso=2

#### Inactivos 
inac[[1]]$inac=1
inac[[2]]$inac=1

#### Fuerza de Trabajo
ft[[1]]$fuerza=1
ft[[2]]$fuerza=1

#--------------------------#
## Variables en minusculas
cat("se convierte los nombres a minusculas")

#### Caracteristicas Generales
colnames(cg[[1]]) = tolower(colnames(cg[[1]]))
colnames(cg[[2]]) = tolower(colnames(cg[[2]]))

#### Ocupados
colnames(ocu[[1]]) = tolower(colnames(ocu[[1]]))
colnames(ocu[[2]]) = tolower(colnames(ocu[[2]]))

#### Desocupados 
colnames(deso[[1]]) = tolower(colnames(deso[[1]]))
colnames(deso[[2]]) = tolower(colnames(deso[[2]]))

#### Inactivos
colnames(inac[[1]]) =tolower(colnames(inac[[1]]))
colnames(inac[[2]]) = tolower(colnames(inac[[2]]))

#### Fuerza de Trabajo 
colnames(ft[[1]])=tolower(colnames(ft[[1]]))
colnames(ft[[2]])=tolower(colnames(ft[[2]]))


#-----------------------#
## rbindlist 
cat("rbind permite pegar las listas por medio de sus nombres")

cg_ready<- rbindlist(l=cg, use.names = TRUE, fill = TRUE)

ocu_ready <- rbindlist(l=ocu,use.names = TRUE,fill = TRUE)

deso_ready <- rbindlist(l=deso,use.names = TRUE,fill = TRUE)

inac_ready = rbindlist(l=inac,use.names = TRUE,fill = TRUE)

ft_ready = rbindlist(l=ft,use.names = TRUE,fill=TRUE)


#--------------------------#
## Simpificacion

cat("para simplificar importaremos selecionaremos variables en las cuales hay un interes.")

cg_ready = cg_ready %>% select("secuencia_p", "directorio","orden","esc","dpto","year","fex_c_2011","p6020")

ocu_ready = ocu_ready %>% select("secuencia_p", "directorio","orden","ocu")

deso_ready = deso_ready %>% select("secuencia_p", "directorio","orden","deso")

inac_ready = inac_ready %>% select("secuencia_p" ,"directorio","orden","inac")

ft_ready = ft_ready %>% select("secuencia_p", "directorio","orden","fuerza")


#--------------------------#
#### gaih completa
cat("left_join, culmina este trabajo permitiendo pegar horizontalmente")

geih = left_join(x = cg_ready, y = ft_ready, by = c("secuencia_p","directorio","orden")) %>% 
  left_join(x = ., y = inac_ready, by = c("secuencia_p","directorio","orden")) %>% 
  left_join(x = ., y = ocu_ready, by = c("secuencia_p","directorio","orden")) %>% 
  left_join(x = ., y = deso_ready, by = c("secuencia_p","directorio","orden")) %>% as_tibble()

# limpiemos parte del entorno
rm(cg,cg_ready,deso,deso_ready,ft,ft_ready,inac,inac_ready,ocu,ocu_ready,files,jun_2019,jun_2020)


#==========================#
# 2. limpiar base de datos #
#==========================#
# limpiar el factor de expansion
geih$fex_c_2011 = gsub(",","\\.",geih$fex_c_2011) %>% as.numeric()

geih = geih %>%
  mutate(inac = ifelse(is.na(inac),0,1),
         ocu = ifelse(is.na(ocu),0,1),
         deso = ifelse(is.na(deso),0,1),
         fuerza = ifelse(is.na(fuerza),0,1))

#-------------------------#
## summarise 
cat("crea una nueva data.frame en el cual se encuenta los resultados de diferentes operaciones")

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


#========#
# ggplot #
#========#
cat("ggplot funciona por medio de capas cada + es una capa diferente")
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







