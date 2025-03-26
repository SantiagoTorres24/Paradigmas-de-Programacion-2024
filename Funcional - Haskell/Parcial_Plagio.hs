import Text.Show.Functions
import Data.List


data Autor = Autor {
    nombre :: String,
    obras :: [Obra]
} deriving (Show)

data Obra = Obra {
    titulo :: String,
    año :: Int
} deriving (Show)

data Bot = Bot {
    fabricante :: String,
    formasDeDeteccion :: [Plagio]
} deriving (Show)

autor1 :: Autor
autor1 = Autor "Nombre1" [pato1]

pato1 :: Obra
pato1 = Obra "Había una vez un pato." 1997

autor2 :: Autor
autor2 = Autor "Nombre2" [pato2]

pato2 :: Obra
pato2 = Obra "¡Habia una vez un pato!" 1996

autor3 :: Autor
autor3 = Autor "Nombre3" [mirsusmor]

mirsusmor :: Obra
mirsusmor = Obra "Mirtha, Susana y Moria." 2010

autor4 :: Autor
autor4 = Autor "Nombre4" [semantica1]

semantica1 :: Obra
semantica1 = Obra "La semántica funcional del amoblamiento vertebral es riboficiente" 2020

autor5 :: Autor
autor5 = Autor "Nombre5" [semantica1]

semantica2 :: Obra
semantica2 = Obra "La semántica funcional de Mirtha, Susana y Moria." 2022

obraInfinita :: Obra
obraInfinita = Obra (cycle "TituloInfinto") 2024


esLetra :: Char -> Bool
esLetra character = character `elem` "ABCDEFGHIJKLMNÑOPQRSTUVWXYZabcdefghijklmnñoprstuvwxyz "

versionCruda :: String -> String
versionCruda = filter (\c -> esLetra c) . map quitarAcento
 where  quitarAcento 'á' = 'a'
        quitarAcento 'é' = 'e'
        quitarAcento 'í' = 'i'
        quitarAcento 'ó' = 'o'
        quitarAcento 'ú' = 'u'
        quitarAcento c = c

type Plagio = String -> String -> Bool

copiaLiteral :: Plagio
copiaLiteral titulo1 titulo2 = versionCruda titulo1 == versionCruda titulo2 

empiezaIgual :: Int -> Plagio
empiezaIgual caracteres titulo1 titulo2 = 
    take caracteres titulo1 == take caracteres titulo2 && length titulo1 > length titulo2

leAgregaronIntro :: Plagio
leAgregaronIntro titulo1 titulo2 = titulo2 `isInfixOf` tail titulo1

bot1 :: Bot
bot1 = Bot "Fabricante1" [copiaLiteral]

bot2 :: Bot
bot2 = Bot "Fabricante2" [empiezaIgual 10, leAgregaronIntro]

detectarPlagio :: Bot -> Obra -> Obra -> Bool
detectarPlagio bot obra1 obra2 = any (\ detectar -> detectar (titulo obra1) (titulo obra2)) (formasDeDeteccion bot)

cadenaDePlagiadores :: Bot -> [Autor] -> Bool
cadenaDePlagiadores _ []= False
cadenaDePlagiadores _ [_] = False
cadenaDePlagiadores bot (a1 : a2 : as) = 
    any (\obra1 -> any (detectarPlagio bot obra1) (obras a2)) (obras a1) && cadenaDePlagiadores bot (a2 : as)

-- aprendieron :: [Autor] -> Bot -> [Autor] ????

























