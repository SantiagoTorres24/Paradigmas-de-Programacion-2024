import Text.Show.Functions
import Data.List

data Chofer = Chofer {
    nombreChofer :: String,
    kilometrajeAuto :: Float,
    viajes :: [Viaje],
    condicion :: Viaje -> Bool
} deriving (Show)

data Viaje = Viaje {
    fecha :: Int,
    cliente :: Cliente,
    costo :: Float
} deriving (Show)

data Cliente = Cliente {
    nombreCliente :: String,
    direccion :: String
} deriving (Show)

cualquierViaje :: Viaje -> Bool
cualquierViaje viaje = True

viajesCaros :: Viaje -> Bool
viajesCaros viaje = costo viaje > 200

viajeNombre :: Int -> Viaje -> Bool
viajeNombre n viaje = length (nombreCliente (cliente viaje)) >= n

viajeZona :: String -> Viaje -> Bool
viajeZona zona viaje = zona /= direccion (cliente viaje)

lucas :: Cliente
lucas = Cliente "Lucas" "Victoria"

daniel :: Chofer
daniel = Chofer "Daniel" 23500 [Viaje 20042017 lucas 150] (viajeZona "Olivos")

alejandra :: Chofer
alejandra = Chofer "Alejandra" 180000 [] cualquierViaje

nitoInfy :: Chofer
nitoInfy = Chofer "Nito Infy" 70000 (repetirViaje (Viaje 11032017 lucas 50)) (viajeNombre 3)

repetirViaje viaje = viaje : repetirViaje viaje


choferPuedeTomarViaje :: Chofer -> Viaje -> Bool
choferPuedeTomarViaje = condicion 

liquidacionDeUnChofer :: Chofer -> Float
liquidacionDeUnChofer = sum . map costo . viajes 

choferesQueTomanViaje :: Viaje -> [Chofer] -> [Chofer]
choferesQueTomanViaje viaje = filter (`choferPuedeTomarViaje` viaje)

choferMenosViajes :: [Chofer] -> Chofer
choferMenosViajes choferes = head (filter (\chofer -> length (viajes chofer) == minViajes) choferes)
    where minViajes = minimum (map (length . viajes) choferes)

efectuarViaje :: Viaje -> Chofer -> Chofer
efectuarViaje viaje chofer
 | choferPuedeTomarViaje chofer viaje = chofer {viajes = viajes chofer ++ [viaje]}
 | otherwise = chofer

