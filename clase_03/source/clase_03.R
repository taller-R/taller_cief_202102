# author: Eduard F. Martínez-González
# update: 11-11-2021
# R version 4.1.1 (2021-08-10)

# initial configuration
rm(list=ls()) # limpiar entorno
Sys.setlocale("LC_CTYPE", "en_US.UTF-8") # Encoding UTF-8

# install/load packages
require(pacman)
p_load(janitor,rio,skimr,png,grid)

## Hoy veremos

### **1.** Introducción

### **2.** Importar/exportar

### **3.** Generar variables

### **4.** Pipe (%>%)

### **5.** Remover filas y/o columnas

### **6.** Combinar conjuntos de datos

### **7.** Pivotear conjuntos de datos

#=================#
# 1. Introducción #
#=================#


#------------------------------#
## Raw data y tidy data
cat("Tidy datasets are all alike, but every messy dataset is messy in its own way. -Hadley Wickham")
dev.off()
grid.raster(readPNG("pics/raw_tidy.png"))


#------------------------------#
## Reglas de un conjunto de datos tidy
dev.off()
grid.raster(readPNG("pics/tidy_rules.png"))


#------------------------------#
## tidyverse
dev.off()
grid.raster(readPNG("pics/tidy_monster.png"))
browseURL("https://github.com/allisonhorst/stats-illustrations") # source


#------------------------------#
## tidyverse (cont.)
cat("Antes de continuar, debe instalar y llamar la librería `tidyverse` así:")
install.packages("tidyverse")
library(tidyverse)
cat("Para ver los conflictos entre nombres de funciones en `tidyverse` con nombre de funciones en otras librerías, puede escribir sobre la consola `tidyverse_conflicts()`")

#------------------------------#
## Cheat sheet
dev.off()
grid.raster(readPNG("pics/cheat_sheet_dplyr.png"))

cat("Puede encontrar una hoja de trucos para cada librería en la siguiente linea")
browseURL("https://www.rstudio.com/resources/cheatsheets/")
vignette("dplyr")
vignette("tibble")


#==================================#
# Importar/exportar bases de datos #
#==================================#

## Librería `rio` 
dev.off()
grid.raster(readPNG("pics/import-export.png"))

cat("`rio` es una librería que simplifica el proceso de importar, exportar y/o convertir bases de datos desde múltiples extensiones.")

#------------------------------#
## Argumentos

cat(" 

Esta función utiliza los mismos argumentos para diferentes formatos. 

- file =  Dirección de directorio

- sep() = Separador de columnas (en .csv y .txt)

- skip =  Desde cuál fila leer la base de datos

- sheet = Cuál hoja leer

- header = T/F Nombres de las columnas en primera fila

- skipNul = T/F Se debe aceptar los no elementos. ")

#------------------------------#
## EJ: Importar

#### Importar desde un formato .csv
data_csv = import(file="clase_03/input/censo 2018.csv" , skip=6 , encoding="UTF-8") 

#### Importar desde un formato .xls
data_xls = import(file="clase_03/input/hurto-personas-2020_0.xlsx" , skip=9)

#------------------------------#
## EJ: Exportar

#### Exportar a un formato .csv 
export(x=data_csv, file="clase_03/output/data_csv.csv")

#### Exportar a un formato .xls 
export(x=data_xls , file="clase_03/output/data_excel.xlsx")

#### Indiquemos en que formato se debe de exportar .rds, .xlsx, ...
export(x=data_xls , file="clase_03/output/data_r.rds")

#------------------------------#
## Convertir
cat("`convert()` es la combinación de las funciones `import()` y `export()`, ya que permite cambiar la extensión de un archivo sin la necesidad de crear un objeto en R")

#### convertir .csv  ->  .xlsx
convert(in_file = "clase_03/input/Febrero - Cabecera - Características generales (Personas).csv" , out_file="clase_03/output/Febrero - Cabecera - Características generales (Personas).xls")

#### convertir .xlsx  ->  .rds
convert(in_file="clase_03/input/Febrero - Cabecera - Características generales (Personas).csv" , out_file="clase_03/input/Febrero - Cabecera - Características generales (Personas).rds")


#===================#
# Generar variables # 
#===================#
rm(list=ls())
cat(" Hay dos caminos para agregar variables a un dataframe: (data$var) de las librerías base de R  o con la función ( mutate() ) de la librería dplyr ")

#------------------------------#
## data$var

cat("Preparar la base de datos `mtcars`") 
library(help = "datasets")

df = as_tibble(mtcars) # convertir en tibble
df = df[,c(1,4,6,10)] # mantener solo las columnas 1,4,6 y 10


cat("Agregar una variable con la relación caballos de fuerza / peso del vehículo")
df$hp_vs = df$hp/df$wt # agregar nueva variable
df

#------------------------------#
## mutate()
cat("Generar una variable con la relación millas/galón sobre el número de caballos de fuerza:")

df = mutate(.data = df , mpg_hp = mpg/hp)
df

#------------------------------#
## Aplicar una condición

cat("Generar una variable para los vehículos pesados (wt>4) y otra para los vehículos con más de 3 velocidades")

# data$var
df$wt_4 = ifelse(test=df$wt>4 , yes=1 , no=0)

#mutate
df = mutate(.data=df , gear_4 = ifelse(test=gear>3 , yes=1 , no=0))

df


#------------------------------#
## Aplicar más de una condición
cat("Generar una variable de acuerdo al peso del vehículos: liviano (wt<3), estándar (wt>=3 & wt<=4) y pesado (wt>4).")

df = mutate(df , wt_chr = case_when(wt<3 ~ "liviano" ,
                                    wt>=3 & wt<=4 ~ "estándar" ,
                                    wt>4 ~ "pesado")
            )
df


#------------------------------#
## Aplicar una función a todas las variables
df = mutate_all(.tbl=df , .funs = as.character)
df


#=======================#
# Operador pipe [%>%]() #
#=======================#
rm(list=ls())
cat("es un operador que permite conectar funciones en R. [%>%]() se enfoca en la transformación que se le está haciendo al objeto y no en el objeto, permitiendo que el código sea más corto y fácil de leer. ")
browseURL("https://r4ds.had.co.nz/pipes.html") # Informacion extra 

#------------------------------#
## Ejemplo
cat("Anteriormente se creó un `tibble` con la base de datos de `mtcars`, después se dejaron solo cuatro columnas `(1,4,6,10)` y finalmente se generaron dos variables usando la función mutate. ")

df = as_tibble(mtcars) # convertir en tibble
df = df[,c(1,4,6,10)] # mantener solo las columnas 1,4,6 y 10
df = mutate(.data = df , mpg_hp = mpg/hp , hp_vs = hp/wt)
head(x=df , n=5)


#------------------------------#
## Ejemplo (cont.)

cat("Con `%>%` no es necesario mencionar el objeto en cada nueva transformación. Además, las líneas de código se reducen a la mitad.")

df = as_tibble(mtcars) %>% 
      .[,c(1,4,6,10)]  %>% 
      mutate(mpg_hp = mpg/hp , hp_vs = hp/wt)

df

#============================#
# Remover filas y/o columnas #
#============================#
rm(list=ls())
## Seleccionar variables
db = tibble(iris) %>% mutate(Species=as.character(Species))

db

#------------------------------#
## Seleccionar variables (cont.)
cat("La función `select()` permite seleccionar columnas de un dataframe o un tibble, usando el nombre o la posición de la variable en el conjunto de datos:")
db %>% select(c(1,3,5))

db %>% select(Petal.Length , Petal.Width , Species)

#------------------------------#
## Seleccionar variables usando partes del nombre
cat("Se seleciona los nombres variable que empizan con (*Sepal*)")
db %>% select(starts_with("Sepal"))

cat("Se seleciona los nombres de variable que contengan la palabra (*Width*)")
db %>% select(contains("Width")) 

#------------------------------#
## Seleccionar variables usando el tipo
cat("Variables de tipo carácter")
db %>% select_if(is.character)

cat("Variables de tipo numérico")
db %>% select_if(is.numeric) 

#------------------------------#
## Cambiar títulos de las variables 
cat("Usando select all se cambia los nombres a minuscula")
db %>% select_all(tolower) 

#------------------------------#
## Seleccionar variables usando un vector
cat("Tambien se puede selecionar las variables con un vector")

vars = c("Species","Sepal.Length","Petal.Width")
db %>% select(all_of(vars)) %>% head(n=3)

nums = c(5,2,3)
db %>% select(all_of(nums)) %>% head(n=3)

#------------------------------#
## Remover filas/observaciones
dev.off()
grid.raster(readPNG("pics/operadores_logicos.png"))

#------------------------------#
## Remover filas/observaciones (cont.)

# importar datos
db = read.csv("https://nyc-tlc.s3.amazonaws.com/trip+data/green_tripdata_2020-12.csv") %>%    select(passenger_count:payment_type) %>% tibble()

# Informacion extra de los datos
browseURL("https://www1.nyc.gov/site/tlc/about/tlc-trip-record-data.page") # source
browseURL("https://www1.nyc.gov/assets/tlc/downloads/pdf/data_dictionary_trip_records_green.pdf") # data dictionaries 

## Variables escogidas
# trip_distance  : The elapsed trip distance in miles reported by the taximeter
# total_amount   : The total amount charged to passengers. Does not include cash tips.
# payment_type   : 1= Credit card 2= Cash 3= No charge 4= Dispute 5= Unknown 6= Voided trip
# passenger_count: The number of passengers in the vehicle.
# trip_type      : 1= Street-hail 2= Dispatch

#------------------------------#
## Remover filas usando condicionales
cat("La función `subset()` pertenece a una de las librerías base de `R` y permite seleccionar todas las filas/observaciones de un conjunto de datos que cumplen una o más condiciones lógicas:")
db %>% subset(trip_distance > 5) # Distancia del viaje mayor a 5 millas

cat("usando la funcion `filter()` de la librería `dplyr`")
db %>% filter(passenger_count > 3) # Más de 3 pasajeros

#------------------------------#
## Remover valores faltantes
is.na(db$passenger_count) %>% tabyl() # número de observaciones faltantes

cat(" filas con valores faltantes en la variable `passenger_count`")
db = db %>% drop_na(passenger_count)

is.na(db$passenger_count) %>% tabyl() # número de observaciones faltantes


#=============================#
# Combinar conjuntos de datos #
#=============================#
 rm(list=ls())
 
## Agregar observaciones
cat(" la funcion ´set.seed()´ permite consistencia en los numeros aleatorios que se escoje")
set.seed(0117) 

cat("dos bases de datos similares, unica diferencia entre las dos es la addicion de la columna names")
df_1 = tibble(id = 100:105 , age = runif(6,18,25) %>% round() , height = rnorm(6,170,10) %>% round() )
df_2 = tibble(id = 106:107 , age = runif(2,40,50)  %>% round() , height = rnorm(2,165,8) %>% round() , name = c("Lee","Bo"))

df_1
df_2 

cat("Se juntan las bases de datos 1 & 2")
data = bind_rows(df_1,df_2, .id = "group")
data


#------------------------------#
## Agregar columna sin un id unico

cat("similar a la situacion anterior, creamos dos bases de datos")
set.seed(0117)
db_1 = tibble(id = 102:105 , income = runif(4,1000,2000) %>% round())
db_2 = tibble(id = 103:106 , age = runif(4,30,40)  %>% round())

db_2 
db_1

cat("sin un id unico, se obtiene:")
db = bind_cols(db_1,db_2)
db

cat("Algo salió mal!. la función `bind_cols()` no tiene en cuenta el identificador de cada observación.")

#================#
# Joint function #
#================#
rm(list=ls())

## Agregar variables: join()
dev.off()
grid.raster(readPNG("pics/types_join.png"))

# importamos bases de datos ejemplo
df_1 = import("clase_03/input/ejemplo_1.xlsx")
df_2 = import("clase_03/input/ejemplo_2.xlsx")

df_1
df_2

#------------------------------#
## Ejemplo: left_join()
df = left_join(x=df_1,y=df_2,by=c("hogar","visita"))
df

#------------------------------#
## Ejemplo: right_join()
df = right_join(x=df_1,y=df_2,by=c("hogar","visita"))
df

#------------------------------#
## Ejemplo: inner_join()
df = inner_join(x=df_1,y=df_2,by=c("hogar","visita"))
df

#------------------------------#
df = full_join(x=df_1,y=df_2,by=c("hogar","visita"))
df

#------------------------------#
## Ejemplo: Join sin identificador único
df = full_join(x=df_1,y=df_2,by=c("hogar"))
df


#=============================#
# Pivotear conjuntos de datos #
#=============================#

## Pivot

cat("Pivot es un intercambio entre el numero de filas y columnas")

dev.off()
grid.raste"pics/tidyr-spread-gather.gif"))



source: [tidyexplain](https://www.garrickadenbuie.com/project/tidyexplain/#spread-and-gather)  

#------------------------------#
<!--------- pivot_wider -------->         
#------------------------------#
## pivot_wide

- Pivot de 2 columnas, ejemplo:
```{r, eval=FALSE}
rango_sexo %>% pivot_wider(id_cols= c(rango,p6020), 
               names_from = p6020, 
               values_from = total )

```

```{r, eval=FALSE}
wide_rango_sexo = as.data.frame(rango_sexo %>% pivot_wider(id_cols= c(rango,p6020), names_from = p6020, values_from = total))
wide_rango_sexo
```

#------------------------------#
## pivot_wide

- Pivot de 3 columnas, ejemplo:
```{r, eval=FALSE}
mes_sexo_leen_ingreso_promedios %>%  pivot_wider(id_cols= c(mes, p6020, p6160), 
                                     names_from = p6160, 
                                     values_from = c(total,ingreso_promedio))
```

```{r, eval=FALSE , warning=FALSE, echo=FALSE}
mes_sexo_leen_ingreso_promedios = as.data.frame(mes_sexo_leen_ingreso_promedios %>%  pivot_wider(id_cols= c(mes, p6020, p6160), 
                                                                                     names_from = p6160, 
                                                                                     values_from = c(total,ingreso_promedio)))
mes_sexo_leen_ingreso_promedios
```


#------------------------------#
<!------- pivot_longer() ------->         
#------------------------------#
## pivot_longe

- Pivot devuelta
```{r, eval=FALSE}
wide_rango_sexo %>% pivot_longer( cols = c(hombre,mujer), names_to = "total")
```

```{r, eval=FALSE , warning=FALSE, echo=FALSE}
as.data.frame(wide_rango_sexo %>% pivot_longer( cols = c(hombre,mujer), names_to = "total"))
```

#------------------------------#
## pivot

<center>
![](pics/equation.gif)
</center>

Pivot puede ser un poco complicado, pero después de un poco de practica se vuelve mas fácil, no nos preocupemos habra mas practicas en la próxima clase. 





#---------------------#
## Para seguir leyendo

# Wickham, Hadley and Grolemund, Garrett, 2017. R for Data Science [[Ver aquí]](https://r4ds.had.co.nz)

# + Cap. 5: Data transformation
# + Cap. 10: Tibbles
# + Cap. 12: Tidy data


