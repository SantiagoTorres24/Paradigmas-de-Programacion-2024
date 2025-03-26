import Text.Show.Functions
import Data.List

data Guantelete = Guantelete {
    material :: String,
    gemas :: [Gema]
} deriving (Show)

data Personaje = Personaje {
    edad :: Int,
    energia :: Int,
    habilidades :: [String],
    nombre :: String,
    planeta :: String
} deriving (Show)

data Universo = Universo{
    habitantes :: [Personaje]
} deriving (Show)

ironMan :: Personaje
ironMan = Personaje 45 100 ["tecnología", "fuerza"] "Iron Man" "Tierra"

drStrange :: Personaje
drStrange = Personaje 40 80 ["magia", "inteligencia"] "Doctor Strange" "Tierra"

groot :: Personaje
groot = Personaje 25 90 ["fuerza", "regeneración"] "Groot" "Planta X"

wolverine :: Personaje
wolverine = Personaje 137 95 ["regeneración", "garras"] "Wolverine" "Tierra"

viudaNegra :: Personaje
viudaNegra = Personaje 34 85 ["espionaje", "artes marciales"] "Viuda Negra" "Tierra"

unUniverso :: Universo
unUniverso = Universo [ironMan, drStrange, groot, wolverine, viudaNegra]

guanteleteCompleto :: Guantelete -> Bool
guanteleteCompleto guantelete = length (gemas guantelete) == 6 && material guantelete == "uru"

chasquidoUniverso :: Guantelete -> Universo -> Universo
chasquidoUniverso guantelete universo 
 | guanteleteCompleto guantelete = Universo (take (length (habitantes universo) `div` 2) (habitantes universo))
 | otherwise = universo 

aptoParaPendex :: Universo -> Bool
aptoParaPendex (Universo habitantes) = any (\ personaje -> edad personaje < 45) habitantes

energiaTotal :: Universo -> Int
energiaTotal (Universo habitantes) = (sum . map energia . filter(\ personaje -> length (habilidades personaje) > 1)) habitantes

type Gema = Personaje -> Personaje

disminuirEnergia :: Int -> Gema
disminuirEnergia valor personaje = personaje {energia = max 0 (energia personaje - valor)}

eliminarHabilidad :: String -> Gema
eliminarHabilidad habilidad personaje 
 | not (null (habilidades personaje)) = personaje { habilidades = delete habilidad (habilidades personaje)}
 | otherwise = personaje

gemaMente :: Int -> Gema
gemaMente  = disminuirEnergia  

gemaAlma :: String -> Gema
gemaAlma habilidad = eliminarHabilidad habilidad . disminuirEnergia 10

gemaEspacio :: String -> Gema
gemaEspacio nuevoPlaneta personaje = disminuirEnergia 20 (personaje { planeta = nuevoPlaneta })

gemaPoder :: Gema
gemaPoder personaje 
 | length (habilidades personaje) <= 2 = personaje { energia = 0, habilidades = []}
 | otherwise = personaje { energia = 0}

gemaTiempo :: Gema
gemaTiempo personaje = personaje { edad = max 18 (div (edad personaje) 2)}

gemaLoca :: Gema -> Personaje -> Personaje
gemaLoca gema  = gema . gema

guanteleteGoma :: Guantelete
guanteleteGoma = Guantelete "goma" [gemaTiempo, gemaAlma "usar Mjolnir", gemaLoca  (gemaAlma "programación en Haskell")]

utilizar :: [Gema] -> Personaje -> Personaje
utilizar gemas personaje = foldl (\ personaje gema -> gema personaje) personaje gemas 