import Text.Show.Functions
import Data.List

data Animal = Animal {
    nombre :: String,
    tipo :: String,
    peso :: Float,
    edad :: Int,
    estaEnfermo :: Bool,
    visita :: Veterinaria
} deriving (Show)

data Veterinaria = Veterinaria {
    recuperacion :: Int,
    costo :: Float
} deriving (Show)

animalEjemplo :: Animal
animalEjemplo = Animal "Animal1" "Vaca" 100 10 True (Veterinaria 0 0)

laPasoMal :: Animal -> Bool
laPasoMal animal = recuperacion (visita animal) >= 30 

nombreFalopa :: Animal -> Bool
nombreFalopa animal = last (nombre animal) == 'i'

type Actividad = Animal -> Animal

modificarPeso :: Float -> Animal -> Animal
modificarPeso valor animal = animal {peso = peso animal + valor}

engorde :: Float -> Actividad
engorde alimento  = modificarPeso (min 5 (alimento / 2))  

revisacion :: Int -> Float -> Actividad
revisacion diasRecuperacionVisita costoVisita animal
    | estaEnfermo animal = engorde 2 animal {visita = Veterinaria diasRecuperacionVisita costoVisita}
    | otherwise = animal

festejoCumple :: Actividad
festejoCumple animal = modificarPeso (-1) animal {edad = edad animal + 1}

chequeoDePeso :: Float -> Actividad
chequeoDePeso pesoParametro animal
    | peso animal >= pesoParametro = animal 
    | otherwise = animal {estaEnfermo = True}

elProceso :: [Actividad] -> Animal -> Animal
elProceso actividades animal = foldl (\animal actividad -> actividad animal) animal actividades 

listaActividades :: [Actividad]
listaActividades = [engorde 5, revisacion 10 20, festejoCumple, chequeoDePeso 50]

--ghci> elProceso listaActividades animalEjemplo
--Animal {nombre = "Animal1", tipo = "Vaca", peso = 102.5, edad = 11, estaEnfermo = True, visita = Veterinaria {recuperacion = 10, costo = 20.0}}

mejoraDePeso :: [Actividad] -> Animal -> Bool
mejoraDePeso [] _ = False
mejoraDePeso [_] _ = True
mejoraDePeso (a1: a2 : as) animal =
    peso (a1 animal) < peso (a2 animal) && mejoraDePeso (a2 : as) animal

primeros3ConNombreFalopa :: [Animal] -> [Animal]
primeros3ConNombreFalopa = take 3 . filter nombreFalopa 
