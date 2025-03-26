--Listas--

-- 1) Definir una función que sume una lista de números. 
sumarLista :: [Int] -> Int
sumarLista = sum 

{- 2) Durante un entrenamiento físico de una hora, cada 10 minutos de entrenamiento se tomóo la frecuencia cardíaca de uno de los participantes obteniéndose un total de 7 muestras que son las siguientes:
frecuenciaCardiaca = [80, 100, 120, 128, 130, 123, 125] 
Comienza con un frecuencia de 80 min 0. 
A los 10 min la frecuencia alcanza los 100 
A los 20 min la frecuencia es de 120, 
A los 30 min la frecuencia es de 128
A los 40 min la frecuencia es de 130, …etc.. 
A los 60 min la frecuencia es de 125 frecuenciaCardiaca es un función constante. 
A) Definir la función promedioFrecuenciaCardiaca, que devuelve el promedio de la frecuencia cardíaca. 
Main> promedioFrecuenciaCardiaca 
115.285714285714
B) Definir la función frecuenciaCardiacaMinuto/1, que recibe m que es el minuto en el cual quiero conocer la frecuencia cardíaca, m puede ser a los 10, 20, 30 ,40,..hasta 60. 
Main> frecuenciaCardiacaMomento 30 
128 
Ayuda: Vale definir una función auxiliar para conocer el número de muestra. 
C) Definir la función frecuenciasHastaMomento/1, devuelve el total de frecuencias que se obtuvieron hasta el minuto m. 
Main> frecuenciasHastaMomento 30 
[80, 100, 120, 128] 
Ayuda: Utilizar la función take y la función auxiliar definida en el punto anterior. 
-}
frecuenciaCardiaca :: [Float]
frecuenciaCardiaca = [80, 100, 120, 128, 130, 123, 125] 

--A)
promedioFrecuenciaCardiaca :: [Float] -> Float
promedioFrecuenciaCardiaca frecuenciaCardiaca  = (sum frecuenciaCardiaca ) / fromIntegral (length frecuenciaCardiaca )

--B) 
frecuenciaCardiacaMinuto :: Int -> Float
frecuenciaCardiacaMinuto m = frecuenciaCardiaca !! div m 10

--C)
frecuenciasHastaMomento :: Int -> [Float]
frecuenciasHastaMomento m = take (div m 10 +1) frecuenciaCardiaca

{- 3) Definir la función esCapicua/1, si data una lista de listas, me devuelve si la concatenación de las sublistas es una lista capicua..Ej: 
Main> esCapicua ["ne", "uqu", "en"] 
True 
Porque “neuquen” es capicua.
Ayuda: Utilizar concat/1, reverse/1. -}

esCapicua :: Eq a => [[a]] -> Bool
esCapicua lista =  concat lista == concat (reverse lista)

{- 4) Se tiene información detallada de la duración en minutos de las llamadas que se llevaron a cabo en un período determinado, discriminadas 
en horario normal y horario reducido. 
duracionLlamadas = (("horarioReducido",[20,10,25,15]),(“horarioNormal”,[10,5,8,2,9,10])). 
A) Definir la función cuandoHabloMasMinutos, devuelve en que horario se habló más cantidad de minutos, en el de tarifa normal o en el reducido. 
Main> cuandoHabloMasMinutos 
“horarioReducido” 
B) Definir la función cuandoHizoMasLlamadas, devuelve en que franja horaria realizó más cantidad de llamadas, en el de tarifa normal o en el 
reducido. 
Main> cuandoHizoMasLlamadas 
“horarioNormal” -}
duracionLlamadas = (("horarioReducido",[20,10,25,15]),("horarioNormal",[10,5,8,2,9,10]))

--A)
cuandoHabloMasMinutos :: ((String, [Integer]), (String, [Integer])) -> String
cuandoHabloMasMinutos (("horarioReducido", lista1), ("horarioNormal", lista2))
    | sum lista1 > sum lista2 = "horarioReducido"
    | sum lista2 > sum lista1 = "horarioNormal"
    | otherwise = "Se hablaron la misma cantidad"

--B)
cuandoHizoMasLlamadas :: ((String, [Integer]), (String, [Integer])) -> String
cuandoHizoMasLlamadas (("horarioReducido", lista1), ("horarioNormal", lista2))
    | length lista1 > length lista2 = "horarioReducido"
    | length lista2 > length lista1 = "horarioNormal"
    | otherwise = "Realizaron la misma cantiad de llamadas"



--Orden Superior--

-- 1) Definir la función existsAny/2, que dadas una función booleana y una tupla de tres elementos devuelve True si existe algún elemento de la tupla que haga verdadera la función.
existsAny :: (a -> Bool) -> (a,a,a) -> Bool
existsAny  f = any f. (\(x,y,z) -> [x,y,z])

-- 2) Definir la función mejor/3, que recibe dos funciones y un número, y devuelve el resultado de la función que dé un valor más alto.
mejor :: (Ord b) => (a -> b) -> (a -> b) -> a -> b
mejor f g x = max (f x) (g x)

cuadrado x = x * x --Para comprobar nomas
triple x = x * 3
doble x = x * 2

-- 3) Definir la función aplicarPar/2, que recibe una función y un par, y devuelve el par que resulta de aplicar la función a los elementos del par.
aplicarPar :: (a -> b) -> (a,a) -> (b,b)
aplicarPar f (x,y) = (f x, f y)

--4) Definir la función parDeFns/3, que recibe dos funciones y un valor, y devuelve un par ordenado que es el resultado de aplicar las dos funciones al valor.
parDeFns :: (a -> b) -> (a -> c) -> a -> (b,c)
parDeFns f g x = (f x, g x)



--Orden Superior + Listas--

-- 1) Definir la función esMultiploDeAlguno/2, que recibe un número y una lista y devuelve True si el número es múltiplo de alguno de los números de la lista. 
esMultiploDeAlguno :: Int -> [Int] -> Bool
esMultiploDeAlguno x = any (\ y -> mod x y ==0) 

-- 2) Armar una función promedios/1, que dada una lista de listas me devuelve la lista de los promedios de cada lista-elemento
promedios :: [[Float]] -> [Float]
promedios  = map (\ lista -> sum lista / fromIntegral (length lista))

-- 3) Armar una función promediosSinAplazos que dada una lista de listas me devuelve la lista de los promedios de cada lista-elemento, excluyendo los que sean menores a 
-- 4 que no se cuentan. 
promediosSinAplazos :: [[Float]] -> [Float]
promediosSinAplazos = filter (>4) . map (\ lista -> sum lista / fromIntegral (length lista))

-- 4) Definir la función mejoresNotas, que dada la información de un curso devuelve la lista con la mejor nota de cada alumno.
mejoresNotas :: [[Int]] -> [Int]
mejoresNotas = map maximum

-- 5) Definir la función aprobó/1, que dada la lista de las notas de un alumno devuelve True si el alumno aprobó. Se dice que un alumno aprobó si todas sus notas son 6 o más.
aprobo :: [Int] -> Bool
aprobo = all (6<=)

-- 6) Definir la función aprobaron/1, que dada la información de un curso devuelve la información de los alumnos que aprobaron.
aprobaron :: [[Int]] -> [[Int]]
aprobaron = filter aprobo

-- 7) Definir la función divisores/1, que recibe un número y devuelve la lista de divisores
divisores :: Int -> [Int]
divisores n = filter (\ x -> mod n x == 0) [1..n]

-- 8) Definir la función exists/2, que dadas una función booleana y una lista devuelve True si la función da True para algún elemento de la lista.
exists :: (a -> Bool) -> [a] -> Bool
exists = any 

-- 9) Definir la función hayAlgunNegativo/2, que dada una lista de números y un (…algo…) devuelve True si hay algún nro. negativo. 
--Si algo = lista
hayAlgunNegativo ::  [Int] -> [Int] -> Bool
hayAlgunNegativo lista1 lista2 = any (0<) lista1 || any (0<) lista2

-- 10) Definir la función aplicarFunciones/2, que dadas una lista de funciones y un valor cualquiera, devuelve la lista del resultado de aplicar las funciones al valor. 
aplicarFunciones :: [a -> b] -> a -> [b] 
aplicarFunciones funciones valor = map (\ f -> f valor) funciones 

-- 11) Definir la función sumaF/2, que dadas una lista de funciones y un número, devuelve la suma del resultado de aplicar las funciones al número.
sumaF :: (Num b) => [a -> b] -> a -> b
sumaF funciones numero = sum (map (\ f -> f numero) funciones)
   
{- 12) Un programador Haskell está haciendo las cuentas para un juego de fútbol virtual (como el Hattrick o el ManagerZone). En un momento le llega la información sobre la habilidad
de cada jugador de un equipo, que es un número entre 0 y 12, y la orden de subir la forma de todos los jugadores en un número entero; p.ej., subirle 2 la forma a cada jugador. 
Ahora, ningún jugador puede tener más de 12 de habilidad; si un jugador tiene 11 y la orden es subir 2, pasa a 12, no a 13; si estaba en 12 se queda en 12. Escribir una función 
subirHabilidad/2 que reciba un número (que se supone positivo sin validar) y una lista de números, y le suba la habilidad a cada jugador cuidando que ninguno se pase de 12-}
subirHabilidad :: Int -> [Int] -> [Int]
subirHabilidad numero jugadores = map (\ jugador -> min (jugador + numero) 12) jugadores

{- 13) Ahora el requerimiento es más genérico: hay que cambiar la habilidad de cada jugador según una función que recibe la vieja habilidad y devuelve la nueva. 
Armar: una función flimitada que recibe una función f y un número n, y devuelve f n garantizando que quede entre 0 y 12 (si f n < 0 debe devolver 0, si f n > 12 debe devolver 12. -}
flimitada :: (Num b, Ord b) =>  (a -> b) -> a -> b
flimitada f n = max 0 (min (f n) 12)

-- A) Definir una función cambiarHabilidad/2, que reciba una función f y una lista de habilidades, y devuelva el resultado de aplicar f con las garantías de rango que da flimitada.
cambiarHabilidad :: (Num b, Ord b) => (a -> b) -> [a] -> [b]
cambiarHabilidad f  = map (flimitada f) 

-- B) Usar cambiarHabilidad/2 para llevar a 4 a los que tenían menos de 4, dejando como estaban al resto.
-- Cambio en flimitada el 0 por un 4

-- 14) takeWhle
--takeWhile :: (a -> Bool) -> [a] -> [a] -> toma elementos de una lista mientras se cumpla una funcion de tipo Bool
--takeWhile (<5) [1, 3, 5, 2, 4, 7, 6, 8] -> Toma los elementos de la lista menores que 5, cuando llega a uno que no se cumple, se detiene
-- Resultado: [1, 3]

-- 15) Usar takeWhile/2 para definir las siguientes funciones: 
-- A) primerosPares/1, que recibe una lista de números y devuelve la sublista hasta el primer no par exclusive.
primerosPares :: [Int] -> [Int]
primerosPares  = takeWhile even 

-- B) primerosDivisores/2, que recibe una lista de números y un número n, y devuelve la sublista hasta el primer número que no es divisor de n exclusive. 
primerosDivisores :: Int -> [Int] -> [Int]
primerosDivisores  numero  = takeWhile (\ x -> mod numero x ==0) 

-- C) primerosNoDivisores/2, que recibe una lista de números y un número n, y devuelve la sublista hasta el primer número que sí es divisor de n exclusive.
primerosNoDivisores :: Int -> [Int] -> [Int]
primerosNoDivisores numero = takeWhile (\ x -> mod numero x /=0)


{- 16)Se representa la información sobre ingresos y egresos de una persona en cada mes de un año mediante dos listas, de 12 elementos cada una. P.ej., si entre enero y junio gané 100,
 y entre julio y diciembre gané 120, mi lista de ingresos es:
[100,100,100,100,100,100,120,120,120,120,120,120] 
Si empecé en 100 y fui aumentando de a 20 por mes, llegando a 220, queda:
[100,120..220] 
Y si es al revés, empecé en 220 y fui bajando de a 20 por mes hasta llegar a 100, queda:
[220,200..100] 
(jugar un poco con esta notación) 
Definir la función: huboMesMejorDe/3, que dadas las listas de ingresos y egresos y un número, devuelve True si el resultado de algún mes es mayor que el número.-}
restarListas :: [Int] -> [Int] -> [Int]
restarListas [] _ = []
restarListas _ [] = []
restarListas (x:xs) (y:ys) = (x-y) : restarListas xs ys

huboMesMejorDe :: [Int] -> [Int] -> Int -> Bool
huboMesMejorDe ingresos egresos valor = (any (>valor) . restarListas ingresos) egresos

{- 17)  En una población, se estudió que el crecimiento anual de la altura de las personas sigue esta fórmula de acuerdo a la edad:
1 año: 22 cm 
2 años: 20 cm 
3 años: 18 cm 
... así bajando de a 2 cm por año hasta 
9 años: 6 cm 
10 a 15 años: 4 cm 
16 y 17 años: 2 cm 
18 y 19 años: 1 cm 
20 años o más: 0 cm 
A partir de esta información: 
A) Definir la función crecimientoAnual/1,que recibe como parámetro la edad de la persona, y devuelve cuánto tiene que crecer en un año. Hacerlo con guardas. La fórmula para 1 a 10 años 
es 24 - (edad * 2).
B) Definir la función crecimientoEntreEdades/2, que recibe como parámetros dos edades y devuelve cuánto tiene que crecer una persona entre esas dos edades. P.ej. 
Main> crecimientoEntreEdades 8 12 
22 
es la suma de 8 + 6 + 4 + 4, crecimientos de los años 8, 9, 10 y 11 respectivamente. 
Nota: Definir la función crecimientoEntreEdades en una sola línea, usando map y suma.
C) Armar una función alturasEnUnAnio/2, que dada una edad y una lista de alturas de personas, devuelva la altura de esas personas un año después. P.ej. 
Main> alturasEnUnAnio 7 [120,108,89] 
[130,118,99] 
Qué es lo que van a medir las tres personas un año después, dado que el coeficiente de crecimiento anual para 7 años da 10 cm. 
Nota: definir la función alturasEnUnAnio en una sola línea, usando map y la función (+ expresión). 
D) Definir la función alturaEnEdades/3, que recibe la altura y la edad de una persona y una lista de edades, y devuelve la lista de la altura que va a tener esa persona en cada una de
las edades. P.ej. 
Main> alturaEnEdades 120 8 [12,15,18] 
[142,154,164] 
que son las alturas que una persona que mide 120 cm a los 8 años va a tener a los 12, 15 y 18 respectivamente. 
-}

--A)
crecimientoAnual :: Int -> Int
crecimientoAnual edad 
    | edad < 10 = 24 - (edad * 2)
    | edad >= 10 && edad <= 15 = 4
    | edad == 16 || edad == 17 = 2
    | edad == 18 || edad == 19 = 1
    | otherwise = 0

--B)
crecimientoEntreEdades :: Int -> Int -> Int
crecimientoEntreEdades edad1 edad2 = sum (map crecimientoAnual [edad1..edad2-1])

--C)
alturasEnUnAnio :: Int -> [Int] -> [Int]
alturasEnUnAnio edad  = 
    map (\altura -> crecimientoAnual edad + altura)

--D) 
alturaEnEdades :: Int -> Int -> [Int] -> [Int]
alturaEnEdades altura edad  = 
    map (\ x -> crecimientoEntreEdades edad x + altura) 


{- 18) Se tiene información de las lluvias en un determinado mes por Ej: se conoce la siguiente información: 
lluviasEnero = [0,2,5,1,34,2,0,21,0,0,0,5,9,18,4,0]
A) (muy difícil) Definir la función rachasLluvia/1, que devuelve una lista de las listas de los días seguidos que llovió. P.ej. se espera que la consulta 
Main> rachasLluvia lluviasEnero 
[[2,5,1,34,2],[21],[5,9,18,4]]. 
B) A partir de esta definir mayorRachaDeLluvias/1, que devuelve la cantidad máxima de días seguidos que llovió. P.ej. se espera que la consulta mayorRachaDeLluvias lluviasEnero devuelva 5. 
Ayuda: ver las funciones dropWhile y takeWhile, probar p.ej. esto:
takeWhile even [2,4,7,10,14,15]
dropWhile even [2,4,7,10,14,15] -}

--A)
rachasLluvia :: [Int] -> [[Int]]
rachasLluvia lluvias
    | null lluvias = []
    | null racha = []
    | otherwise = racha : rachasLluvia resto
    where
        lluviasSinCero = dropWhile (== 0) lluvias
        racha = takeWhile (/= 0) lluviasSinCero
        resto = dropWhile (/= 0) lluviasSinCero


--B) 
mayorRachaDeLluvias :: [Int] -> Int
mayorRachaDeLluvias lluvias = maximum (map length (rachasLluvia lluvias))

--19) Definir una función que sume una lista de números. Nota: Resolverlo utilizando foldl/foldr. 
sumatoriaLista :: [Int] -> Int
sumatoriaLista  = foldl (+) 0 -- foldl :: (b -> a -> b) -> b -> [a] -> b => comienza sumando desde el principio de la lista

-- 20) Definir una función que resuelva la productoria de una lista de números. Nota: Resolverlo utilizando foldl/foldr.
productoriaLista :: [Int] -> Int
productoriaLista = foldl (*) 1 --product hace lo mismo

-- 21) Definir la función dispersion, que recibe una lista de números y devuelve la dispersión de los valores, o sea máximo - mínimo.  Nota: Probar de utilizar foldr.
dispersion :: [Int] -> (Int, Int)
dispersion [] = error "La lista está vacía"
dispersion xs = foldr (\x (minVal, maxVal) -> (min x minVal, max x maxVal)) (maxBound, minBound) xs








