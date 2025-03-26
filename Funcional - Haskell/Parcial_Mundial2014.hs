import Text.Show.Functions
import Data.List

data Jugador = Jugador {
    nombreJugador :: String, 
    edad :: Int,
    promedioGol :: Float,
    habilidad :: Float,
    cansancio :: Float
} deriving (Show)

type Equipo = (String, Char, [Jugador])

martin :: Jugador
martin = Jugador "Martin" 26 0.0 50 35.0

juan :: Jugador
juan = Jugador "Juancho" 30 0.2 50 40.0

maxi :: Jugador
maxi = Jugador "Maxi Lopez" 27 0.4 68 30.0

jonathan :: Jugador
jonathan = Jugador "Chueco" 20 1.5 80 99.0

lean :: Jugador
lean = Jugador "Hacha" 23 0.01 50 35.0

brian :: Jugador
brian = Jugador "Panadero" 21 5 80 15.0

garcia :: Jugador
garcia = Jugador "Sargento" 30 1 80 13.0

messi :: Jugador
messi = Jugador "Pulga" 26 10 99 43.0

aguero :: Jugador
aguero = Jugador "Aguero" 24 5 90 5.0

equipo1 :: Equipo
equipo1 = ("Lo Que Vale Es El Intento", 'F', [martin, juan, maxi])
losDeSiempre :: Equipo
losDeSiempre = ( "Los De Siempre", 'F', [jonathan, lean, brian])

restoDelMundo :: Equipo
restoDelMundo = ("Resto del Mundo", 'A', [garcia, messi, aguero])

jugadoresFaranduleros :: [String]
jugadoresFaranduleros = ["Maxi Lopez", "Icardi", "Aguero", "Caniggia", "Demichelis"]

quickSort :: (a -> a -> Bool) -> [a] -> [a]
quickSort _ [] = [] 
quickSort criterio (x:xs) = 
    (quickSort criterio . filter (not . criterio x)) xs ++ [x] ++ (quickSort criterio . filter (criterio x)) xs

esFigura :: Jugador -> Bool
esFigura jugador = habilidad jugador > 75 && promedioGol jugador > 0

figurasDeUnEquipo :: Equipo -> [Jugador]
figurasDeUnEquipo (_,_, jugadores) = filter (\jugador -> esFigura jugador) jugadores

esFarandulero :: Jugador -> Bool
esFarandulero jugador = nombreJugador jugador `elem` jugadoresFaranduleros

tienenFarandulero :: Equipo -> Bool
tienenFarandulero (_,_, jugadores) = any (\jugador -> esFarandulero jugador) jugadores

esJoven :: Jugador -> Bool
esJoven jugador = edad jugador < 27

figuritasDificles :: [Equipo] -> Char -> [String]
figuritasDificles equipos grupo =
    map nombreJugador . concatMap (filter filtroJugador . figurasDeUnEquipo) . filter filtroEquipo $ equipos
    where
        filtroEquipo (_, grupoEquipo, _) = grupoEquipo == grupo
        filtroJugador jugador = esJoven jugador && notElem (nombreJugador jugador) jugadoresFaranduleros

jugarPartido :: [Equipo] -> [Equipo]
jugarPartido = map actualizarEquipo
  where
    actualizarEquipo (nombre, grupo, jugadores) = (nombre, grupo, map actualizarJugador jugadores)

    actualizarJugador jugador
      | not (esFarandulero jugador) && esJoven jugador && esFigura jugador = jugador { cansancio = 50 }
      | esJoven jugador = jugador { cansancio = cansancio jugador + cansancio jugador * 0.10 }
      | not (esJoven jugador) && esFigura jugador = jugador {cansancio = cansancio jugador + 20}
      | otherwise = jugador {cansancio = cansancio jugador * 2}

menosCansados :: [Jugador] -> [Jugador]
menosCansados jugadores = take 11 (menosCansados' jugadores)
    where
        menosCansados' :: [Jugador] -> [Jugador]
        menosCansados' [] = []
        menosCansados' [x] = [x]
        menosCansados' (x:y:xs)
            | cansancio x < cansancio y = x : menosCansados' (y:xs)
            | otherwise = y : menosCansados' (x:xs)

seleccionarJugadores :: Equipo -> Equipo
seleccionarJugadores (nombre, grupo, jugadores) = (nombre, grupo, menosCansados jugadores)

calcularPromedioDeGol :: Equipo -> Float
calcularPromedioDeGol equipo =
    sum (map promedioGol jugadoresSeleccionados) / fromIntegral (length jugadoresSeleccionados)
  where
    jugadoresSeleccionados = (\(_, _, jugadores) -> jugadores) (seleccionarJugadores equipo)



ganadorPartido :: Equipo -> Equipo -> Equipo
ganadorPartido equipo1 equipo2
    | calcularPromedioDeGol equipo1 > calcularPromedioDeGol equipo2 = equipo1
    | otherwise = equipo2

campeonTorneo :: [Equipo] -> Equipo
campeonTorneo [equipo] = equipo
campeonTorneo (equipo1:equipo2:equiposRestantes) = 
    campeonTorneo (ganadorPartido equipo1 equipo2 : equiposRestantes)

campeonTorneo' :: [Equipo] -> Equipo
campeonTorneo' = foldl1 ganadorPartido

encontrarFigura :: Equipo -> Jugador
encontrarFigura (_, _, jugadores) = head (filter esFigura jugadores)

nombreFiguraDelCampeon :: [Equipo] -> String
nombreFiguraDelCampeon equipos = nombreJugador (encontrarFigura (campeonTorneo equipos))