import Text.Show.Functions
import Data.List


data Persona = Persona {
    edad :: Int,
    items :: [String],
    experiencia :: Int
} deriving (Show, Eq)

data Criatura = Criatura {
    nombre :: String,
    peligrosidad :: Int, 
    puedeDeshacerse :: Persona -> Bool
} deriving (Show)

dipper :: Persona
dipper = 
    Persona {
        edad = 12,
        items = ["soplador de hojas"],
        experiencia = 0
    }
siempreDetras :: Criatura
siempreDetras =
      Criatura { nombre = "siempredetras",
      peligrosidad = 0,
      puedeDeshacerse = (\_ -> False) }

gnomos :: Int -> Criatura
gnomos cantidad =
      Criatura { nombre = "gnomos",
      peligrosidad = 2 ^ cantidad,
      puedeDeshacerse = tieneItem "soplador de hojas" }

fantasma :: Int -> (Persona -> Bool) -> Criatura
fantasma categoria asuntoPendiente =
      Criatura { nombre = "fantasma",
      peligrosidad = categoria * 20,
      puedeDeshacerse = asuntoPendiente }

tieneItem :: String -> Persona -> Bool
tieneItem item persona = item `elem` items persona 

modificarExp :: Int -> Persona -> Persona
modificarExp cantidad persona = persona {experiencia = experiencia persona + cantidad}

enfrentar :: Persona -> Criatura -> Persona
enfrentar persona criatura
    | puedeDeshacerse criatura persona = modificarExp (peligrosidad criatura) persona
    | otherwise = modificarExp 1 persona

cuantaExpGana :: Persona -> [Criatura] -> Int
cuantaExpGana persona = experiencia . foldl enfrentar persona

listaDeConsulta :: [Criatura]
listaDeConsulta = 
    [siempreDetras, gnomos 10, fantasma 3 (\ persona -> edad persona < 12 && "disfraz de oveja" `elem` items persona), fantasma 1 (\persona -> experiencia persona > 10)] -- Gana 1046

---------------------------------------------------------------------SEGUNDA PARTE---------------------------------------------------------------------------
zipWithIf :: (a -> b -> b) -> (b -> Bool) -> [a] -> [b] -> [b] 
zipWithIf _ _ [] _ = []
zipWithIf _ _ _ [] = []
zipWithIf funcion condicion (x : xs) (y : ys) 
    | condicion y = funcion x y : zipWithIf funcion condicion xs ys
    | otherwise = y : zipWithIf funcion condicion (x :xs) ys

abecedarioDesde :: Char -> [Char]
abecedarioDesde letra = take 26 $ dropWhile (/= letra) ['a'..'z'] ++ ['a'..'z']

position :: Char -> Int
position c = fromEnum c - fromEnum 'a'

charAtPosition :: Int -> Char
charAtPosition n = toEnum (n + fromEnum 'a')

desencriptarLetra :: Char -> Char -> Char
desencriptarLetra clave letra = charAtPosition ((position letra - position clave + 26) `mod` 26)

