#===========================================#
# author: Eduard Fernando Martínez González
# update: 11-11-2021
# R version 4.1.1 (2021-08-10)
#===========================================#

# initial configuration
rm(list=ls()) # limpiar entorno
Sys.setlocale("LC_CTYPE", "en_US.UTF-8") # Encoding UTF-8
set.seed(12345) # fijar semilla

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

#----------------------#
## Estructura de datos
dev.off()
grid.raster(readPNG("pics/bucle_flow.png")) # source: datacamp

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


cat("El loop se aplica desde la columna 2 (porque la columna 1 contiene el código DANE) 
    hasta la última columna del dataframe.")

for(i in 2:ncol(df)){
    df[,i] <- df[,i]*100
}
df

#----------------------#
## usando controles de flujo: if & else

cat("los controles de flujo regulan la ejecucion de los codigos dentro de los diferentes tipos de loops")

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
cat("next es un condicional que le permite al loop saltar al siguiente elemento del loop")

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
## Funciones
dev.off()
grid.raster(readPNG("pics/function_machine.png")) # source: https://fhernanb.github.io

#----------------------#
## Veamos un ejemplo (...)
cat("message, warnings & errors indican diferentes niveles de mensajes. 
     *message: informa resultados... etc. 
     *warnings: informa algun tipo de error o anuncio importante que no impide el funcionamiento del programa.
     *error: indicador sobre el funcionamiento correcto de la funcion.")
  
unir = function(x, y){
       palabra = paste(x ,y) %>% toupper()
       message(paste("las combinacion de las palabras producen:", palabra))
}
unir(x = "hola", y = "clase")

#----------------------#
## Veamos un ejemplo (...)
remove_na = function(x) x = ifelse(is.na(x),0,x)

vector = c(1:5,rep(NA,5),11:15)

vector
vector = remove_na(vector)
vector

storms %>% head()
df = storms %>% as_tibble() %>% mutate(ts_diameter=remove_na(ts_diameter))
df %>% head()

#----------------------#
## Veamos un ejemplo (...)
join_words = function(x, y){
             palabra = paste(x ,y) %>% toupper()
             return(palabra)
}
join_words(x = "hola", y = "mundo")

#----------------------#
## Veamos un ejemplo (...)
cat("funcion que regresa el producto de un numero por si mismo")
num_2 = function(x){
        c = x*x
return(c)
}
num_2(x = 4)
num_2(x = "A")

# incluir controles de flujo
num_2 = function(numero){
  
        # si es un numero
        if (is.numeric(numero)){
            c = numero*numero
        return(c)
        }
        
        # si no es un numero
        if (is.numeric(numero)==F){
            warning(paste0(numero," no es un número"))
        }
}
num_2(numero = 10)
num_2(numero = "hola")
num_2(numero = "10")

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

#=========================#
#==== Aplicación: chip ===#
#=========================#
rm(list=ls()) # limpiamos entorno

#----------------------#
## Chip
browseURL("https://www.chip.gov.co/schip_rt/index.jsf")

ejemplo = import("clase_05/input/chip/2019/11767600044K212410-1220191625694914330.xls", skip = 7)
ejemplo

#----------------------#
## Importar datos
list_chip = import_list(file = list.files("clase_05/input/chip",full.names=T, recursive = TRUE) %>% unlist())
names(list_chip) 

#----------------------#
## Funcion para extraer
list_chip
f_extrac = function(n,lista,tipo_rubro){
  
           # crear df
           df = data.frame(valor=NA,cod_dane=NA,periodo=NA)  
           lista_n = lista[[n]] 
          
           # extraer codigo dane
           df$cod_dane = colnames(lista_n)[1]
          
           # extraer periodo
           df$periodo = lista_n[2,1]
          
           # extraer el valor
           colnames(lista_n) = lista_n[7,]
           df$valor = lista_n %>% subset(NOMBRE==tipo_rubro) %>% select(`PAGOS(Pesos)`)
          
return(df)  
}
f_extrac(n = 10 , lista = list_chip , tipo_rubro = "SALUD")

#======================#
#=== Ejemplo: GEIH ====#
#======================#
rm(list=ls()) # limpiamos entorno

#### lista de los achivos 
files_meses = list.files("clase_05/input/geih",full.names = T, recursive = TRUE) %>% unlist()

#### recordando la funcion grep
grep("Caract" ,files_meses)
files_meses[c(1,9,17,25,30,35)]
files_meses[grep("Caract" ,files_meses)]

#----------------------#
## Funcion para extraer datos
f_read = function(x, patron){
lapply(x[grep(patron ,x)], function(y){
                           year = substr(y,22,25)  # substraer los elementos en la posición 12-15 (YEAR)
                           rural = substr(y,37,41) 
                              
                           data = import(file = y) %>% 
                                  rename_with(tolower) %>%  # se importa la base de datos
                                  mutate(year = year, # se anexa el year
                                  rural = case_when(rural == "Resto" ~ 1, rural != "Resto" ~ 0)) # se anexa si es rural
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




  
  