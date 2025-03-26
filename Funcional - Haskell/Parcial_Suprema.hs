import Text.Show.Functions
import Data.List

data Ley = Ley {
    tema :: String,
    presupuesto :: Float,
    actoresQueLaApoyan :: [String]
} deriving (Show)

cannabis :: Ley
cannabis = Ley "Uso medicinal del Cannabis" 5 ["Cambio de Todos", "Sector Financiero"]

educacion :: Ley
educacion = Ley "Educacion Superior" 30 ["Centro Federal", "Docentes"]

tenistaDeMesa :: Ley
tenistaDeMesa = Ley "Profesionalizacion del Tenista de Mesa" 1 ["Centro Federal", "Deportistas Autonomos", "Club Paleta Veloz"]

tenis :: Ley
tenis = Ley "Tenis" 2 ["Deportistas Autonomos"]

listaLeyes :: [Ley]
listaLeyes = [cannabis, educacion, tenistaDeMesa, tenis]

agenda :: [String]
agenda = ["Educacion Superior", "Uso medicinal del Cannabis"]

type Juez = Ley -> Bool

opinionPublica :: Juez
opinionPublica ley = tema ley `elem` agenda

odiaSectorFinanciero :: Juez
odiaSectorFinanciero ley = "Sector Financiero" `notElem` actoresQueLaApoyan ley

limitePresupuesto :: Float -> Juez
limitePresupuesto valor ley = presupuesto ley < valor

juezPreocupado :: Juez
juezPreocupado = limitePresupuesto 10

juezTolerante :: Juez
juezTolerante = limitePresupuesto 20

juezConservador :: Juez
juezConservador ley = "Partido Conservador" `elem` actoresQueLaApoyan ley

juezPositivo :: Juez
juezPositivo ley = True

juezInventado :: Juez
juezInventado ley = length (tema ley) > 10

juezTranquilo :: Juez
juezTranquilo = limitePresupuesto 50

juezSector :: String -> Juez
juezSector sector ley = sector `elem` actoresQueLaApoyan ley  

listajueces1 :: [Juez]
listajueces1 = [opinionPublica, odiaSectorFinanciero, juezPreocupado, juezTolerante, juezConservador]

listajueces2 :: [Juez]
listajueces2 = [opinionPublica, odiaSectorFinanciero, juezPositivo, juezInventado, juezTranquilo]

esConstitucional :: [Juez] -> Ley -> Bool
esConstitucional jueces ley = votosTotales > length jueces `div` 2
    where 
        votosTotales = length . filter (\juez -> juez ley) $ jueces

leyesParticulares :: [Ley] -> [Juez] -> [Juez]-> [Ley]
leyesParticulares leyes jueces1 jueces2 = 
    filter(\ley -> not(esConstitucional jueces1 ley) && esConstitucional jueces2 ley) leyes 

borocotizar :: Ley -> [Juez] -> [Juez]
borocotizar ley = map (\juez ley -> not (juez ley))

juezApoyaSector :: Juez -> [Ley] -> String -> Bool
juezApoyaSector juez leyes sector = all (\ley -> juez ley == juezSector sector ley) leyes
