
#---------------------------#
## agregar año y estatus laboral

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
## renombrar variables

#### Caracteristicas Generales
cg[[1]] = cg[[1]] %>% select_all(tolower) %>% select("secuencia_p", "directorio","orden","esc","dpto","year","fex_c_2011","p6020")
cg[[2]] = cg[[2]] %>% select_all(tolower) %>% select("secuencia_p", "directorio","orden","esc","dpto","year","fex_c_2011","p6020")

#### Ocupados
ocu[[1]] = ocu[[1]] %>% select_all(tolower) %>% select("secuencia_p", "directorio","orden","ocu","p6500")
ocu[[2]] = ocu[[2]] %>% select_all(tolower) %>% select("secuencia_p", "directorio","orden","ocu","p6500")

#### Desocupados 
deso[[1]] = deso[[1]] %>% select_all(tolower) %>% select("secuencia_p", "directorio","orden","deso")
deso[[2]] = deso[[2]] %>% select_all(tolower) %>% select("secuencia_p", "directorio","orden","deso")

#### Inactivos
inac[[1]] = inac[[1]] %>% select_all(tolower) %>% select("secuencia_p" ,"directorio","orden","inac")
inac[[2]] = inac[[2]] %>% select_all(tolower) %>% select("secuencia_p" ,"directorio","orden","inac")

#### Fuerza de Trabajo 
ft[[1]] = ft[[1]] %>% select_all(tolower) %>% select("secuencia_p", "directorio","orden","fuerza")
ft[[2]] = ft[[2]] %>% select_all(tolower) %>% select("secuencia_p", "directorio","orden","fuerza")

