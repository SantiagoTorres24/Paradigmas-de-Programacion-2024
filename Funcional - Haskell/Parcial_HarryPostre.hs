import Text.Show.Functions
import Data.List
import Graphics.Win32 (postThreadMessage)
import Distribution.Simple.Program.HcPkg (list)

data Postre = Postre {
    sabores :: [String],
    peso :: Float,
    temperatura :: Float
} deriving (Show)

instance Eq Postre where
    (==) :: Postre -> Postre -> Bool   
    postre == otroPostre = 
        (sabores postre == sabores otroPostre) &&
        (peso postre == peso otroPostre) &&
        (temperatura postre == temperatura otroPostre)


bizcocho :: Postre 
bizcocho = Postre ["fruta", "crema"] 100 25

tarta :: Postre
tarta = Postre ["melaza"] 50 0

type Hechizo = Postre -> Postre

modificarTemperatura :: Float -> Hechizo
modificarTemperatura valor postre = postre {temperatura = valor}

modificarPeso :: Float -> Hechizo
modificarPeso valor postre = postre {peso = peso postre - (peso postre * valor/100)}

agregarSabor :: String -> Hechizo
agregarSabor saborNuevo postre = postre {sabores = sabores postre ++ [saborNuevo]} 

eliminarSabores :: Postre -> Postre
eliminarSabores postre = postre { sabores = [] }

estaListo :: Postre -> Bool
estaListo postre = peso postre > 0 && not(null (sabores postre)) && temperatura postre > 0

incendio :: Hechizo
incendio postre = (modificarTemperatura (temperatura postre + 1) . modificarPeso 5) postre

immobulus :: Hechizo
immobulus = modificarTemperatura 0

wingardiumLeviosa :: Hechizo
wingardiumLeviosa = agregarSabor "concentrado" . modificarPeso 10

diffindo :: Float -> Hechizo
diffindo = modificarPeso 

ridikulus :: String -> Hechizo
ridikulus saborNuevo = agregarSabor (reverse saborNuevo)

avadaKedavra :: Hechizo
avadaKedavra = immobulus . eliminarSabores

saberSiEstanListos :: [Postre] -> Hechizo -> Bool
saberSiEstanListos postres hechizo = all (estaListo . hechizo) postres

promedioListos :: [Postre] -> Float
promedioListos postres = (sum . map peso . filter estaListo $ postres) / fromIntegral (length postres)

---------------------------------------------------------------MAGOS------------------------------------------------------------------------------
data Mago = Mago {
    nombre :: String,
    hechizos :: [Hechizo],
    cantidadDeHorrorCruxes :: Int
} deriving (Show)

agregarHechizo :: Hechizo -> Mago -> Mago
agregarHechizo hechizo mago = mago {hechizos = hechizos mago ++ [hechizo]}

sumarHorrorcrux :: Mago -> Mago
sumarHorrorcrux mago = mago {cantidadDeHorrorCruxes = cantidadDeHorrorCruxes mago + 1}

practicar :: Postre -> Hechizo -> Mago -> Mago
practicar postre hechizo 
    | hechizo postre == avadaKedavra postre = agregarHechizo hechizo . sumarHorrorcrux
    | otherwise = agregarHechizo hechizo 

maximoSegun :: (a -> Float) -> [a] -> a
maximoSegun f = foldl1 (mayorSegun f)

mayorSegun :: (a -> Float) -> a -> a -> a
mayorSegun f a b
  | f a > f b = a
  | otherwise = b

obtenerMejorHechizo :: Postre -> Mago -> Hechizo
obtenerMejorHechizo postre mago = maximoSegun (fromIntegral . length . sabores . (\hechizo -> hechizo postre)) (hechizos mago)

--------------------------------------------------------INFINITA MAGIA--------------------------------------------------------------------------------
listaPostresInfinita :: [Postre]
listaPostresInfinita = cycle [bizcocho, tarta]

