import Text.Show.Functions
import Data.List

data Persona = Persona {
    nombre :: String,
    recuerdos :: [String]
} deriving (Show)

suki :: Persona
suki = Persona {
nombre = "Susana Kitimporta",
recuerdos = ["abuelita", "escuela primaria", "examen aprobado","novio"]}

intercambiar :: Int -> Int -> [String] -> [String]
intercambiar i j xs = zipWith select [0..] xs
  where
    select k x
      | k == i = xs !! j
      | k == j = xs !! i
      | otherwise = x

reemplazarEnLista :: Int -> String -> [String] -> [String]
reemplazarEnLista n val lst = take n lst ++ [val] ++ drop (n + 1) lst

quitarElemento :: String -> [String] -> [String]
quitarElemento string = filter(/= string)

type Pesadilla = Persona -> Persona

mover :: Int -> Int -> Pesadilla
mover posicion1 posicion2 persona = persona {recuerdos = intercambiar posicion1 posicion2 (recuerdos persona)}

reemplazar :: Int -> String -> Pesadilla
reemplazar posicion nuevoRecuerdo persona = persona {recuerdos = reemplazarEnLista posicion nuevoRecuerdo (recuerdos persona)}

quitar :: String -> Pesadilla
quitar recuerdo persona = persona {recuerdos = quitarElemento recuerdo (recuerdos persona) }

invertir :: Pesadilla
invertir persona = persona {recuerdos = reverse (recuerdos persona)}

nop :: Pesadilla
nop = id

nuevaPesadilla :: String -> Persona -> Persona
nuevaPesadilla palabra (Persona nombre recuerdos) = Persona nombre (map (\recuerdo -> recuerdo ++ " " ++ palabra) recuerdos)

nocheDePesadillas :: Persona -> [Pesadilla] -> Persona
nocheDePesadillas = foldl (\persona pesadilla -> pesadilla persona)

type Situacion = [Pesadilla] -> Persona -> Bool

segmentation :: Situacion
segmentation pesadillas persona = length pesadillas > length (recuerdos persona)

bugInicial :: Situacion
bugInicial pesadillas persona = recuerdos (head pesadillas persona) /= recuerdos persona

falsaAlarma :: Situacion
falsaAlarma pesadillas persona = recuerdos (nocheDePesadillas persona pesadillas) == recuerdos persona

detectarSituacion :: Situacion -> [Pesadilla] -> [Persona] -> Int
detectarSituacion situacion pesadillas personas = length (filter (situacion pesadillas) personas)

situacionEnTodas :: Situacion -> [Pesadilla] -> [Persona] -> Bool
situacionEnTodas situacion pesadillas = all (situacion pesadillas)
