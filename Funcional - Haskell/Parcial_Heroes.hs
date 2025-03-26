import Text.Show.Functions
import Data.List

data Heroe = Heroe {
    mombreHeroe :: String,
    epiteto :: String,
    reconocimiento :: Int,
    artefactos :: [Artefacto],
    tareas :: [Tarea]
} deriving (Show)

data Artefacto = Artefacto {
    nombreArtefacto :: String,
    rareza :: Int
} deriving (Show)

data Bestia = Bestia {
    nombreBestia :: String,
    debilidad :: Heroe -> Bool
} deriving (Show)

hercules :: Heroe
hercules = Heroe "Hercules" "Guardián del Olimpo" 700 [] []

herculesInicial :: Heroe
herculesInicial = Heroe "Hercules" "Cagon de Mierda" 700 [] []

pistola :: Artefacto
pistola = Artefacto "Pistola" 1000

relampagoZeus :: Artefacto
relampagoZeus = Artefacto "Relampago de Zeus" 5000

lanzaDelOlimpo :: Artefacto
lanzaDelOlimpo = Artefacto "Lanza del Olimpo" 100

xiphos :: Artefacto
xiphos = Artefacto "Xhipos" 50 

leonNemea :: Bestia
leonNemea = Bestia "Nemea" (\heroe -> length (epiteto heroe) > 10)

cabra :: Bestia
cabra = Bestia "Meessi" (\heroe -> reconocimiento heroe >= 500)

agregarArtefacto :: [Artefacto] -> Heroe -> Heroe
agregarArtefacto artefactosNuevos heroe = heroe {artefactos = artefactos heroe ++ artefactosNuevos}

modificarEpiteto :: String -> Heroe -> Heroe
modificarEpiteto epiteto heroe = heroe {epiteto = epiteto}

modificarReconocimento :: Int -> Heroe -> Heroe
modificarReconocimento valor heroe = heroe {reconocimiento = valor}

modificarRareza :: Heroe -> Heroe
modificarRareza heroe = heroe {artefactos = filter (\artefacto -> rareza artefacto * 3 >= 1000) (artefactos heroe)}

agregarTarea :: Tarea -> Heroe -> Heroe
agregarTarea tarea heroe = heroe {tareas = tareas heroe ++ [tarea]}

pasarALaHistoria :: Heroe -> Heroe
pasarALaHistoria heroe 
    | reconocimiento heroe > 1000 = modificarEpiteto "El Mítico" heroe
    | reconocimiento heroe >= 500 = (modificarEpiteto "El Magnifico" . agregarArtefacto [lanzaDelOlimpo]) heroe
    | reconocimiento heroe < 500 && reconocimiento heroe >= 100 = (modificarEpiteto "Hoplita" . agregarArtefacto [xiphos]) heroe
    | otherwise = heroe

type Tarea = Heroe -> Heroe

listaTareas :: [Tarea]
listaTareas = cycle [encontrarArtefacto pistola, escalarElOlimpo, ayudarACruzarLaCalle 5, matarALaBestia cabra, matarAlLeonNemea leonNemea]

encontrarArtefacto :: Artefacto -> Tarea
encontrarArtefacto artefacto heroe = (modificarReconocimento (reconocimiento heroe + rareza artefacto) . agregarArtefacto [artefacto]) heroe

escalarElOlimpo :: Tarea
escalarElOlimpo  = modificarReconocimento 500 . modificarRareza  . agregarArtefacto [relampagoZeus] 

ayudarACruzarLaCalle :: Int -> Tarea
ayudarACruzarLaCalle cuadras = modificarEpiteto ("Gros" ++ replicate cuadras 'o')

matarALaBestia :: Bestia -> Tarea
matarALaBestia bestia heroe
    | debilidad bestia heroe = modificarEpiteto ("El Asesino de la " ++ nombreBestia bestia) heroe
    | otherwise = modificarEpiteto "El Cobarde" heroe

matarAlLeonNemea :: Bestia -> Tarea
matarAlLeonNemea bestia heroe
    | debilidad bestia heroe = 
        (modificarEpiteto "Guardian del Olimpo" . agregarArtefacto [relampagoZeus, pistola] . modificarReconocimento 700) heroe
    | otherwise = heroe

hacerTarea :: Tarea -> Heroe -> Heroe
hacerTarea tarea  = tarea . agregarTarea tarea

presumirLogros :: Heroe -> Heroe -> (Heroe, Heroe)
presumirLogros heroe1 heroe2
    | reconocimiento heroe1 > reconocimiento heroe2 = (heroe1, heroe2)
    | reconocimiento heroe1 < reconocimiento heroe2 = (heroe2, heroe1)
    | sumaRarezas heroe1 > sumaRarezas heroe2 = (heroe1, heroe2)
    | sumaRarezas heroe1 < sumaRarezas heroe2 = (heroe2, heroe1)
    | otherwise = presumirLogros (hacerTareas (tareas heroe2) heroe1) (hacerTareas (tareas heroe1) heroe2)

hacerTareas :: [Tarea] -> Heroe -> Heroe
hacerTareas tareas heroe = foldl (flip ($)) heroe tareas

sumaRarezas :: Heroe -> Int
sumaRarezas = sum . map rareza . artefactos

type Labor = [Tarea]

realizarLabor :: Heroe -> Labor -> Heroe
realizarLabor = foldl (flip hacerTarea) 