import Text.Show.Functions
import Data.List

data Auto = Auto {
    color :: String,
    velocidad :: Int,
    distancia :: Int
} 

auto1 :: Auto
auto1 = Auto {
    color = "Rojo",
    velocidad = 120,
    distancia = 0
}

auto2 :: Auto
auto2 = Auto {
    color = "Negro",
    velocidad = 120,
    distancia = 0
}

auto3 :: Auto
auto3 = Auto {
    color = "Azul",
    velocidad = 120,
    distancia = 0
}

auto4 :: Auto
auto4 = Auto {
    color = "Blanco",
    velocidad = 120,
    distancia = 0
}
autosEnCarrera :: [Auto]
autosEnCarrera = [auto1, auto2, auto3, auto4]

instance Eq Auto where
    (Auto color1 velocidad1 distancia1) == (Auto color2 velocidad2 distancia2) =
        color1 == color2 && velocidad1 == velocidad2 && distancia1 == distancia2
    auto1 /= auto2 = not (auto1 == auto2)

instance Show Auto where
    show (Auto color velocidad distancia) = "Auto {color = " ++ show color ++ ", velocidad = " ++ show velocidad ++ ", distancia = " ++ show distancia ++ "}"


-- 1A)
autosCercanos :: Auto -> Auto -> Bool
autosCercanos auto1 auto2 = auto1 /= auto2 && abs (distancia auto1 - distancia auto2) < 10

-- 1B)
vaTranquilo :: Auto -> [Auto] -> Bool
vaTranquilo auto = all (\otroAuto -> distancia auto >= distancia otroAuto) 

-- 1C)
puesto :: Auto -> [Auto] -> Int
puesto auto = (+1) . (sum . map (\ otroAuto -> fromEnum (distancia otroAuto > distancia auto )) )

-- 2A)
corra :: Int -> Auto -> Auto
corra tiempo auto =  auto {distancia = distancia auto + velocidad auto  * tiempo}

-- 2Bi)
modificarVelocidad ::  Int -> Auto -> Auto 
modificarVelocidad disminuir auto = auto { velocidad = max 0 (velocidad auto - disminuir) }




-- 2Bii)
bajarVelocidad :: Int -> Auto -> Auto
bajarVelocidad = modificarVelocidad

-- 3)
afectarALosQueCumplen :: (a -> Bool) -> (a -> a) -> [a] -> [a]
afectarALosQueCumplen criterio efecto lista
  = (map efecto . filter criterio) lista ++ filter (not.criterio) lista

-- 3A)
terremoto :: Auto -> [Auto] -> [Auto]
terremoto auto = afectarALosQueCumplen (autosCercanos auto) (bajarVelocidad 50)

-- 3B)
autosPorDelante :: Auto -> Auto -> Bool
autosPorDelante auto1 auto2 = distancia auto2 < distancia auto1

miguelitos :: Int -> Auto -> [Auto] -> [Auto]
miguelitos disminuir auto  =
  afectarALosQueCumplen (autosPorDelante auto) (bajarVelocidad disminuir) 


-- 3C)
jetpack :: Int -> Auto -> Auto
jetpack tiempo auto = auto { distancia = distancia auto + velocidad auto * 2 * tiempo}  

-- 4)
newtype Carrera = Carrera { autos :: [Auto]}
instance Show Carrera where
    show (Carrera autos) = "Carrera " ++ show autos



-- 4A)
eventos :: [Carrera -> Carrera]
eventos = [ correnTodos 30, usaPowerUp (Jetpack 3) "Azul", usaPowerUp Terremoto "Blanco"] --EJ 1

eventos' :: [Carrera -> Carrera]
eventos' = [ correnTodos 40, usaPowerUp (Miguelitos 20) "Blanco", usaPowerUp (Jetpack 6) "Negro", correnTodos 10] --EJ 2
type Color = String
simularCarrera :: Carrera -> [Carrera -> Carrera] -> [(Int, Color)]
simularCarrera carrera eventos = obtenerPosiciones (foldl (.) id eventos carrera)



aplicarEventos :: Carrera -> [Carrera -> Carrera] -> [Carrera]
aplicarEventos carrera  = map (\unEvento-> unEvento carrera) 


obtenerPosiciones :: Carrera -> [(Int, Color)]
obtenerPosiciones carrera = 
    zipWith (\posicion auto -> (posicion, color auto)) [1..] (autosOrdenados carrera)
    where autosOrdenados = autos . ordenarAutos --zipWith toma la lista de los autos ordenados, la lista [1..] y los combina.

ordenarAutos :: Carrera -> Carrera
ordenarAutos carrera = carrera { autos = sortBy (\auto1 auto2 -> compare (distancia auto2) (distancia auto1)) (autos carrera) }

-- 4Bi)
correnTodos :: Int -> Carrera -> Carrera
correnTodos tiempo (Carrera autos) = Carrera (map (corra tiempo) autos)


-- 4Bii)
buscarAutoPorColor :: String -> Carrera -> Auto
buscarAutoPorColor colorAuto (Carrera autos) = head (filter (\auto -> color auto == colorAuto) autos)


data PowerUp = Terremoto | Miguelitos Int | Jetpack Int

usaPowerUp :: PowerUp -> String -> Carrera -> Carrera
usaPowerUp Terremoto colorAuto carrera =
    carrera { autos = terremoto auto (autos carrera) }
    where
        auto = buscarAutoPorColor colorAuto carrera

usaPowerUp (Miguelitos disminuir) colorAuto carrera =
    carrera { autos = miguelitos disminuir auto (autos carrera) }
    where
        auto = buscarAutoPorColor colorAuto carrera

usaPowerUp (Jetpack tiempo) colorAuto carrera =
    carrera { autos = map (jetpack tiempo) (autos carrera) }
    where
        auto = buscarAutoPorColor colorAuto carrera







