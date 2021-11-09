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


#!------------------------------#
## Raw data y tidy data
cat("Tidy datasets are all alike, but every messy dataset is messy in its own way. -Hadley Wickham")
dev.off()
grid.raster(readPNG("pics/raw_tidy.png"))


#!------------------------------#
## Reglas de un conjunto de datos tidy
dev.off()
grid.raster(readPNG("pics/tidy_rules.png"))


#!------------------------------#
## tidyverse
<div align="center">
<img src="https://jminnier-berd-r-courses.netlify.app/02-data-wrangling-tidyverse/img/horst_tidyverse.jpg" height=450>
</div>
[Allison Horst](https://github.com/allisonhorst/stats-illustrations)


#!------------------------------#
## tidyverse (cont.)
cat("Antes de continuar, debe instalar y llamar la librería `tidyverse` así:")
install.packages("tidyverse")
library(tidyverse)
cat("Para ver los conflictos entre nombres de funciones en `tidyverse` con nombre de funciones en otras librerías, puede escribir sobre la consola `tidyverse_conflicts()`")


#!------------------------------#
## Cheat sheet
<div align="center">
<img src="pics/cheat_sheet_dplyr.png" height=480>
</div>
Puede encontrar una hoja de trucos para cada librería  [aquí](https://www.rstudio.com/resources/cheatsheets/).
browseURL("https://www.rstudio.com/resources/cheatsheets/")
vignette("dplyr")
vignette("tibble")


<!----------------------------------------------------------------------------->
<!------------------------- 2. Importar/exportar bases de datos---------------->
<!----------------------------------------------------------------------------->
# [2.] Importar/exportar
<html><div style='float:left'></div><hr color='#000099' size=3px width=850px></html>

#!------------------------------#
## Librería `rio` 

`rio` es una librería que simplifica el proceso de importar, exportar y/o convertir bases de datos desde múltiples extensiones.

<p>&nbsp;</p>

| File_type   | Importar	 |   Exportar  |
|:-|-:|-:|
|.csv         |  Import()  |   export()  |
|             |            |             |
|.txt         |  Import()  |   export()  |
|             |            |             |
|.xls & .xlsx |  Import()  |   export()  |
|             |            |             |
|.dta         |  Import()  |   export()  |
|             |            |             |
|RDS          |  Import()  |   export()  |

#!------------------------------#
## Argumentos

Esta función utiliza los mismos argumentos para diferentes formatos. 

- file = "" Dirección de directorio

- sep() = Separador de columnas (en .csv y .txt)

- skip =  Desde cuál fila leer la base de datos

- sheet = Cuál hoja leer

- header = T/F Nombres de las columnas en primera fila

- skipNul = T/F Se debe aceptar los no elementos.

#!------------------------------#
<!---------- Importar ---------->         
#!------------------------------#
## EJ: Importar

#### Importar desde un formato .csv
```{r}
data_csv = import(file="clase_03/input/censo 2018.csv" , skip=6 , encoding="UTF-8") 
```

```{r echo= FALSE}
data_csv %>% rename("codigo_divipola"= `Código DIVIPOLA`, "poblacion_en_hogares" = `Población en hogares particulares`, "poblacion_en_lea" = `Población en LEA` ) %>% select(codigo_divipola, `NOMBRE DEPARTAMENTO`, poblacion_en_hogares, poblacion_en_lea ) %>% head(2) 
```

#### Importar desde un formato .xls
```{r}
data_xls = import(file="clase_03/input/hurto-personas-2020_0.xlsx" , skip=9)
```

```{r echo= FALSE}
data_xls %>% select(DEPARTAMENTO, MUNICIPIO, MES, `ARMAS MEDIOS` ) %>% head(2) 
```

#!------------------------------#
<!--------- Exportar ----------->         
#!------------------------------#

## EJ: Exportar

#### Exportar a un formato .csv 
```{r, eval=FALSE}
export(x=data_csv, file="clase_03/output/data_csv.csv")
```

#### Exportar a un formato .xls 
```{r, eval=FALSE}
export(x=data_xls , file="clase_03/output/data_excel.xlsx")
```

#### Indiquemos en que formato se debe de exportar .rds, .xlsx, ...
```{r, eval=FALSE}
export(x=data_xls , file="clase_03/output/data_r.rds")
```

#!------------------------------#
<!----------- Convertir -------->         
#!------------------------------#
## Convertir

`convert()` es la combinación de las funciones `import()` y `export()`, ya que permite cambiar la extensión de un archivo sin la necesidad de crear un objeto en R


#### convertir .csv  ->  .xlsx

```{r, eval=FALSE}
convert(in_file = "file path.csv" , out_file="file path.xlsx")
```

#### convertir .xlsx  ->  .rds

```{r, eval=FALSE}
convert(in_file="file path.xlsx" , out_file="file path.rds")
```

<!----------------------------------------------------------------------------->
<!--------------------- 3. Generar variables  --------------------------->
<!----------------------------------------------------------------------------->
# [3.] Generar variables
<html><div style='float:left'></div><hr color='#000099' size=3px width=850px></html>

Hay dos caminos para agregar variables a un dataframe: *<mark>data$var</mark>* de las librerías base de R  o con la función *<mark>mutate()</mark>* de la librería dplyr 


#!------------------------------#
## data$var

Preparar la base de datos `mtcars` 
library(help = "datasets")

```{r}
df = as_tibble(mtcars) # convertir en tibble
df = df[,c(1,4,6,10)] # mantener solo las columnas 1,4,6 y 10
```

Agregar una variable con la relación caballos de fuerza / peso del vehículo 
```{r}
df$hp_vs = df$hp/df$wt # agregar nueva variable
head(x=df, n=5) # view df
```

#!------------------------------#
## mutate()

Generar una variable con la relación millas/galón sobre el número de caballos de fuerza:

```{r}
df = mutate(.data = df , mpg_hp = mpg/hp)
head(x=df, n=5)
```

#!------------------------------#
## Aplicar una condición

Generar una variable para los vehículos pesados (wt>4) y otra para los vehículos con más de 3 velocidades

```{r}
# data$var
df$wt_4 = ifelse(test=df$wt>4 , yes=1 , no=0)

#mutate
df = mutate(.data=df , gear_4 = ifelse(test=gear>3 , yes=1 , no=0))

head(x=df, n=5)
```

#!------------------------------#
## Aplicar más de una condición

Generar una variable de acuerdo al peso del vehículos: liviano (wt<3), estándar (wt>=3 & wt<=4) y pesado (wt>4).

```{r}
df = mutate(df , wt_chr = case_when(wt<3 ~ "liviano" ,
wt>=3 & wt<=4 ~ "estándar" ,
wt>4 ~ "pesado"))
head(x=df, n=5)
```

#!------------------------------#
## Aplicar una función a todas las variables

```{r}
df = mutate_all(.tbl=df , .funs = as.character)
str(df)
```

<!----------------------------------------------------------------------------->
<!----------------------- 4. Operador pipe [%>%]() ---------------------------->
<!----------------------------------------------------------------------------->
# [4.] Pipe (%>%)
<html><div style='float:left'></div><hr color='#000099' size=3px width=850px></html>

[pipe](https://r4ds.had.co.nz/pipes.html) es un operador que permite conectar funciones en R. [%>%]() se enfoca en la transformación que se le está haciendo al objeto y no en el objeto, permitiendo que el código sea más corto y fácil de leer. 

#!------------------------------#
## Ejemplo

Anteriormente se creó un `tibble` con la base de datos de `mtcars`, después se dejaron solo cuatro columnas `(1,4,6,10)` y finalmente se generaron dos variables usando la función mutate. 

```{r}
df = as_tibble(mtcars) # convertir en tibble
df = df[,c(1,4,6,10)] # mantener solo las columnas 1,4,6 y 10
df = mutate(.data = df , mpg_hp = mpg/hp , hp_vs = hp/wt)
head(x=df , n=5)
```

#!------------------------------#
## Ejemplo (cont.)

Otra forma de hacerlo con pipe `%>%` es:  

```{r}
df = as_tibble(mtcars) %>% .[,c(1,4,6,10)]  %>% 
mutate(mpg_hp = mpg/hp , hp_vs = hp/wt)
head(x=df , n=5)
```

Con `%>%` no es necesario mencionar el objeto en cada nueva transformación. Además, las líneas de código se redujeron a la mitad.

<!----------------------------------------------------------------------------->
<!------------------ 5. Filtrar (remover filas y/o columnas) ------------------>
<!----------------------------------------------------------------------------->
# [5.] Remover filas y/o columnas
<html><div style='float:left'></div><hr color='#000099' size=3px width=850px></html>

#!------------------------------#
## Seleccionar variables
`iris` es un conjunto de datos de la librería `datasets`, que contiene las medidas en centímetros de la longitud y ancho del sépalo y largo y ancho del pétalo, respectivamente, para 50 flores de cada una de las 3 especies de iris. 
```{r }
db = tibble(iris) %>% mutate(Species=as.character(Species))
db
```


#!------------------------------#
## Seleccionar variables (cont.)
La función `select()` permite seleccionar columnas de un dataframe o un tibble, usando el nombre o la posición de la variable en el conjunto de datos:
```{r }
db %>% select(c(1,3,5)) %>% head(n=3) 

db %>% select(Petal.Length , Petal.Width , Species) %>% head(n=3)
```


#!------------------------------#
## Seleccionar variables usando partes del nombre
Nombres de variable que empizan con (*Sepal*)
```{r }
db %>% select(starts_with("Sepal")) %>% head(n=3)
```
Nombres de variable que contengan la palabra (*Width*)
```{r }
db %>% select(contains("Width")) %>% head(n=3)
```


#!------------------------------#
## Seleccionar variables usando el tipo
Variables de tipo carácter
```{r }
db %>% select_if(is.character) %>% head(3)
```
Variables de tipo numérico
```{r }
db %>% select_if(is.numeric) %>% head(3)
```


#!------------------------------#
## Cambiar títulos de las variables 
Cambiar títulos de las variables a minúsculas usando `selecta_all()`
```{r }
db %>% select_all(tolower) %>% head(n=5)
```


#!------------------------------#
## Seleccionar variables usando un vector
Vector de caracteres
```{r }
vars = c("Species","Sepal.Length","Petal.Width")
db %>% select(all_of(vars)) %>% head(n=3)
```
Vector numérico
```{r }
nums = c(5,2,3)
db %>% select(all_of(nums)) %>% head(n=3)
```


#!------------------------------#
## Remover filas/observaciones

Operadores lógicos:

| Operador | Descripción | 
|:-|-:|
|`<` , `>`| Menor y mayor que |
|`<=` , `>=`| Menor o igual y mayor igual que |
|`==`| Igual a |
|`!=`| Diferente de |
|`&`| y |
|`|`| o |
|`!`| Negación |


#!------------------------------#
## Remover filas/observaciones (cont.)
# importar datos
browseURL("https://www1.nyc.gov/site/tlc/about/tlc-trip-record-data.page") # source
browseURL("https://www1.nyc.gov/assets/tlc/downloads/pdf/data_dictionary_trip_records_green.pdf") # data dictionaries 
df = read.csv("https://nyc-tlc.s3.amazonaws.com/trip+data/green_tripdata_2020-12.csv")

# trip_distance: The elapsed trip distance in miles reported by the taximeter
# total_amount: The total amount charged to passengers. Does not include cash tips.
# payment_type: 1= Credit card 2= Cash 3= No charge 4= Dispute 5= Unknown 6= Voided trip
# passenger_count: The number of passengers in the vehicle.
# trip_type: 1= Street-hail 2= Dispatch


Importar datos:
```{r }
db = read.csv("https://nyc-tlc.s3.amazonaws.com/trip+data/green_tripdata_2020-12.csv") %>%    select(passenger_count:payment_type) %>% tibble()
db %>% head(n=5)
```
Este conjunto de datos fue recopilado y proporcionado a la Comisión de Taxis y Limusinas (TLC) de la Ciudad de Nueva York. La base de datos contiene los registros de viaje en taxi amarillo y verde, y proporciona información de lugares de recogida y llegada, distancia del viaje entre otras variables. Puede acceder a la página de TLC [aquí]( https://www1.nyc.gov/site/tlc/about/tlc-trip-record-data.page) y al diccionario completo [aquí](https://www1.nyc.gov/assets/tlc/downloads/pdf/data_dictionary_trip_records_green.pdf).


#!------------------------------#
## Remover filas usando condicionales
La función `subset()` pertenece a una de las librerías base de `R` y permite seleccionar todas las filas/observaciones de un conjunto de datos que cumplen una o más condiciones lógicas:
```{r }
db %>% subset(trip_distance > 5) %>% head(n=5) # Distancia del viaje mayor a 5 millas
```


#!------------------------------#
## Remover filas usando condicionales (cont.)
La función `filter()` de la librería `dplyr` :
```{r }
db %>% filter(passenger_count > 3) %>% head(n=5) # Más de 3 pasajeros
```


#!------------------------------#
## Remover valores faltantes
Número de observaciones sin información para el número de pasajeros en el viaje
```{r }
is.na(db$passenger_count) %>% tabyl() # número de observaciones faltantes
```
Remover filas con valores faltantes en la variable `passenger_count`
```{r }
db = db %>% drop_na(passenger_count)
```
```{r }
is.na(db$passenger_count) %>% tabyl() # número de observaciones faltantes
```


<!----------------------------------------------------------------------------->
<!---------------  6. Combinar conjuntos de datos ------------------>
<!----------------------------------------------------------------------------->
# [6.] Combinar conjuntos de datos
<html><div style='float:left'></div><hr color='#000099' size=3px width=850px></html>

#!------------------------------#
## Agregar observaciones

```{r, echo=FALSE}
set.seed(0117)
df_1 = tibble(id = 100:105 , age = runif(6,18,25) %>% round() , height = rnorm(6,170,10) %>% round() )
df_2 = tibble(id = 106:107 , age = runif(2,40,50)  %>% round() , 
height = rnorm(2,165,8) %>% round() , name = c("Lee","Bo"))
```

```{r}
df_1 %>% head(n = 5)
df_2 %>% head(n = 2)
```

#!------------------------------#
## Agregar observaciones (cont.)

```{r}
data = bind_rows(df_1,df_2, .id = "group")
data
```

#!------------------------------#
## Agregar variables

```{r, echo=FALSE}
set.seed(0117)
db_1 = tibble(id = 102:105 , income = runif(4,1000,2000) %>% round())
db_2 = tibble(id = 103:106 , age = runif(4,30,40)  %>% round())
```
```{r}
db_1 %>% head(n = 5)
db_2 %>% head(n = 4)
```

#!------------------------------#
## Agregar variables (cont.)
```{r}
db = bind_cols(db_1,db_2)
db
```
<mark>Algo salió mal!</mark> la función `bind_cols()` no tiene en cuenta el identificador de cada observación. 

#!------------------------------#
<!------ Joint function -------->
#!------------------------------#

## Agregar variables: join()
![](pics/types_join.png)

#!------------------------------#
## Ejemplo: left_join()
```{r, eval=FALSE}
df = left_join(x=df_1,y=df_2,by=c("Casa","Visita"))
```
![](pics/left_join.png)


#!------------------------------#
## Ejemplo: right_join()
```{r, eval=FALSE}
df = right_join(x=df_1,y=df_2,by=c("Casa","Visita"))
```
![](pics/right_join.png)


#!------------------------------#
## Ejemplo: inner_join()
```{r, eval=FALSE}
df = inner_join(x=df_1,y=df_2,by=c("Casa","Visita"))
```
![](pics/inner_join.png)


#!------------------------------#
## Ejemplo: full_join()
```{r, eval=FALSE}
df = full_join(x=df_1,y=df_2,by=c("Casa","Visita"))
```
![](pics/full_join.png)


#!------------------------------#
## Ejemplo: Join sin identificador único
```{r, eval=FALSE}
df = full_join(x=df_1,y=df_2,by=c("Hogar"))
```
![](pics/bad_join.png){width=45%}

```{r, echo=FALSE}
df_1 = tibble(Hogar=1,Visita=1,Sexo=1)
df_2 = tibble(Hogar=1,Visita=1,Edad=1,Ingresos=1)
```
```{r, eval=T}
intersect(colnames(df_1),colnames(df_2))
```


<!----------------------------------------------------------------------------->
<!------------------- 7. Pivotear conjuntos de datos -------------------------->
<!----------------------------------------------------------------------------->

# [7.]. Pivotear conjuntos de datos
<html><div style='float:left'></div><hr color='#000099' size=3px width=850px></html>


#!------------------------------#
## Pivot

- Pivot es un intercambio entre el numero de filas y columnas

<center>
![](pics/tidyr-spread-gather.gif)
</center>

source: [tidyexplain](https://www.garrickadenbuie.com/project/tidyexplain/#spread-and-gather)  

#!------------------------------#
<!--------- pivot_wider -------->         
#!------------------------------#
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

#!------------------------------#
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


#!------------------------------#
<!------- pivot_longer() ------->         
#!------------------------------#
## pivot_longe

- Pivot devuelta
```{r, eval=FALSE}
wide_rango_sexo %>% pivot_longer( cols = c(hombre,mujer), names_to = "total")
```

```{r, eval=FALSE , warning=FALSE, echo=FALSE}
as.data.frame(wide_rango_sexo %>% pivot_longer( cols = c(hombre,mujer), names_to = "total"))
```

#!------------------------------#
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


