import Text.Show.Functions
import Data.List

data Fremen = Fremen {
    nombre :: String,
    tolerancia :: Float,
    titulos :: [String],
    reconocimientos :: Float
} deriving (Show, Eq)

stilgar :: Fremen
stilgar = Fremen "Stilgar" 150 ["Guia"] 3

nuevoReconocimineto :: Fremen -> Fremen
nuevoReconocimineto fremen = fremen { reconocimientos = reconocimientos fremen + 1}

candidatosAElegir :: [Fremen] -> Bool
candidatosAElegir = any (\ fremen -> "Domador" `elem` titulos fremen  && tolerancia fremen > 100  )

maximoSegun :: (a -> Float) -> [a] -> a
maximoSegun f = foldl1 (mayorSegun f)

mayorSegun :: (a -> Float) -> a -> a -> a
mayorSegun f a b
  | f a > f b = a
  | otherwise = b

elElegido :: [Fremen] -> Fremen
elElegido = maximoSegun reconocimientos

data Gusano = Gusano {
    longitud :: Float,
    hidratacion :: Float,
    descripcion :: String
} deriving (Show, Eq, Ord)

reproduccionGusanos :: Gusano -> Gusano -> Gusano -> Gusano
reproduccionGusanos g1 g2 gNuevo = 
    gNuevo {
        longitud = max (longitud g1) (longitud g2) * 0.10,
        hidratacion = 0,
        descripcion = descripcion g1 ++ " - " ++ descripcion g2
    }

reproduccionEnCadena :: [Gusano] -> [Gusano] -> [Gusano]
reproduccionEnCadena gusanos1 gusanos2 = 
    map (\(g1, g2) -> reproduccionGusanos g1 g2 (Gusano 0 0 "")) (zip gusanos1 gusanos2)

type Mision = Fremen -> Gusano -> Fremen


domarGusanoDeArena :: Mision
domarGusanoDeArena freman gusano
    | tolerancia freman >= longitud gusano / 2 =
         freman {titulos = titulos freman ++ ["Domador"], tolerancia = tolerancia freman + 100}
    | otherwise = freman {tolerancia = tolerancia freman - (tolerancia freman * 0.10)}

destruirGusanoDeArena :: Mision
destruirGusanoDeArena freman gusano    
    | "Domador" `elem` titulos freman && tolerancia freman <= longitud gusano / 2 =
        freman {reconocimientos = reconocimientos freman + 1, tolerancia = tolerancia freman + 100}
    | otherwise = freman {tolerancia = tolerancia freman - (tolerancia freman * 0.20)}

inventada :: Mision
inventada freman gusano
    | tolerancia freman <= longitud gusano / 2 = freman {tolerancia = tolerancia freman + 100}


type Tribu = [Fremen]

realizarMision :: Tribu -> Mision -> Gusano -> Tribu
realizarMision tribu mision gusano = map (`mision` gusano) tribu

elegidoDiferente :: Tribu -> Mision -> Gusano -> Bool
elegidoDiferente tribu mision gusano = (/=) ((elElegido . realizarMision tribu mision) gusano) (elElegido tribu)