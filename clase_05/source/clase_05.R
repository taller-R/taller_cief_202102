#===========================================#
# author: Eduard Fernando Martínez González
# update: 11-11-2021
# R version 4.1.1 (2021-08-10)
#===========================================#

# initial configuration
rm(list=ls()) # limpiar entorno
Sys.setlocale("LC_CTYPE", "en_US.UTF-8") # Encoding UTF-8

# load packages
require(pacman)
p_load(tidyverse, rio, data.table, png, grid)

## Hoy veremos

### **1.** Bucles

### **2.** Funciones

### **3.** Familia apply


#======================#
#======= Bucles =======#         
#======================#
browseURL(url = "https://intro2r.com/loops.html#for-loop", browser = getOption("browser")) # loops
browseURL(url = "https://mauricioanderson.com/curso-r-estructuras-control/", browser = getOption("browser")) # controles de flujo

#----------------------#
## Estructura de datos
dev.off()
grid.raster(readPNG("pics/bucle_flow.png")) 

# source
browseURL(url = "http://community.datacamp.com.s3.amazonaws.com/community/production/ckeditor_assets/pictures/132/content_flowchart1.png")

#----------------------#
## Estructura de un bucle (for)
vector =  1:5

for (i in vector){ # Vector sobre el que se va a aplicar el loop
  i = i*i  # Sobreescribe i como el resultado de i*i
  print(i) # Pinta el resultado sobre la consola
}

#----------------------#
## Estructura de un bucle (repeat)
repeat{
  m = rnorm(n=1 , mean=10 , sd=2) # generar un número aleatorio (media 10 , sd 2) 
  print(m) # pintar el número sobre la consola
  if (m <= 8){ # condicionar a que ese número sea menor o igual a 8
    break # detener el loop si m es menor o igual a 8 
  } 
}

#----------------------#
## Estructura de un bucle (while)
j = 1

while (j <= 5) { # condición
  print(j*j) # pintar sobre la consola el producto de j*j
  j = j+1 # sobreescribir j como j + 1
}

#----------------------#
## Veamos un ejemplo

#### generate data
df = data.frame(cod_mpio = c(5001,5002,5003,5004,5005,5006),	
                violencia_2014	= c(0.05,0.07,0.06,0.03,0.04,0.03),
                violencia_2015	= c(0.09,0.05,0.03,0.06,0.03,0.01),
                violencia_2016	= c(0.02,0.04,0.03,0.02,0.03,0.00),
                violencia_2017	= c(0.03,0.06,0.03,0.01,0.04,0.01),
                violencia_2018	= c(0.01,0.02,0.04,0.05,0.07,0.01),
                violencia_2019  = c(0.01,0.02,0.02,0.03,0.03,0.01))
set.seed(12345)

cat("El loop se aplica desde la columna 2 (porque la columna 1 contiene el código DANE) 
    hasta la última columna del dataframe.")

for(i in 2:ncol(df)){
  df[,i] <- df[,i]*100
}

df

#----------------------#
## usando controles de flujo: if & else

cat("los controles de flujo controlan la ejecucion de los codigos dentro de los diferentes tipos de loops")

for (letra in letters) {
  if (letra %in% c("a","e","i","o","u")){
    print(paste(letra," - Es una vocal"))
  }
  else {
    print(paste(letra," - NO es una vocal")) 
  } 
}


#----------------------#
## Usando next
cat("next es un condicional que indicar al llop que debe saltar a la siguiente linea")

for(i in 1:20) {
  if(i %% 2 == 0) next # se salta a la siguiente linea
  print(i)
}


#======================#
#====== Funciones =====#
#======================#
browseURL(url = "https://fhernanb.github.io/Manual-de-R/creafun.html", browser = getOption("browser")) # partes de una función
browseURL(url = "https://es.r4ds.hadley.nz/funciones.html", browser = getOption("browser")) # cuando se debería escribir una función
browseURL(url = "https://www.r-bloggers.com/2016/02/functions-exercises/", browser = getOption("browser")) # ejercicios extras
browseURL(url = "https://adv-r.hadley.nz/conditions.html", browser = getOption("browser")) # errors, messages and warnings

#----------------------#
## Veamos un ejemplo (...)

cat("message, warnings & errors indican diferentes niveles de mensajes. 
      *message: informa resultados... etc. 
      *warnings: informa algun tipo de error o anuncio importante que no impide el funcionamiento del programa.
      *error: indicador sobre el funcionamiento correcto de la funcion.
    ")
  
unir = function(x, y){
  palabra = paste(x ,y) %>% toupper()
  
  message(paste("las combinacion de las palabras producen:", palabra))
}
unir(x = "hola", y = "clase")


#----------------------#
## ejemplo con loop (...)
vocales = function(frase) {
          finaly = list()
          
          for (i in 1:nchar(frase)) { 
            letra = substr(frase,i,i) %>% tolower()
            
            if(letra %in% c("a","e","i","o","u")){
              finaly[i] = letra}
            
            if(letra %in% c(" ")){
              warning("la frase contiene espacios vacios")}}
          
          finaly = finaly %>% unlist() %>% unique()
          return(finaly)
}
vocales(frase = "hola clase")


#======================#
#=== Familia apply ====#
#======================#

#### Apply, Lapply & Sapply 
dev.off()
grid.raster(readPNG("pics/familia_apply.png"))

#----------------------#
## Apply
dev.off()
grid.raster(readPNG("pics/apply.png"))

####  Operaciones por columnas
apply(X = mtcars, MARGIN = 2, function(x) min(x)) 

####  Operaciones por filas
apply(X = mtcars, MARGIN = 1, function(x)  print(x[8:11]))

#----------------------#
## Lapply
dev.off()
grid.raster(readPNG("pics/lapply.png"))

lap = lapply(mtcars, function(x) summary(x))
lap

#----------------------#
## Sapply
dev.off()
grid.raster(readPNG("pics/sapply.png"))

sap = sapply(mtcars, summary)
sap


#======================#
#=== Ejemplo: GEIH ====#
#======================#
rm(list=ls()) # limpiamos entorno

## Ejemplo: importar la GEIH
cat("se usa list. files para importar todos los archivos de la geih & 
    recursive para indicar que entre dentro de todas las carpetas dentro de archivo")

#### lista de los achivos 
files_meses = list.files("clase_05/input/geih/",full.names = T, recursive = TRUE) %>% unlist()

#### funcion grep
cat("grep encuentra todas la locacion dentro de un vector en el cual se encuetra el argumento que buscamos")
grep("Caract" ,files_meses)

cat("se puede llamar un elemento dentro del vector por su numero")
files_meses[c(1,9,17,25,30,35)]
files_meses[grep("Caract" ,files_meses)]

#----------------------#
## Funcion para extraer datos
  
f_read = function(x, patron){
  
lapply(x[grep(patron ,x)], function(y){
                              year = substr(y,22,25)  # substraer los elementos en la posición 12-15 (YEAR)
                              rural = substr(y,37,41) 
                              
                              data = import(file = y) %>% rename_with(tolower) %>%  # se importa la base de datos
                                                          mutate(year = year, # se anexa el year
                                                                 rural = case_when(rural == "Resto" ~ 1, 
                                                                                   rural != "Resto" ~ 0)) # se anexa si es rural
  }) %>% rbindlist(use.names = TRUE, fill = TRUE) %>% as_tibble() # se juntan las bases de datos
}

#----------------------#
## importar y selecionar datos de interes
c_gen = f_read(files_meses, patron = "Caract") %>% select("secuencia_p", "directorio","orden","esc","dpto","year","rural","fex_c_2011","p6020","p6040")
ocu = f_read(files_meses, patron = "Ocu") %>% mutate(ocu = 1) %>% select("secuencia_p", "directorio","orden","ocu","p6500")
des = f_read(files_meses, patron = "Des") %>% mutate(deso = 1) %>% select("secuencia_p", "directorio","orden","deso")
ina = f_read(files_meses, patron = "Ina") %>% mutate(inac = 1) %>% select("secuencia_p" ,"directorio","orden","inac")
ftr = f_read(files_meses, patron = "Fue") %>% mutate(fuerza = 1) %>% select("secuencia_p", "directorio","orden","fuerza")

#### se une la geih
geih = left_join(x = c_gen, y = ocu, by = c("secuencia_p","directorio","orden")) %>% 
  left_join(x = ., y = des, by = c("secuencia_p","directorio","orden")) %>% 
  left_join(x = ., y = ina, by = c("secuencia_p","directorio","orden")) %>% 
  left_join(x = ., y = ftr, by = c("secuencia_p","directorio","orden")) 

geih


#======================#
#==== Ejemplo: chip ===#
#======================#
rm(list=ls()) # limpiamos entorno

#----------------------#
## ship
  
cat(" CHIP contiene información financiera, relacionada con la contabilidad, tesorería y presupuesto de las entidades estatales; 
    igualmente, los estados financieros de cada una de las entidades públicas que realizan su reporte al CHIP y los informes de control interno contable")

ejemplo = import("clase_05/input/chip/2019/11767600044K212410-1220191625694914330.xls", skip = 7)
ejemplo

#----------------------#
## Importar datos
list_chip = import_list(file = list.files("clase_05/input/chip/",full.names=T, recursive = TRUE) %>% unlist())

names(list_chip) 

#----------------------#
## grep & paste
cat("paste con collapse, permite poner un | == (o) entre las palabras")
paste(c("TOTAL INVERSIÓN","DEPORTE Y RECREACIÓN"), collapse="|")

grep(paste(c("TOTAL INVERSIÓN","DEPORTE Y RECREACIÓN"), collapse="|"), ejemplo[,2]) #posición donde se encuentran las palabras

ejemplo[grep(paste(c("TOTAL INVERSIÓN","DEPORTE Y RECREACIÓN"), collapse="|"), ejemplo[,2]),c(2,4:8)] # filas donde se encuentran las palabras

#----------------------#
## Funcion para extraer datos
f_extrac = function(lista,tipo_rubro){
  
  n =lapply(lista, function(y){ # lapply para repetir la funcion en cada elmento
    
                              fecha = y[2,1] # extraer la fecha
                              lugar = colnames(y)[1] # extraer el lugar
    
    y = y[grep(paste(tipo_rubro, collapse="|"), y[,2]),c(2,4:8)] %>% mutate(fecha = fecha, lugar = lugar) # extraer datos numericos
          
    return(y)
  }) %>% rbindlist(use.names = TRUE) 
  
  colnames(n) = c("nombre", "presupuesto_inicial","presupuesto_definitivo","compromisos","total_obligaciones","PAGOS", "fecha", "lugar") 
  n 
}

resultados = f_extrac(list_chip, tipo_rubro = c("TOTAL INVERSIÓN","DEPORTE Y RECREACIÓN"))

  
  