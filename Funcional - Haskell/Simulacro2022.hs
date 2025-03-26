import Text.Show.Functions
import Data.List

data Juguete = Juguete {
    nombre :: String,
    dueño :: String, 
    facha :: Float,
    accesorios :: [Accesorio],
    estaVivo :: Bool
} deriving (Show)

data Accesorio = Accesorio {
    efecto :: Efecto,
    eficacia :: Float
} deriving (Show)


type Efecto = Juguete -> Juguete

modificarFacha :: Float -> Efecto
modificarFacha cantidad juguete = juguete {facha = facha juguete + 10 + cantidad }

lucirAmenazante :: Float -> Efecto
lucirAmenazante eficacia = modificarFacha (10 + eficacia)

vieneAndy :: Efecto
vieneAndy juguete = juguete {estaVivo = False}

cambiarNombre :: String -> Efecto
cambiarNombre nombreNuevo juguete = juguete {nombre = nombreNuevo}

largoNombre :: Juguete -> Float
largoNombre = fromIntegral . length . nombre

masSteel :: Float -> Efecto
masSteel eficacia juguete = cambiarNombre "Max Steel" . modificarFacha (largoNombre juguete * eficacia) $ juguete

quemadura :: Float -> Float -> Efecto
quemadura eficacia gradoQuemadura = modificarFacha valorADisminuir
    where valorADisminuir = - (gradoQuemadura * (eficacia + 2))

serpienteEnBota :: Accesorio
serpienteEnBota = Accesorio {
    efecto = lucirAmenazante 2,
    eficacia = 2 }

radio :: Accesorio
radio = Accesorio {
    efecto = vieneAndy,
    eficacia = 3
}

arma :: Float -> Accesorio
arma eficacia = Accesorio {
    efecto = masSteel eficacia,
    eficacia = eficacia
}

revolver :: Accesorio
revolver = arma 5

escopeta :: Accesorio
escopeta = arma 20

lanzaLlamas :: Accesorio
lanzaLlamas = Accesorio {
    efecto = quemadura 8.5 3,
    eficacia = 8.5
}

woody :: Juguete
woody = Juguete {
    nombre = "Woody",
    dueño = "Andy",
    facha = 100,
    estaVivo = True,
    accesorios = [serpienteEnBota, revolver]
}

soldado :: Juguete
soldado = Juguete {
    nombre = "Soldado",
    dueño = "Andy",
    facha = 5,
    estaVivo = True,
    accesorios = [lanzaLlamas, radio]
}

barbie :: Juguete
barbie = Juguete {
    nombre = "Barbie",
    dueño = "dany",
    facha = 95.5,
    estaVivo = False,
    accesorios = [lanzaLlamas, escopeta, revolver]
}

esImpaktante :: Juguete -> Bool
esImpaktante juguete = any ((>10) . eficacia) (accesorios juguete)

esDisxelico :: Juguete -> Bool
esDisxelico juguete = tieneEnDesorden "andy" (dueño juguete)

tieneEnDesorden :: String -> String -> Bool
tieneEnDesorden letras nombre =  length letras == length nombre && all (\letra -> letra `elem` letras) nombre && letras /= nombre

cuantosHay ::  (Juguete -> Bool) -> [Juguete] -> Int
cuantosHay condicion  = length . filter condicion 

cuantosHayImpaktantes :: [Juguete] -> Int
cuantosHayImpaktantes  = cuantosHay esImpaktante 

cuantosHayDisxelicos :: [Juguete] -> Int
cuantosHayDisxelicos = cuantosHay (\ juguete -> esDisxelico juguete && estaVivo juguete == False) 

cuantosHayTamañoNombre :: [Juguete] -> Int
cuantosHayTamañoNombre = cuantosHay ((>6) . length . nombre)

aplicarAccesorio :: Juguete -> Accesorio -> Juguete
aplicarAccesorio juguete accesorio = efecto accesorio juguete