import Text.Show.Functions
import Data.List


type Material = String

data Personaje = Personaje {
    nombre :: String,
    puntaje :: Int,
    inventario :: [Material]
} deriving Show

data Receta = Receta {
    materialesNecesarios :: [Material],
    tiempoConstruccion :: Int,
    objetoResultante :: Material
} deriving Show

jugador1 :: Personaje
jugador1 = Personaje "Santi" 1000 [sueter, fogata, pollo, pollo]

fogata,fosforo, madera,polloAsado,pollo,sueter,hielo,lobos,iglues, lana, agujas, tinta :: Material
fogata = "fogata"
fosforo = "fosforo"
madera = "madera"
pollo = "pollo"
polloAsado = "pollo asado"
sueter = "sueter"
hielo = "hielo"
iglues = "iglues"
lobos = "lobos"
lana = "lana"
agujas = "agujas"
tinta = "tinta"

recetaFogata :: Receta
recetaFogata = Receta [madera, fosforo] 10 fogata

recetapolloAsado :: Receta
recetapolloAsado = Receta [fogata, pollo] 300 polloAsado

recetaSueter :: Receta
recetaSueter = Receta [lana, agujas, tinta] 600 sueter

tieneMaterial :: Personaje -> Material -> Bool
tieneMaterial (Personaje _ _ inventario) material = material `elem` inventario

tieneMateriales :: Personaje -> [Material] -> Bool
tieneMateriales personaje = all (tieneMaterial personaje)

craftearObjeto :: Receta -> Personaje -> Personaje
craftearObjeto receta personaje 
    | tieneMateriales personaje (materialesNecesarios receta) = 
        personaje {
            inventario = nuevoInventario,
            puntaje = nuevoPuntaje
        }
    | otherwise = personaje
 where
    nuevoInventario = (inventario personaje \\ materialesNecesarios receta)  ++ [objetoResultante receta] 
    nuevoPuntaje = puntaje personaje + (10 * tiempoConstruccion receta) 

saberSiDuplicaPuntaje :: Personaje -> Receta -> Bool
saberSiDuplicaPuntaje personaje receta = puntaje personaje + (10 * tiempoConstruccion receta)  >= puntaje personaje * 2

crafterYDuplicarPuntaje :: Personaje -> [Receta] -> [Material]
crafterYDuplicarPuntaje personaje = 
    map objetoResultante . filter (\ receta -> tieneMateriales personaje (materialesNecesarios receta) && saberSiDuplicaPuntaje personaje receta ) 

craftearSucesivamente :: Personaje -> [Receta] -> Personaje
craftearSucesivamente  = foldl (flip craftearObjeto)

lograMasPuntosSiguiendoOrden :: Personaje -> [Receta] -> Bool
lograMasPuntosSiguiendoOrden  personaje recetas = 
    puntaje (craftearSucesivamente personaje recetas) > puntaje (foldr craftearObjeto personaje recetas)

--------------------------------------------------MINE----------------------------------------------------------
data Bioma = Bioma{
    materialesPresentes :: [Material],
    materialNecesario :: Material
} deriving (Show)

biomaArtico :: Bioma
biomaArtico = Bioma [hielo, iglues, lobos] sueter

type Herramienta = [Material] -> Material

hacha :: Herramienta
hacha = last

espada :: Herramienta
espada = head

pico :: Int -> Herramienta
pico = flip (!!) 

pala :: Herramienta
pala = (!! 2)

azada :: Herramienta
azada = (!! 3)

mitad :: Herramienta
mitad lista = pico (length lista `div` 2) lista


listaPollosInfinitos :: [String]
listaPollosInfinitos = pollo : listaPollosInfinitos

minar :: Herramienta -> Bioma -> Personaje  -> Personaje
minar herramienta bioma jugador 
    | tieneMaterial jugador (materialNecesario bioma)  = 
        jugador {
            inventario = inventario jugador ++ [herramienta (materialesPresentes bioma)],
            puntaje = puntaje jugador + 50
        }
    | otherwise = jugador

