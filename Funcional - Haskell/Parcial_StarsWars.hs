import Text.Show.Functions
import Data.List

data Nave = Nave {
    nombre :: String,
    durabilidad :: Int,
    escudo :: Int,
    ataque :: Int,
    poder :: Nave -> Nave
} deriving (Show)

type Poder = Nave -> Nave

nave1 :: Nave
nave1 = Nave "TIE Fighter" 200 100 50 turbo

nave2 :: Nave
nave2 = Nave " X Wing" 300 150 100 reparacionEmergencia

nave3 :: Nave
nave3 = Nave "Nave de Darth Vader" 500 300 200 superTurbo

nave4 :: Nave
nave4 = Nave "Millenium Falcon" 1000 500 50000 (reparacionEmergencia . modificarEscudo 100)

naveInventada :: Nave
naveInventada = Nave "Nave Pt" 1 1 1 (modificarAtaque 1 . modificarDurabilidad 1)

listaNaves :: [Nave]
listaNaves = [nave1, nave2, nave3, nave4, naveInventada]

modificarDurabilidad :: Int -> Poder
modificarDurabilidad valor nave = nave {durabilidad = max 0 (durabilidad nave + valor)}

modificarAtaque :: Int -> Poder
modificarAtaque valor nave = nave {ataque = max 0 (ataque nave + valor)}

modificarEscudo :: Int -> Poder
modificarEscudo valor nave = nave {escudo = max 0 (escudo nave + valor)}

turbo :: Poder 
turbo = modificarAtaque 25

reparacionEmergencia :: Poder
reparacionEmergencia = modificarAtaque (-30) . modificarDurabilidad 50 

superTurbo :: Poder
superTurbo = modificarDurabilidad (-45) . turbo . turbo . turbo

durabilidadTotal :: [Nave] -> Int
durabilidadTotal = sum . map durabilidad

naveAtacada :: Nave -> Nave -> Nave
naveAtacada n1 n2 = modificarDurabilidad (-(dañoRecibido (activarPoder n1) (activarPoder n2))) n1

activarPoder :: Nave -> Nave
activarPoder nave = poder nave nave

dañoRecibido :: Nave -> Nave -> Int
dañoRecibido n1 n2 
    | escudo n1 > ataque n2 = 0
    | otherwise = ataque n2 - escudo n1

naveFueraDeCombate :: Nave -> Bool
naveFueraDeCombate nave = durabilidad nave == 0

type Estrategia = [Nave] -> [Nave]

navesDebiles :: Estrategia
navesDebiles = filter (\nave -> escudo nave < 200)

navesConCiertaPeligrosidad :: Int -> Estrategia
navesConCiertaPeligrosidad peligrosidad = filter(\nave -> ataque nave >= peligrosidad)

navesQueQuedarianFueraDeCombate :: Estrategia
navesQueQuedarianFueraDeCombate = filter naveFueraDeCombate

estrategiaInventada :: Estrategia
estrategiaInventada = filter(\nave -> durabilidad nave <= 50)

misionSorpresa :: Nave -> Estrategia -> [Nave] -> [Nave]
misionSorpresa nave estrategia naves = naveVsNaves nave (estrategia naves)

naveVsNaves :: Nave -> [Nave] -> [Nave]
naveVsNaves _ [] = []
naveVsNaves nave (n1 : ns) =
    naveAtacada n1 nave : naveVsNaves nave ns

cualMinimiazaDurabilidad :: Estrategia -> Estrategia -> Nave -> [Nave] -> [Nave]
cualMinimiazaDurabilidad estrategia1 estrategia2 nave naves 
    | durabilidadTotal (estrategia1 naves) < durabilidadTotal (estrategia2 naves) = misionSorpresa nave estrategia1 naves
    | otherwise = misionSorpresa nave estrategia2 naves

flotaInfinita :: [Nave]
flotaInfinita = cycle [nave1, nave4]