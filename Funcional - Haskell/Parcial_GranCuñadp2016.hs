import Text.Show.Functions
import Data.List

data Participante = Participante {
  nombre :: String,
  edad :: Float,
  atractivo :: Float,
  personalidad :: Float,
  inteligencia :: Float,
  criterio :: [Participante] -> Participante
} deriving (Show)

instance Eq Participante where
  (==) :: Participante -> Participante -> Bool
  (==) participante otroParticipante = nombre participante == nombre otroParticipante

data Prueba = Prueba {
  condicion :: Participante -> Bool,
  indiceExito :: Participante -> Float
} deriving (Show)

baileDeTikTok :: Prueba
baileDeTikTok = Prueba condicionTikTok indiceExitoTikTok

condicionTikTok :: Participante -> Bool
condicionTikTok participante = personalidad participante > 20

indiceExitoTikTok :: Participante -> Float
indiceExitoTikTok participante
  | condicionTikTok participante = min 100 (personalidad participante + 2 * atractivo participante) 
  | otherwise = 0

botonRojo :: Prueba
botonRojo = Prueba condicionBotonRojo indiceExitoBotonRojo

condicionBotonRojo :: Participante -> Bool
condicionBotonRojo participante = personalidad participante > 10 && inteligencia participante > 20

indiceExitoBotonRojo :: Participante -> Float
indiceExitoBotonRojo participante
  | condicionBotonRojo participante = 100
  | otherwise = 0

cuentasRapidas :: Prueba
cuentasRapidas = Prueba condicionCuentasRapidas indiceExitoCuentasRapidas

condicionCuentasRapidas :: Participante -> Bool
condicionCuentasRapidas participante = inteligencia participante > 40

indiceExitoCuentasRapidas :: Participante -> Float
indiceExitoCuentasRapidas participante
  | condicionCuentasRapidas participante = min 100 (max 0 (inteligencia participante + personalidad participante - atractivo participante))
  | otherwise = 0

quienesSuperan :: Prueba -> [Participante] -> [Participante]
quienesSuperan prueba = filter(condicion prueba)

promedioExito :: Prueba -> [Participante] -> Float
promedioExito prueba participantes
  | null participantes = 0
  | otherwise = (sum . map (indiceExito prueba) $ participantes) / fromIntegral (length participantes)

esFavorito :: Participante -> [Prueba] -> Bool
esFavorito participante = all (\prueba -> indiceExito prueba participante > 50)

maximoSegun :: (a -> Float) -> [a] -> a
maximoSegun f = foldl1 (mayorSegun f)

mayorSegun :: (a -> Float) -> a -> a -> a
mayorSegun f a b
  | f a > f b = a
  | otherwise = b

minimoSegun :: (a -> Float) -> [a] -> a
minimoSegun f = foldl1 (menorSegun f)

menorSegun :: (a -> Float) -> a -> a -> a
menorSegun f a b
  | f a < f b = a
  | otherwise = b

menosInteligente :: [Participante] -> Participante
menosInteligente = minimoSegun inteligencia

masAtractivo :: [Participante] -> Participante
masAtractivo = maximoSegun atractivo

masViejo :: [Participante] -> Participante
masViejo = maximoSegun edad

participante1 :: Participante
participante1 = Participante "Javier Tulei" 52 30 70 35 menosInteligente

participante2 :: Participante
participante2 = Participante "Minimo Kirchner" 46 0 40 50 masAtractivo

participante3 :: Participante
participante3 = Participante "Horacio Berreta" 57 10 60 50 masAtractivo

participante4 :: Participante
participante4 = Participante "Myriam Bregwoman" 51 40 40 60 masViejo

estanEnPlaca :: [Participante] -> [Participante]
estanEnPlaca participantes = filter (\participante -> 
  menosInteligente participantes == participante || 
  masAtractivo participantes == participante || 
  masViejo participantes == participante) 
  participantes

estaEnElHorno :: Participante -> [Participante] -> Bool
estaEnElHorno participante = (>=3) . length . filter(== participante) 

hayAlgoPersonal :: Participante -> [Participante] -> Bool
hayAlgoPersonal participante = all (== participante)

zafo :: Participante -> [Participante] -> Bool
zafo participante participantes = participante `notElem` participantes

