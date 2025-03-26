import Text.Show.Functions
import Data.List

data Persona = Persona {
    nombre :: String,
    dinero :: Float,
    suerte :: Int,
    factores :: [(String, Int)]
} deriving (Show)

data Juego = Juego {
    nombreJuego :: String,
    dineroGanado :: Persona -> Float -> [Persona -> Bool] -> Float,
    criteriosGanar :: [Criterio]
} deriving (Show)

nico :: Persona
nico = Persona "Nico" 100.0 30 [("amuleto", 3), ("manos magicas",100)]

maiu :: Persona
maiu = Persona "Maiu" 100.0 42 [("inteligencia",55), ("paciencia",50)]

type Criterio = Persona -> Bool

suerteTotal :: Persona -> Int
suerteTotal persona 
    | not(null amuletos) = suerte persona * snd (head amuletos)
    | otherwise = suerte persona
    
    where
        amuletos = filter (\(factor, valor) -> factor == "amuleto" && valor > 0) (factores persona)

suertuda :: Int -> Criterio
suertuda suerte persona = suerteTotal persona > suerte

paciencia :: Criterio
paciencia persona = any (\(factor, valor) -> factor == "paciencia") (factores persona)

ruleta :: Juego
ruleta = Juego "Ruleta" calcularGananciaRuleta [suertuda 80]

calcularGananciaRuleta :: Persona -> Float -> [Criterio] -> Float
calcularGananciaRuleta persona apuesta criterios
    | suertuda 80 persona = apuesta * 37
    | otherwise = 0  

maquinita :: Float -> Juego
maquinita jackpot = Juego "Maquinita" (calcularGananciaMaquinita jackpot) [suertuda 95, paciencia]

calcularGananciaMaquinita :: Float -> Persona -> Float -> [Criterio] -> Float
calcularGananciaMaquinita jackpot persona apuesta criterios
    | suertuda 95 persona && paciencia persona = apuesta + jackpot
    | otherwise = 0

puedeGanar :: Juego -> Persona -> Bool
puedeGanar juego persona = all (\criterio -> criterio persona) (criteriosGanar juego)

obtenerGananciaTotalRec :: Persona -> Float -> [Juego] -> Float
obtenerGananciaTotalRec persona apuestaInicial [] = apuestaInicial
obtenerGananciaTotalRec persona apuestaInicial (juego:juegos) =
  obtenerGananciaTotalRec persona (bool apuestaInicial (dineroGanado juego persona apuestaInicial (criteriosGanar juego)) (puedeGanar juego persona)) juegos
  where
    bool f g True = g
    bool f g False = f

obtenerGananciaTotal' :: Persona -> Float -> [Juego] -> Float
obtenerGananciaTotal' persona apuestaInicial [] = apuestaInicial
obtenerGananciaTotal' persona apuestaInicial (juego:juegos)
  | puedeGanar juego persona = obtenerGananciaTotal' persona (dineroGanado juego persona apuestaInicial (criteriosGanar juego)) juegos
  | otherwise = obtenerGananciaTotal' persona apuestaInicial juegos

jugadoresQueNoPuedenGanar :: [Persona] -> [Juego] -> [String]
jugadoresQueNoPuedenGanar jugadores juegos = 
  map nombre (filter (\jugador -> not (any (`puedeGanar` jugador) juegos)) jugadores)

apostarYJugar :: Persona -> Float -> Juego -> Persona
apostarYJugar persona cantidad juego
  | puedeGanar juego persona = persona { dinero = dinero persona - cantidad + dineroGanado juego persona cantidad (criteriosGanar juego) }
  | otherwise = persona { dinero = dinero persona - cantidad }
