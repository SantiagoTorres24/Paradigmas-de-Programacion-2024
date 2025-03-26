import Text.Show.Functions
import Data.List


data Pais = Pais {
    ipc :: Float,
    poblacionPublico :: Float,
    poblacionPrivado :: Float,
    recursosNaturales :: [String],
    deuda :: Float
} deriving (Show, Eq, Ord)


nambia :: Pais
nambia = Pais 4140 400000 650000 ["Mineria", "Ecoturismo"] 50000000

prestarMillones :: Float -> Pais -> Pais
prestarMillones n pais = pais { deuda = deuda pais + n * 2.5}

reducirTrabajos :: Float -> Pais -> Pais
reducirTrabajos x pais 
 | poblacionPublico pais > 100 = pais {poblacionPublico = poblacionPublico pais - x, ipc = ipc pais - ipc pais * 0.2 }
 | otherwise = pais {ipc = ipc pais - ipc pais * 0.15 }

explotarRecurso :: String -> Pais -> Pais
explotarRecurso recurso pais = pais {deuda = deuda pais - 2000000, recursosNaturales = filter (/= recurso) (recursosNaturales pais)}

calcularPBI :: Pais -> Float
calcularPBI pais = ipc pais * (poblacionPrivado pais + poblacionPublico pais)

blindaje :: Pais -> Pais
blindaje pais = pais {deuda = deuda pais + calcularPBI pais / 2, poblacionPublico = poblacionPublico (reducirTrabajos 500 pais)}

prestarYExplotar :: Float -> String -> Pais -> Pais
prestarYExplotar prestamo recurso = prestarMillones prestamo . explotarRecurso recurso

-- ghci> prestarYExplotar 200 "Mineria"  nambia
-- Pais {ipc = 4140.0, poblacionPublico = 400000.0, poblacionPrivado = 650000.0, recursosNaturales = ["Ecoturismo"], deuda = 4.80005e7}
-- Se genera efecto colateral cuando con prestarMillones sumamos deuda modificando el valor de deuda del pais y luego le restamos

zafar :: [Pais] -> [Pais]
zafar = filter (\ pais -> "Petroleo" `elem` recursosNaturales pais) 

deudaAFavor :: [Pais] -> Float
deudaAFavor  = sum . map deuda 

data Receta = PrestarMillones Float | ReducirTrabajar Float | ExplotarRecurso String | Blindaje

aplicarReceta :: Pais -> Receta -> Pais
aplicarReceta pais (PrestarMillones prestamo) = prestarMillones prestamo pais
aplicarReceta pais (ReducirTrabajar trabajos) = reducirTrabajos trabajos pais
aplicarReceta pais (ExplotarRecurso recurso) = explotarRecurso recurso pais
aplicarReceta pais Blindaje = blindaje pais

pbiOrdenado :: Pais -> [Receta] -> Bool
pbiOrdenado _ [] = False
pbiOrdenado _ [_] = True
pbiOrdenado pais (receta1 : receta2 : restoRecetas) = 
    calcularPBI (aplicarReceta pais receta1) < calcularPBI (aplicarReceta pais receta2) && pbiOrdenado pais (receta2 : restoRecetas)

