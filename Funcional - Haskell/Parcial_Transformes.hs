import Text.Show.Functions
import Data.List

data Autobot = 
    Robot String (Int, Int, Int) ((Int, Int, Int) -> (Int, Int)) 
    | Vehiculo String (Int, Int)
    deriving (Show)

data Robot = UnRobot {
    nombreRobot :: String,
    capacidades :: (Int, Int, Int),
    transformacion :: (Int, Int, Int) -> (Int, Int)
} deriving (Show)

data Vehiculo = UnVehiculo {
    nombreVehiculo :: String,
    capacidades' :: (Int, Int)
} deriving (Show)

optimus :: Autobot
optimus = Robot "Optimus Prime" (20,20,10) optimusTransformacion

optimusTransformacion :: ((Int, Int, Int) -> (Int, Int))
optimusTransformacion (_,v,r) = (v * 5, r * 2)

jazz :: Autobot
jazz = Robot "Jazz" (8,35,3) jazzTransformacion

jazzTransformacion :: ((Int, Int, Int) -> (Int, Int))
jazzTransformacion (_,v,r) = (v * 6, r * 3)

wheeljack :: Autobot
wheeljack = Robot "Wheeljack" (11,30,4) wheeljackTransformacion

wheeljackTransformacion :: ((Int, Int, Int) -> (Int, Int))
wheeljackTransformacion (_,v,r) = (v * 4, r * 3)

bumblebee :: Autobot
bumblebee = Robot "Bumblebee" (10,33,5) bumblebeeTransformacion

bumblebeeTransformacion :: ((Int, Int, Int) -> (Int, Int))
bumblebeeTransformacion (_,v,r) = (v * 4, r * 2)

autobots :: [Autobot]
autobots = [ optimus, jazz, wheeljack, bumblebee ]

maximoSegun :: (Int -> Int -> Int) -> Int -> Int -> Int
maximoSegun f n1 n2 
    | f n1 n2 > f n2 n1 = n1
    | otherwise = n2

accederAFuerzaAutobot :: Autobot -> Int
accederAFuerzaAutobot (Robot _ (fuerza, _, _) _) = fuerza
accederAFuerzaAutobot (Vehiculo _ (_, _)) = 0

accederAVelocidadAutobot :: Autobot -> Int
accederAVelocidadAutobot (Robot _ (_, velocidad, _) _) = velocidad
accederAVelocidadAutobot (Vehiculo _ (velocidad, _)) = velocidad

accederAResistenciaAutobot :: Autobot -> Int
accederAResistenciaAutobot (Robot _ (_, _, resistencia) _) = resistencia
accederAResistenciaAutobot (Vehiculo _ (_, resistencia)) = resistencia

transformar :: Autobot -> Vehiculo
transformar (Robot nombre capacidades transformacion) = UnVehiculo nombre (transformacion capacidades)
transformar (Vehiculo nombre capacidades) = UnVehiculo nombre capacidades

velocidadContra :: Autobot -> Autobot -> Int
velocidadContra autobot1 autobot2 = 
    max 0 (accederAFuerzaAutobot autobot2 - accederAResistenciaAutobot autobot1 - accederAVelocidadAutobot autobot1)

elMasRapido :: Autobot -> Autobot -> Autobot
elMasRapido autobot1 autobot2 
    | velocidadContra autobot1 autobot2 > velocidadContra autobot2 autobot1 = autobot1
    | otherwise = autobot2

domina :: Autobot -> Autobot -> Bool
domina autobot1 autobot2 = 
    all (\(a1, a2) -> accederAVelocidadAutobot a1 >= accederAVelocidadAutobot a2) emparejamientos
  where
    emparejamientos = [(autobot1, autobot2), (transformarA autobot1, autobot2), (autobot1, transformarA autobot2), (transformarA autobot1, transformarA autobot2)]
    transformarA :: Autobot -> Autobot
    transformarA autobot@(Robot nombre capacidades transformacion) = Robot nombre capacidades transformacion
    transformarA (Vehiculo nombre capacidades) = Vehiculo nombre capacidades

losDominaATodos :: Autobot -> [Autobot] -> Bool
losDominaATodos robot  = all (domina robot) 

quienesCumplen :: [Autobot] -> (Autobot -> [Autobot] -> Bool) -> [Autobot]
quienesCumplen autobots condicion = filter (\autobot -> condicion autobot autobots) autobots


 
