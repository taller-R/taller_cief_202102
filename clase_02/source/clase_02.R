# author: Eduard F. Martínez-González
# update: 28-10-2021
# R version 4.1.1 (2021-08-10)

# initial configuration
rm(list=ls()) # limpiar entorno
Sys.setlocale("LC_CTYPE", "en_US.UTF-8") # Encoding UTF-8

# install/load packages
install.packages("pacman")
require(pacman)
p_load(dplyr,tidyr,tibble,data.table)

## Hoy veremos

### 1. R + Git

### 2. Workspace

### 3. Vectores y matrices

### 4. Dataframe

### 5. Listas


#==============#
# 2. Workspace #
#==============#

## ¿Workspace?
cat("El espacio de trabajo es la colección de objetos almacenados en la memoría activa de R. Para gestionar el espacio de trabajo:")

objects() # ver objetos en el espacio de trabajo
ls() # ver objetos en el espacio de trabajo
rm() # remover un objeto del espacio de trabajo
rm(list=ls()) # Limpiar el entorno de trabajo
cat("\f") # Limpiar la consola

#========================#
# 2. Vectores y matrices #
#========================#
cat("Los vectores y las matrices son objetos homogéneos. Es decir, 
    todos los elementos de estos objeto deben ser del mismo tipo (númerico o carácter o lógico). 
    Sim embargo, mientras los vectores son de una dimensión 
    las matrices tienen dos dimensiones (filas y columnas).")

#----------------------#
## Tipos de datos

# Numericos
is(10)

# Caracteres
is.character("Hola")

# Lógicos (TRUE,FALSE,NA,NULL)
is(TRUE) ; is.na(NA)

#----------------------#
## Vectores númericos

#### Asignar valores
x <- c(1 , 2 , 3 , 4 , 5)
c(1 , 2 , 3 , 4 , 5) -> x
assign("x", c(1 , 2 , 3 , 4 , 5))
y = c(0, x , 6) # Concatenar vectores


#### Operaciones aritmeticas
cat("Algunos operadores que se pueden aplicar: +, -, *, /, ^, sum(), mean(), min()...")
sum(x) ; length(x) ; prod(x) ; mean(x)

#----------------------#
## Vectores númericos (cont.)
cat("Generar secuencias regulares:")
x = 1:5
x
x1 = seq(-5, 5, by=2)
x1
x2 <- rep(x, times=5)
x2
x3 <- rep(x, each=5)
x3

#----------------------#
## Vectores lógicos

# Operadores lógicos:
"< , > : Menor y mayor que
<= , >= : Menor o igual y mayor igual que
== : Igual a
!= : Diferente de
& : y
| : o
! : Negación"

a = 1:5
a
x = c(0,2:5)
a==x
c = a==x

#----------------------#
## Vectores lógicos (cont.)
logi = c(TRUE,NA,FALSE,NULL)
logi

# aplicar un operador
logi = 1:5 >= 3
logi

#### Valores faltantes
x = c(1:3,NA,0/0,Inf-Inf)
x
is.na(x)


#----------------------#
## Vector de caracteres

# Puede usarse " o ' para escribir una cadena de caracteres en R:
x = c("Hola-","Mundo-",10)
x

# Pueden concatenarse cadenas de caracteres usando la función paste() o paste0()
y = paste(x, 1:5, sep = "")
y


#----------------------#
## Manipulación de vectores

# Usando operadores lógicos o aritmeticos
x = c(NA,1,2,3,4,5,NA)

y = x[!is.na(x)] # Diferentes de NA
y
x[c(FALSE,TRUE,TRUE,TRUE,TRUE,T,F)]

v = x[x>3] # Mayores a 3 (Ojo con los NA)
v

z = x[x %in% 1:3] # Contenidos en 1 a 3
z


#----------------------#
## Manipulación de vectores (cont.)

# Usando la posición de los elementos 
x = c("hola","mundo","de nuevo")
x
y = x[1] # maneter elemento de la posición 1
y
v = x[2:3] # maneter elementos de la posición 2 a la 3
v
z = x[-3] # eliminar el tercer elemento
z


#----------------------#
## Atributos de un vector

length(x) # largo del vector
class(x) # clase
str(x) # tipo de dato
object.size(x) # tamaño


#----------------------#
## Matrices

#### Hacer una matriz numerica
x = matrix(data = 1:120 , nrow=10 , ncol=1)
x

#### Hacer una matriz de caracteres
y = matrix(data = c("hola","mundo") , nrow=2 , ncol=2)
y

#----------------------#
## Manipular matrices

# Las matrices tienen dos dimensiones [i,j], siendo i y j la la i-ésima fila y j-ésima la columna respectivamente.
x[1,] # Obtener la fila 1
x[,3] # Obtener la columna 3
x[2,2] # Obtener elemento de la fila y columa 2


#----------------------#
## Manipular matrices (cont.)
x[x<4] = NA
x


#----------------------#
## Atributos de una matriz
attributes(x) # atributos
class(x) # clase
str(x) # tipo de dato

#================#
# [4.] Dataframe #
#================#
  
cat("Los dataframes son objetos heterogéneos de dos dimensiones. 
    Es decir, puede almacener elementos de diferentes tipos (númericos, carácteres y lógicos al mismo tiempo) 
    y tiene dos dimensiones (filas y columnas).")

#----------------------#
## Generar dataframe
char = letters
num = seq(1,26,1)
logi = rep(NA,26)
df = data.frame(caracter = char , numerico = num , logico = logi)
df

#----------------------#
## Importar dataframe
library(help = "datasets")
class(mtcars)
mtcars # The data was extracted from the 1974 Motor Trend US magazine


#----------------------#
## Manipular un dataframe

# Ver atributos:
df = mtcars
dim(df) # dimensiones
colnames(df) # nombres de las columnas
rownames(df) # nombres de las filas
attributes(df) # Ver atributos


#----------------------#
## Manipular un dataframe (cont.)

# Subset filas y/o columnas:
df[1,] # Obtener primera fila
df[1:3,1:4] # Obtener las primeras 4 filas/columnas


#----------------------#
## Manipular un dataframe (cont.)

# Remover filas y/o columnas:
x = df[-1:-10,] # Remover primeras 10 filas
head(x)


#----------------------#
## Manipular un dataframe (cont.)

# Agregar columnas/variables:
df$vehiculo = rownames(df) 
colnames(df)
head(df)


#----------------------#
## as_tibble() vs as.data.frame()

cat("Los objetos tbl son más eficientes en terminos computacionales")
class(df)
tb = as_tibble(df)
class(tb)
tb


#=============#
# [5.] Listas #
#=============#

cat("Las listas son objetos heterogéneos de una dimensión. 
    Es decir, en una lista se puede almacener diferentes tipos de objetos (vectores, matricez, dataframes y listas) 
    pero al igual que los vectores tienen solo una dimensión (fila o columna).")

#----------------------#
## Generar lista
lista = list("tibble_1"=tb[1:5,],
             "tibble_2"=tb[6:10,]) # Asignar nombre a cada posición dentro de la lista

lista[[3]] = tb[11:nrow(tb),] # Almacenar en la tercera posición
lista

#----------------------#
## Manipular una lista

# Ver atributos:
length(lista) # dimensiones
names(lista) # nombres de los elementos
names(lista)[3] = "tibble_3" # Asignar nombre al elemento 3
attributes(lista) # Ver atributos

#----------------------#
## Manipular una lista (cont.)

# Adicionar un elemento
lista[[4]] = letters
head(lista)  


#----------------------#
## Manipular una lista (cont.)

# Remover un elemento:
lista = lista[-4]
head(lista)


#----------------------#
## Manipular una lista (cont.)

# Subset elmentos:
lista[[1]] # usando la posición del elemento
lista[[1]][,"vehiculo"] # dentro del objeto


#----------------------#
## Manipular una lista (cont.)

# Subset elmentos:
lista[["tibble_1"]] # Usando el nombre del elemento
lista$tibble_2


#----------------------#
## Manipular una lista (cont.)

# Apilar los elementos de una lista:
db = rbindlist(l = lista , use.names = T)
head(db)
class(db)

#----------------------#
## Para seguir leyendo

# W. N. Venables, D. M. Smith, 2021. An Introduction to R [[Ver aquí]](https://cran.r-project.org/doc/manuals/r-release/R-intro.pdf)

# + Cap. 2: Simple manipulations; numbers and vectors
# + Cap. 3: Objects, their modes and attributes
# + Cap. 5: Arrays and matrices 
# + Cap. 6: Lists and data frames

# Colin Gillespie and Robin Lovelace, 2017. Efficient R Programming, A Practical Guide to Smarter Programming [[Ver aquí]](https://csgillespie.github.io/efficientR/)

# + Cap. 4: Efficient Workflow

              