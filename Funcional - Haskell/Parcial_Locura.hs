import Text.Show.Functions
import Data.List


data Investigador = Investigador {
    nombre :: String,
    cordura :: Int,
    items :: [Item],
    sucesosEvitados :: [String]
} deriving (Show, Eq)

data Item = Item {
    nombreItem :: String,
    valor :: Int
} deriving (Show, Eq)

maximoSegun :: (Ord b) => (a -> b) -> [a] -> a
maximoSegun f = foldl1 (mayorSegun f)

mayorSegun :: (Ord b) => (a -> b) -> a -> a -> a
mayorSegun f a b
  | f a > f b = a
  | otherwise = b

deltaSegun ponderacion transformacion valor = abs ((ponderacion . transformacion) valor - ponderacion valor)

modificarCordura :: Int -> Investigador -> Investigador
modificarCordura valor investigador = investigador { cordura = max 0 (cordura investigador - valor) }

agregarItem :: Item -> Investigador -> Investigador
agregarItem item investigador = investigador { items = items investigador ++ [item] }

enloquezca :: Int -> Investigador -> Investigador
enloquezca = modificarCordura

hallarItem :: Item -> Investigador -> Investigador
hallarItem item = agregarItem item . modificarCordura (valor item)

saberSiTieneItem :: Item -> [Investigador] -> Bool
saberSiTieneItem item = any (\investigador -> nombreItem item `elem` map nombreItem (items investigador))

estaLoco :: Investigador -> Bool
estaLoco investigador = cordura investigador == 0

valorMaxItems :: [Item] -> Item
valorMaxItems = maximoSegun valor

potencialDeUnInvestigador :: Investigador -> Int
potencialDeUnInvestigador investigador
    | estaLoco investigador = cordura investigador * experiencia + valor (valorMaxItems (items investigador))
    | otherwise = 0
  where
    experiencia = 1 + length (items investigador)

lider :: [Investigador] -> Investigador
lider = maximoSegun potencialDeUnInvestigador

deltaCorduraTotal :: Int -> [Investigador] -> Int
deltaCorduraTotal valor = sum . map (deltaSegun cordura (enloquezca valor))

deltaSegunPotencial :: [Investigador] -> Int
deltaSegunPotencial investigadores =
    sum $ map (deltaSegun potencialDeUnInvestigador (\ inv -> head (filter (not . estaLoco) investigadores))) investigadores

data Suceso = Suceso {
    descripcion :: String,
    consecuencias :: [[Investigador] -> [Investigador]],
    evitarConsecuencias :: [Investigador] -> Bool
} deriving (Show)

despertar :: Suceso
despertar = 
    Suceso "Despertar de un Antiguo" [todosEnloquezcan 10, perderPrimerIntegrante] condicionDespertar

todosEnloquezcan :: Int -> [Investigador] -> [Investigador]
todosEnloquezcan valor = map (enloquezca valor)

perderPrimerIntegrante :: [Investigador] -> [Investigador]
perderPrimerIntegrante = tail

condicionDespertar :: [Investigador] -> Bool
condicionDespertar = any (\investigador -> "Necronomicon" `elem` map nombreItem (items investigador))

ritual :: Suceso
ritual = Suceso "Ritual en Innsmouth" [primerInvestigadorHalle "Daga Maldita" 3, todosEnloquezcan 2, enfrentarSuceso despertar] (potencialLider 100)

primerInvestigadorHalle :: String -> Int -> [Investigador] -> [Investigador]
primerInvestigadorHalle nombre valor integrantes = hallarItem (Item nombre valor) (head integrantes) : tail integrantes

enfrentarSuceso :: Suceso -> [Investigador] -> [Investigador]
enfrentarSuceso suceso investigadores
    | evitarConsecuencias suceso investigadores = investigadores
    | otherwise = foldl (\acc f -> f acc) investigadores (consecuencias suceso)

potencialLider :: Int -> [Investigador] -> Bool
potencialLider valor = (> valor) . potencialDeUnInvestigador . lider