import Text.Show.Functions
import Data.List

data Persona = Persona {
    nombre :: String,
    edad :: Float,
    felicidad :: Float,
    estres :: Float,
    guita :: Float,
    habilidades :: [Habilidad]
} deriving (Show)

--Auxiliares
between :: Float -> Float -> Float -> Bool
between cotaInferior cotaSuperior valor =
    valor <= cotaSuperior && valor >= cotaInferior

modificarFelicidad :: Float -> Persona -> Persona
modificarFelicidad valor persona = persona {felicidad = felicidad persona + valor}

modificarEstres :: Float -> Persona -> Persona
modificarEstres valor persona = persona {estres = estres persona + valor}

modificarGuita :: Float -> Persona -> Persona
modificarGuita valor persona = persona {guita = guita persona + valor}

envejecer :: Persona -> Persona
envejecer persona = persona {edad = edad persona + 1}

agregarHabilidad :: Habilidad -> Persona -> Persona
agregarHabilidad habilidad persona = persona {habilidades = habilidades persona ++ [habilidad]}

esNiño :: Persona -> Bool
esNiño persona = edad persona < 18

esJovenAdulto :: Persona -> Bool
esJovenAdulto persona = between 18 30 (edad persona)

esGrande :: Persona -> Bool
esGrande persona = edad persona > 30

eliminarHabilidad :: Persona -> Persona
eliminarHabilidad persona = persona {habilidades = tail (habilidades persona)}

limiteDeHabilidades :: Persona -> Int
limiteDeHabilidades persona
    | esNiño persona = 3
    | esJovenAdulto persona = 6
    | otherwise = 4

ajustarHabilidades :: Persona -> Persona
ajustarHabilidades persona
    | length (habilidades persona) > nuevoLimite = persona { habilidades = take nuevoLimite (habilidades persona) }
    | otherwise = persona
  where
    nuevoLimite = limiteDeHabilidades persona

listaHabilidades :: [Habilidad]
listaHabilidades = [cocinar, tenerMascota, trabajarEnDocencia, trabajarEnOtro, trabajarEnSoftware, compartirCasa anabel]

--1A)
anabel :: Persona
anabel = Persona "Anabel" 21 60 15 19 []

--1B)
bruno :: Persona
bruno = Persona "Bruno" 15 90 5 0 []

--1C)
clara :: Persona
clara = Persona "Clara" 31 10 90 25 [cocinar, cocinar, cocinar, cocinar, cocinar]

--2)
jovenesAdultos :: [Persona] -> [Persona]
jovenesAdultos = filter esJovenAdulto

type Habilidad = Persona -> Persona

--3A)
cocinar :: Habilidad
cocinar = modificarEstres (-4) . modificarFelicidad 5  -- aplicacion parcial al no pasar la persona explicitamente

--3B)
tenerMascota :: Habilidad
tenerMascota persona 
    | guita persona >= 60 = (modificarFelicidad 20 . modificarGuita (-5) . modificarEstres (-10)) persona -- compongo las funciones de modificar aspectos
    | otherwise = (modificarFelicidad 20 . modificarGuita (-5) . modificarEstres 5) persona

--3C)
--i)
trabajarEnSoftware :: Habilidad
trabajarEnSoftware = modificarEstres 10 . modificarGuita 20 

--ii)
trabajarEnDocencia :: Habilidad
trabajarEnDocencia = modificarEstres 30 

--iii)
trabajarEnOtro :: Habilidad
trabajarEnOtro = modificarEstres 5 . modificarGuita 5

--3D)
compartirCasa :: Persona -> Habilidad -- la primera persona que le paso es con la que voy a comparar a la persona afectada que paso segunda
compartirCasa compañera personaAfectada 
    | guita compañera > guita personaAfectada = 
        (modificarFelicidad 5 . modificarGuita 10 . modificarEstres nuevoEstres) personaAfectada
    | otherwise = (modificarFelicidad 5 . modificarEstres nuevoEstres) personaAfectada
 
 where
    nuevoEstres = (estres compañera - estres personaAfectada) / 2

-- 4)
aprenderNuevaHabilidad :: Habilidad -> Persona -> Persona -- uso orden superior al pasar la habilidad como parametro
aprenderNuevaHabilidad habilidad persona 
    | esNiño persona && length (habilidades persona) < limiteDeHabilidades persona = agregarHabilidad habilidad persona
    | esJovenAdulto persona && length (habilidades persona) < limiteDeHabilidades persona = agregarHabilidad habilidad persona
    | esGrande persona && length (habilidades persona) < limiteDeHabilidades persona = agregarHabilidad habilidad persona
    | otherwise = (agregarHabilidad habilidad . eliminarHabilidad) persona

--5)
valeLaPenaHabilidad :: Habilidad -> Persona -> Bool
valeLaPenaHabilidad habilidad persona = 
    felicidad (habilidad persona) > felicidad persona ||
    guita (habilidad persona) > guita persona

--6)
cursoIntensivo :: Persona -> [Habilidad] -> Persona
cursoIntensivo = foldl (\persona habilidad -> aprenderNuevaHabilidad habilidad persona)

--7)
felizCumple :: Persona -> Persona
felizCumple = ajustarHabilidades . envejecer