module Library where
import Prelude
import Text.Show.Functions
import Data.List

data Ciudad = Ciudad {
  nombre ::String, 
  año ::Float, 
  atracciones ::[String], 
  costoDeVida ::Float
} deriving (Show)

baradero :: Ciudad
baradero = Ciudad "Baradero" 1615 ["Parque del Este", "Museo Alejandro Barbich"] 150

nullish :: Ciudad
nullish = Ciudad "Nullish" 1800 [] 140

caletaOliva :: Ciudad
caletaOliva = Ciudad "Caleta Oliva" 1901 ["El Gorosito", "Faro Costanera"] 120

azul :: Ciudad
azul = Ciudad "Azul" 1832 ["Teatro Español", "Parque Municipal Sarmiento", "Costanera Cacique Catriel"] 190 

buenosAires :: Ciudad
buenosAires = Ciudad "Buenos Aires" 1580  ["Casa Rosada", "Obelisco"] 1500 --Ejemplo punto 4

listaCiudades1 :: [Ciudad]
listaCiudades1 = []

listaCiudades2 :: [Ciudad]
listaCiudades2 = [azul]

listaCiudades3 :: [Ciudad]
listaCiudades3 = [caletaOliva, nullish, baradero, azul]

listaCiudades4 :: [Ciudad]
listaCiudades4 = [caletaOliva, azul, baradero]

listaDiscoRayado :: [Ciudad]
listaDiscoRayado = azul : nullish : cycle [caletaOliva, baradero] 



{- Punto 1: Valor de una ciudad

Valor de una ciudad
Definir el valor de una ciudad, un número que se obtiene de la siguiente manera:
si fue fundada antes de 1800, su valor es 5 veces la diferencia entre 1800 y el año de fundación
si no tiene atracciones, su valor es el doble del costo de vida
de lo contrario, será 3 veces el costo de vida de la ciudad
-}

valorCiudad :: Ciudad -> Float
valorCiudad ciudad
    | año ciudad < 1800 = (1800 - año ciudad) * 5
    | null (atracciones ciudad) = costoDeVida ciudad * 2
    | otherwise = costoDeVida ciudad * 3


{- Punto 2: Características de las ciudades

Alguna atracción copada
Queremos saber si una ciudad tiene alguna atracción copada, esto es que la atracción comience con una vocal. Por ejemplo: "Acrópolis" es una atracción copada
y "Golden Gate" no es copada.
En este caso puede utilizar la siguiente función:
-}
 
esVocal :: Char -> Bool
esVocal character = character `elem` "aeiouAEIOU"

atraccionCopada :: Ciudad -> Bool
atraccionCopada ciudad = any (esVocal . head) (atracciones ciudad)


{- Ciudad sobria
Queremos saber si una ciudad es sobria, esto se da si todas las atracciones tienen más de x letras. El valor x tiene que poder configurarse. -}

ciudadSobria :: Ciudad -> Int -> Bool
ciudadSobria ciudad cantidadLetras = not (null (atracciones ciudad)) && all ((>cantidadLetras). length) (atracciones ciudad)


{-Ciudad con nombre raro
Queremos saber si una ciudad tiene un nombre raro, esto implica que tiene menos de 5 letras en su nombre. Recuerde que no puede definir funciones auxiliares.-}

ciudadNombreRaro::Ciudad -> Bool
ciudadNombreRaro ciudad = length (nombre ciudad) < 5


{-Punto 3: Eventos
Queremos poder registrar eventos que ocurren sobre una ciudad y que la afectan en mayor o menor medida. Dichos eventos son:

Sumar una nueva atracción
Queremos poder agregar una nueva atracción a la ciudad. Esto implica un esfuerzo de toda la comunidad en tiempo y dinero, lo que se traduce en un incremento 
del costo de vida de un 20%.-}

calcularCostoDeVida :: Float -> Float -> Float
calcularCostoDeVida porcentajeCostoDeVida costoDeVida  = costoDeVida * (porcentajeCostoDeVida / 100)

sumarNuevaAtraccion :: [String] -> Ciudad -> Ciudad
sumarNuevaAtraccion [nuevaAtraccion] ciudad = 
  ciudad {atracciones = atracciones ciudad ++ [nuevaAtraccion], 
          costoDeVida = costoDeVida ciudad + calcularCostoDeVida 20 (costoDeVida ciudad) }

{-Crisis
Al atravesar una crisis, la ciudad baja un 10% su costo de vida y se debe cerrar la última atracción de la lista. -}
quitarAtraccion :: Ciudad -> Ciudad
quitarAtraccion ciudad
  | null (atracciones ciudad) = ciudad
  | otherwise = ciudad { atracciones = init (atracciones ciudad) }

costoDeVidaConCrisis :: Ciudad -> Ciudad
costoDeVidaConCrisis ciudad = ciudad { costoDeVida = costoDeVida ciudad - calcularCostoDeVida 10 (costoDeVida ciudad)}

crisis :: Ciudad -> Ciudad
crisis ciudad = quitarAtraccion (costoDeVidaConCrisis ciudad)


{-Remodelación
Al remodelar una ciudad, incrementa su costo de vida un porcentaje que se indica al hacer la remodelación y le agrega el prefijo "New " al nombre. -}

remodelarCiudad :: Float -> Ciudad -> Ciudad
remodelarCiudad porcentajeCostoDeVida ciudad = 
  ciudad { nombre = "New " ++ nombre ciudad,
           costoDeVida = costoDeVida ciudad + calcularCostoDeVida porcentajeCostoDeVida (costoDeVida ciudad)}

{-Reevaluación
Si la ciudad es sobria con atracciones de más de n letras (valor que se quiere configurar), aumenta el costo de vida un 10%, si no baja 3 puntos. -}
reevaluacionCiudad :: Int -> Ciudad -> Ciudad
reevaluacionCiudad cantidadLetras ciudad = ciudad { costoDeVida = costoSobria cantidadLetras ciudad }

costoSobria :: Int -> Ciudad -> Float
costoSobria cantidadLetras ciudad
  | ciudadSobria ciudad cantidadLetras = costoDeVida ciudad + calcularCostoDeVida 10 (costoDeVida ciudad)
  | otherwise = costoDeVida ciudad - 3.0

{- Punto 4: La transformación no para
Reflejar de qué manera podemos hacer que una ciudad tenga
el agregado de una nueva atracción
una remodelación
una crisis
y una reevaluación

ghci>(reevaluacionCiudad 5 . crisis . remodelarCiudad 10 . sumarNuevaAtraccion ["Obelisco"]) buenosAires-}


{-aplicarEvento :: Ciudad -> Evento -> Ciudad
aplicarEvento ciudad (SumarNuevaAtraccion atraccion) = sumarNuevaAtraccion [atraccion] ciudad
aplicarEvento ciudad Crisis = crisis ciudad
aplicarEvento ciudad (Remodelacion porcentaje) = remodelarCiudad porcentaje ciudad
aplicarEvento ciudad (ReevaluacionCiudad n) = reevaluacionCiudad n ciudad-}

type Evento = Ciudad -> Ciudad

data Año = Año {
  anio :: Int,
  eventos :: [Evento]
} 

--el2024 :: Año
--el2024 = Año 2024 (Crisis : ReevaluacionCiudad 7 : map Remodelacion [1..])

el2023 :: Año
el2023 = Año {
  anio = 2023,
  eventos = [crisis, sumarNuevaAtraccion ["Parque"], remodelarCiudad 10, remodelarCiudad 20] }

el2022 :: Año
el2022 = Año {
  anio = 2022,
  eventos = [crisis, remodelarCiudad 5, reevaluacionCiudad 7] }

el2021 :: Año
el2021 = Año {
  anio = 2021,
  eventos = [crisis, sumarNuevaAtraccion ["Playa"]] }

el2015 :: Año
el2015 = Año 2015 []

listaAños1 :: [Año]
listaAños1 = []

listaAños2 :: [Año]
listaAños2 = [el2022]

listaAños3 :: [Año]
listaAños3 = [el2021, el2022, el2023]

listaAños4 :: [Año]
listaAños4 = [el2022, el2021, el2023]

type Criterio = Ciudad -> Float

{- 1.1 Los años pasan...
Queremos modelar un año, donde definamos: el número que le corresponde yuna serie de eventos que se produjeron

También queremos reflejar el paso de un año para una ciudad, es decir, que los eventos afecten el estado final
en el que queda una ciudad.
-}

pasoDeUnAño :: Año -> Ciudad -> Ciudad
pasoDeUnAño (Año _ eventos) ciudad = foldl (\ciudad evento -> evento ciudad) ciudad eventos

{- 1.2  Algo mejor
Implementar una función que reciba una ciudad, un criterio de comparación y un evento, de manera que nos diga
si la ciudad tras el evento subió respecto a ese criterio. 
-}

algoMejor :: Ciudad -> Criterio -> Evento -> Bool
algoMejor ciudad criterio evento = criterio ( evento ciudad) > criterio ciudad

criterio1 :: Criterio
criterio1  = fromIntegral . length . atracciones

{- 1.3 Costo de vida que suba
Para un año, queremos aplicar sobre una ciudad solo los eventos que hagan que el costo de vida suba. 
Debe quedar como resultado la ciudad afectada con dichos eventos.
-}

aplicarEventosSegunCriterio :: (Evento -> Bool) -> Ciudad -> Año -> Ciudad
aplicarEventosSegunCriterio criterio ciudad (Año _ eventos) = foldl (\ciudad evento -> evento ciudad) ciudad . filter criterio $ eventos 

costoDeVidaQueSuba :: Ciudad -> Año -> Ciudad
costoDeVidaQueSuba ciudad = aplicarEventosSegunCriterio (algoMejor ciudad costoDeVida) ciudad

{- 1.4 Costo de vida que baje
Para un año, queremos aplicar solo los eventos que hagan que el costo de vida baje. Debe quedar como resultado
la ciudad afectada con dichos eventos.
-}

costoDeVidaQueBaje :: Ciudad -> Año -> Ciudad
costoDeVidaQueBaje ciudad = aplicarEventosSegunCriterio (not . algoMejor ciudad costoDeVida) ciudad

{- 1.5 Valor que suba
Para un año, queremos aplicar solo los eventos que hagan que el valor suba. Debe quedar como resultado la 
ciudad afectada con dichos eventos.
-}

valorQueSuba :: Ciudad -> Año -> Ciudad
valorQueSuba ciudad = aplicarEventosSegunCriterio (algoMejor ciudad valorCiudad) ciudad


{- 2.1 Eventos ordenados
Dado un año y una ciudad, queremos saber si los eventos están ordenados en forma correcta, esto implica que 
el costo de vida al aplicar cada evento se va incrementando respecto al anterior evento. Debe haber al menos 
un evento para dicho año.
-}

ordenadosPor :: Ord b => (a -> b) -> [a] -> Bool
ordenadosPor _  [] = False
ordenadosPor _  [_] = True
ordenadosPor transformar  (x:y:xs) =
   transformar x < transformar y && ordenadosPor transformar  (y:xs)

eventosOrdenados :: Año -> Ciudad -> Bool
eventosOrdenados (Año _ eventos) ciudad = ordenadosPor (\evento -> costoDeVida  (evento ciudad)) eventos


{- 2.2 Ciudades ordenadas
Dado un evento y una lista de ciudades, queremos saber si esa lista está ordenada. Esto implica que el costo 
de vida al aplicar el evento sobre cada una de las ciudades queda en orden creciente. Debe haber al menos 
una ciudad en la lista.
-}

ciudadesOrdenadas :: Evento -> [Ciudad] -> Bool
ciudadesOrdenadas evento = ordenadosPor (costoDeVida . evento)

{- 2.3 Años ordenados
Dada una lista de años y una ciudad, queremos saber si el costo de vida al aplicar todos los eventos de cada 
año sobre esa ciudad termina generando una serie de costos de vida ascendente (de menor a mayor). Debe haber 
al menos un año en la lista.
-}

añosOrdenados :: [Año] -> Ciudad -> Bool
añosOrdenados años ciudad = ordenadosPor (\ año -> costoDeVida (pasoDeUnAño año ciudad))  años


{- ¿Puede haber un resultado posible para la función del punto 2.1 (eventos ordenados) para el año 2024? 
Si. Si bien la lista de eventos es 
infinita, lo que nos interesa saber es si el costo de vida va aumentando a medida que vamos aplicandole los eventos a la ciudad y esto se 
cumple hasta que aplicamos la remodelacion en 1% ya que por ejemplo en la ciudad Azul pasa de un costo de vida de 209 a 191.9 por lo que
podriamos afimar que no es creciente y devolver False.Applicative

¿Puede haber un resultado posible para la función del punto 2.2 (ciudades ordenadas) para la lista “disco rayado”?
Si. Con solo pasarle el evento de Crisis el costo de vida deja de ser creciente al aplicarle dicho evento a las ciudades de Azul y Nullish,
por lo que ya con eso podemos devolver False sin necesidades de intercalar Caleta Oliva y Baradero infinitamente.

¿Puede haber un resultado posible para la función del punto 2.3 (años ordenados) para una lista infinita de años?
Si. Si definimos por ejemplo una lista que cicle el 2015, 2022, 2021 y 2023, ya en el segundo año el costo de vida no crece por lo que
podriamos afirmar que no esta en orden ascendente y devolver False.
 -}