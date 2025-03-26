import Text.Show.Functions
import Data.List

data Aspecto = Aspecto {
  tipoDeAspecto :: String,
  grado :: Float
} deriving (Show, Eq)

tension :: Aspecto
tension = Aspecto "Tension" 50

peligro :: Aspecto
peligro = Aspecto "Peligro" 100

incertidumbre :: Aspecto
incertidumbre = Aspecto "Incertidumbre" 20

type Situacion = [Aspecto]

situacion1 :: Situacion
situacion1 = [tension, peligro, incertidumbre]

mejorAspecto :: Aspecto -> Aspecto -> Bool
mejorAspecto mejor peor = grado mejor < grado peor

mismoAspecto :: Aspecto -> Aspecto -> Bool
mismoAspecto aspecto1 aspecto2 = tipoDeAspecto aspecto1 == tipoDeAspecto aspecto2

buscarAspecto :: Aspecto -> [Aspecto] -> Aspecto
buscarAspecto aspectoBuscado = head.filter (mismoAspecto aspectoBuscado)

buscarAspectoDeTipo :: String -> [Aspecto] -> Aspecto
buscarAspectoDeTipo tipo = buscarAspecto (Aspecto tipo 0)

reemplazarAspecto :: Aspecto -> [Aspecto] -> [Aspecto]
reemplazarAspecto aspectoBuscado situacion =
    aspectoBuscado : (filter (not.mismoAspecto aspectoBuscado) situacion)

modificarAspecto :: (Float -> Float) -> Aspecto -> Aspecto
modificarAspecto funcion aspecto = aspecto {grado = funcion (grado aspecto)}

modificarAspecto' :: Float -> Aspecto -> Aspecto
modificarAspecto' valor aspecto = aspecto {grado = grado aspecto - valor}

saberSiSituacionEsMejor :: Situacion -> Situacion -> Bool
saberSiSituacionEsMejor situacion1 situacion2 = 
    all (\aspecto1 -> mejorAspecto aspecto1 (buscarAspecto aspecto1 situacion2)) situacion1

modificarSituacion :: String -> Situacion -> Situacion
modificarSituacion tipo situacion = reemplazarAspecto (buscarAspectoDeTipo tipo situacion) situacion 

----------------------------------------------------GEMAS-----------------------------------------------------------------------------------------------
data Gema = Gema {
    nombre :: String,
    fuerza :: Float,
    personalidad :: Personalidad
} deriving (Show)

type Personalidad = Situacion -> Situacion

restarValor :: Float -> Float -> Float
restarValor valor actual = actual - valor

vidente :: Personalidad
vidente situacion = reemplazarAspecto aspectoActualizado situacion
  where
    aspectoActualizado = modificarAspecto' 10 (buscarAspectoDeTipo "Incertidumbre" situacion)










