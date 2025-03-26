import Text.Show.Functions
import Data.List


-- Modelo inicial
data Jugador = Jugador {
  nombre :: String,
  padre :: String,
  habilidad :: Habilidad
} deriving (Eq, Show)

data Habilidad = Habilidad {
  fuerzaJugador :: Int,
  precisionJugador :: Int
} deriving (Eq, Show)

-- Jugadores de ejemplo
bart = Jugador "Bart" "Homero" (Habilidad 25 60)
todd = Jugador "Todd" "Ned" (Habilidad 15 80)
rafa = Jugador "Rafa" "Gorgory" (Habilidad 10 1)

data Tiro = Tiro {
  velocidad :: Int,
  precision :: Int,
  altura :: Int
} deriving (Eq, Show)

type Puntos = Int

-- Funciones útiles
between n m x = elem x [n .. m]

maximoSegun :: (Ord b) => (a -> b) -> [a] -> a
maximoSegun f = foldl1 (mayorSegun f)
mayorSegun :: Ord x => (t -> x) -> (t -> t -> t)
mayorSegun f a b
  | f a > f b = a
  | otherwise = b


-- 1A)
type Palo = Habilidad -> Tiro

putter :: Palo
putter habilidad = Tiro {
    velocidad = 10,
    precision = precisionJugador habilidad * 2,
    altura = 0
}

madera :: Palo
madera habilidad  = Tiro {
    velocidad = 100,
    precision = div (precisionJugador habilidad)  2,
    altura = 5
}

hierros :: Int -> Palo
hierros n habilidad = Tiro {
    velocidad = fuerzaJugador habilidad * n,
    precision = div (precisionJugador habilidad) n,
    altura = max 0 (n - 3)
}

-- 1B)
palos :: [Palo]
palos = [putter , madera] ++ map hierros [1..10] 

-- 2)
golpe :: Jugador -> Palo -> Tiro
golpe jugador palo = (palo . habilidad) jugador

-- 3A)
data Obstaculo = Obstaculo{
  puedeSuperar :: Tiro -> Bool,
  supero :: Tiro -> Tiro
}

intentarSuperarObstaculo :: Obstaculo -> Tiro -> Tiro 
intentarSuperarObstaculo obstaculo tiro
 | puedeSuperar obstaculo tiro = supero obstaculo tiro
 | otherwise = tiroDetenido 

vaAlRasDelSuelo = (==0) . altura 
tunel :: Obstaculo
tunel = Obstaculo superaTunel superoTunel 
   

superaTunel :: Tiro -> Bool
superaTunel tiro = precision tiro > 90 && vaAlRasDelSuelo tiro

superoTunel :: Tiro -> Tiro
superoTunel tiro = tiro {
    velocidad = velocidad tiro * 2,
    precision = 100,
    altura = 0
}

tiroDetenido :: Tiro
tiroDetenido = Tiro 0 0 0

-- 3B)
laguna :: Int -> Obstaculo
laguna largoLaguna = Obstaculo superaLaguna (superoLaguna largoLaguna)

superaLaguna :: Tiro -> Bool
superaLaguna tiro = velocidad tiro > 80 && between 1 5 (altura tiro)

superoLaguna :: Int -> Tiro -> Tiro
superoLaguna largoLaguna tiro = tiro { altura = div (altura tiro) largoLaguna }

-- 3C)
hoyo :: Obstaculo
hoyo = Obstaculo superaHoyo superoHoyo

superaHoyo :: Tiro -> Bool
superaHoyo tiro = precision tiro > 95 && between 5 20 (velocidad tiro) && vaAlRasDelSuelo tiro

superoHoyo _ = tiroDetenido

-- 4A)
palosUtiles :: Jugador -> Obstaculo -> [Palo]
palosUtiles jugador obstaculo = filter (sirvenParaSuperar jugador obstaculo) palos

sirvenParaSuperar :: Jugador -> Obstaculo -> Palo -> Bool
sirvenParaSuperar jugador obstaculo palo = puedeSuperar obstaculo (golpe jugador palo)

-- 4B)
cuantosObstaculosSupera :: Tiro -> [Obstaculo] -> Int 
cuantosObstaculosSupera tiro [] = 0
cuantosObstaculosSupera tiro (obstaculo : obstaculos)
 | puedeSuperar obstaculo tiro = 1 + cuantosObstaculosSupera (supero obstaculo tiro) obstaculos
 | otherwise = 0

-- 4C)
paloMasUtil :: Jugador -> [Obstaculo] -> Palo
paloMasUtil jugador obstaculos = maximoSegun (flip cuantosObstaculosSupera obstaculos . golpe jugador) palos


-- 5) 
torneoFinalizado :: [(Jugador, Puntos)] -> [String]
torneoFinalizado puntos = (map (padre.fst) . filter (not. gano puntos)) puntos

gano :: [(Jugador, Puntos)] -> (Jugador, Puntos) -> Bool
gano puntos puntosUnJugador = (all ((<snd puntosUnJugador). snd) 
 . filter (/= puntosUnJugador)) puntos

