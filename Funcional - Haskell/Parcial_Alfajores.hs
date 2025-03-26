import Text.Show.Functions
import Data.List


data Alfajor = Alfajor {
    relleno :: [Relleno],
    peso :: Float,
    dulzor :: Float,
    nombre :: String
} deriving (Show, Eq)

data Cliente = Cliente {
    dinero :: Float,
    criterio :: [Alfajor -> Bool],
    cantAlfajores :: [Alfajor]
} deriving (Show)

data Relleno = DulceDeLeche | Mousse | Fruta deriving (Show, Eq)

jorgito :: Alfajor
jorgito = Alfajor [DulceDeLeche] 80 8 "Jorgito"

havanna :: Alfajor
havanna = Alfajor [Mousse, Mousse] 60 12 "Havanna"

capitanDelEspacio :: Alfajor
capitanDelEspacio = Alfajor [DulceDeLeche] 40 12 "Capitan del Espacio"

jorgitito :: Alfajor
jorgitito = abaratarAlfajor jorgito

jorgelin :: Alfajor 
jorgelin = (agregarCapaDeRelleno DulceDeLeche jorgito) {nombre = "Jorgelin"}

capitanDelEspacioCostaACosta :: Alfajor
capitanDelEspacioCostaACosta = (abaratarAlfajor . hacerPremiumNVeces 4 . renombrarAlfajor "Capitan del Espacio de Costa a Costa" ) capitanDelEspacio

emi :: Cliente
emi = Cliente 120 [clienteBuscaMarca "Capital del Espacio"] []

tomi :: Cliente
tomi = Cliente 100 [clientePretencioso, clienteDulcero] []

dante :: Cliente
dante = Cliente 200 [clienteAntiRelleno DulceDeLeche, clienteExtraño] []

juan :: Cliente
juan = Cliente 500 [clienteBuscaMarca "Jorgito", clienteDulcero, clientePretencioso, clienteAntiRelleno Mousse] []

clienteBuscaMarca :: String -> Alfajor -> Bool
clienteBuscaMarca marca alfajor = nombre alfajor == "Capitan del Espacio"

clientePretencioso :: Alfajor -> Bool
clientePretencioso alfajor = nombre alfajor `elem` ["Premium"]

clienteDulcero :: Alfajor -> Bool
clienteDulcero alfajor = coeficienteDeDulzorDeUnAlfajor alfajor > 0.15

clienteAntiRelleno :: Relleno -> Alfajor -> Bool
clienteAntiRelleno antiRelleno alfajor = antiRelleno `notElem` relleno alfajor

clienteExtraño :: Alfajor -> Bool
clienteExtraño alfajor = not(alfajorPotable alfajor)

coeficienteDeDulzorDeUnAlfajor :: Alfajor -> Float
coeficienteDeDulzorDeUnAlfajor alfajor =  dulzor alfajor / peso alfajor

precioRelleno :: Relleno -> Float
precioRelleno DulceDeLeche = 12
precioRelleno Mousse = 15
precioRelleno Fruta = 10

precioAlfajor :: Alfajor -> Float
precioAlfajor alfajor = (2 * peso alfajor) + sum  (map precioRelleno (relleno alfajor))

alfajorPotable :: Alfajor -> Bool
alfajorPotable alfajor = not (null (relleno alfajor)) && all (== head (relleno alfajor)) (tail (relleno alfajor)) && coeficienteDeDulzorDeUnAlfajor alfajor >= 0.1

abaratarAlfajor :: Alfajor -> Alfajor
abaratarAlfajor alfajor = alfajor {peso = peso alfajor - 10, dulzor = 7}

renombrarAlfajor :: String -> Alfajor -> Alfajor
renombrarAlfajor nuevoNombre alfajor = alfajor {nombre = nuevoNombre}

agregarCapaDeRelleno :: Relleno -> Alfajor -> Alfajor
agregarCapaDeRelleno nuevoRelleno alfajor = alfajor {relleno = relleno alfajor ++ [nuevoRelleno]}

hacerPremium :: Alfajor -> Alfajor
hacerPremium alfajor
 | alfajorPotable alfajor = renombrarAlfajor (nombre alfajor ++ " Premium") (agregarCapaDeRelleno (head (relleno alfajor)) alfajor)
 | otherwise = alfajor

hacerPremiumNVeces :: Int -> Alfajor -> Alfajor
hacerPremiumNVeces 0 alfajor = alfajor
hacerPremiumNVeces n alfajor = hacerPremiumNVeces (n - 1) (hacerPremium alfajor)

leGustanAlCliente :: [Alfajor] -> Cliente -> [Alfajor]
leGustanAlCliente alfajores cliente = filter (\alfajor -> all (\criterio -> criterio alfajor) (criterio cliente)) alfajores

comprarAlfajor :: Alfajor -> Cliente -> Cliente
comprarAlfajor alfajor cliente
 | dinero cliente >= precioAlfajor alfajor = cliente {dinero = dinero cliente - precioAlfajor alfajor, cantAlfajores = cantAlfajores cliente ++ [alfajor]}
 | otherwise = cliente

comprarAlfajores :: [Alfajor] -> Cliente -> Cliente
comprarAlfajores alfajores cliente = foldl (flip comprarAlfajor) cliente (leGustanAlCliente alfajores cliente)     