import Text.Show.Functions
import Data.List

data Elemento = Elemento { 
    tipo :: String,
    ataque :: Efecto,
    defensa :: Efecto
} deriving (Show)

data Personaje = Personaje { 
    nombre :: String,
    salud:: Float,
    elementos :: [Elemento],
    anioPresente :: Int 
} deriving (Show)

concentracion :: Int -> Elemento
concentracion nivelDeConcentracion = Elemento {
  tipo = "Magia",
  defensa = aplicarMeditarNVeces nivelDeConcentracion
}

aplicarMeditarNVeces :: Int -> Personaje -> Personaje
aplicarMeditarNVeces 0 personaje = personaje
aplicarMeditarNVeces n personaje = aplicarMeditarNVeces (n - 1) (meditar personaje)

type Efecto = Personaje -> Personaje

modificarSalud :: Float -> Efecto
modificarSalud valor personaje = personaje {salud = max 0 (salud personaje + valor)} 

mandarAlAnio :: Int -> Efecto
mandarAlAnio anio personaje = personaje {anioPresente = anio}

meditar :: Efecto
meditar personaje = modificarSalud (salud personaje / 2) personaje

causarDaño :: Float -> Efecto
causarDaño valor = modificarSalud (-valor) 

esMalvado :: Personaje -> Bool
esMalvado personaje = any(\elemento -> tipo elemento == "Maldad") (elementos personaje)

danioQueProduce :: Personaje -> Elemento -> Float
danioQueProduce personaje elemento = salud personaje - salud (ataque elemento personaje)

enemigosMortales :: Personaje -> [Personaje] -> [Personaje]
enemigosMortales personaje = filter( any (\ elemento -> salud (ataque elemento personaje) == 0) . elementos)






