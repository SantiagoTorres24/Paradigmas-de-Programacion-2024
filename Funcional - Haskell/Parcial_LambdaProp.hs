import Text.Show.Functions
import Data.List

type Barrio = String
type Mail = String
type Requisito = Dpto -> Bool
type Busqueda = [Requisito]

data Dpto = Dpto {
    ambientes :: Int,
    superficie :: Int,
    precio :: Int,
    barrio :: Barrio
} deriving (Show, Eq)

data Persona = Persona {
    mail :: Mail,
    busquedas :: [Busqueda]
} deriving (Show)

ordenarSegun _ [] = []
ordenarSegun criterio (x:xs) = 
    (ordenarSegun criterio . filter (not . criterio x)) xs++ 
    [x] ++
    (ordenarSegun criterio . filter (criterio x)) xs

between cotaInferior cotaSuperior valor =
    valor <= cotaSuperior && valor >= cotaInferior

dpto1 :: Dpto
dpto1 = Dpto 3 80 7500 "Palermo"

dpto2 :: Dpto
dpto2 = Dpto 1 45 3500 "Villa Urquiza"

dpto3 :: Dpto
dpto3 = Dpto 2 50 5000 "Palermo"

dpto4 :: Dpto
dpto4 = Dpto 1 45 5500 "Recoleta"

listaDptos :: [Dpto]
listaDptos = [dpto1, dpto2, dpto3]

mayor :: Ord b => (a -> b) -> a -> a -> Bool
mayor f valor1 valor2 = f valor1 > f valor2

menor :: Ord b => (a -> b) -> a -> a -> Bool
menor f valor1 valor2 = f valor1 < f valor2

-- ghci> ordenarSegun (mayor length) ["sldskl", "aa", "dkswkdwps", "sddsd", "sfksksksoxks", "j"]
-- ["sfksksksoxks","dkswkdwps","sldskl","sddsd","aa","j"]

ubicadoEn :: Dpto -> [Barrio] -> Bool
ubicadoEn dpto = elem (barrio dpto) 

cumpleRango ::  (Dpto -> Int) -> Dpto -> Int -> Int -> Bool
cumpleRango f dpto n1 n2 = between n1 n2 (f dpto)

cumpleBusqueda :: Busqueda -> Dpto -> Bool
cumpleBusqueda busqueda dpto = all (\ requisito -> requisito dpto) busqueda

buscar :: Ord b => Busqueda -> (Dpto -> b) -> [Dpto] -> [Dpto]
buscar busqueda criterio =
    ordenarSegun (\dpto1 dpto2 -> criterio dpto1 < criterio dpto2) . filter (cumpleBusqueda busqueda)

mailsDePersonasInteresadas :: Dpto -> [Persona] -> [Mail]
mailsDePersonasInteresadas dpto = map mail . filter (any (`cumpleBusqueda` dpto) . busquedas)
