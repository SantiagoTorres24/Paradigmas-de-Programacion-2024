import Text.Show.Functions
import Data.List


data Turista = Turista {
    cansancio :: Int,
    stress :: Int, 
    viajaSolo :: Bool,
    idiomas :: [String]
} deriving (Eq, Show)


ana :: Turista
ana = Turista 0 21 False ["Espaniol"]

beto :: Turista
beto = Turista 100 100 True ["Aleman"]

cathi :: Turista
cathi = Turista 15 15 True ["Aleman", "Catalan"]

irPlaya :: Turista -> Turista
irPlaya turista 
 | viajaSolo turista = turista { cansancio =  max 0 (cansancio turista - 5)}
 | otherwise = turista { stress = max 0 (stress turista - 1)}

apreciarAlgunElementoDelPaisaje :: String -> Turista -> Turista
apreciarAlgunElementoDelPaisaje paisaje turista = turista { stress = max 0 (stress turista - length paisaje)}

salirHablarIdioma :: String -> Turista -> Turista
salirHablarIdioma idioma turista 
 | idioma `elem`idiomas turista = turista 
 | otherwise = turista {
    viajaSolo = False,
    idiomas = idiomas turista ++ [idioma]
}   

caminar :: Int -> Turista -> Turista
caminar minutos turista = turista {
    cansancio = max 0 (cansancio turista - div minutos 4),
    stress = max 0 (stress turista - div minutos 4)
}


paseoEnBarco :: String -> Turista -> Turista
paseoEnBarco marea turista
 | marea == "Fuerte" = turista {cansancio = cansancio turista + 10, stress = stress turista + 6}
 | marea == "Tranquila" = (salirHablarIdioma "Aleman" . apreciarAlgunElementoDelPaisaje "mar" . caminar 10) turista
 | otherwise = turista

data Excursion = IrPlaya | ApreciarAlgunElementoDelPaisaje String | SalirHablarIdioma String | Caminar Int | PaseoEnBarco String

reducirStress :: Turista -> Turista
reducirStress turista = turista { stress = max 0 (stress turista - div (stress turista) 10) } 

turistaHaceExcursion :: Excursion -> Turista -> Turista
turistaHaceExcursion IrPlaya  = reducirStress . irPlaya
turistaHaceExcursion (ApreciarAlgunElementoDelPaisaje elemento)  = reducirStress . apreciarAlgunElementoDelPaisaje elemento
turistaHaceExcursion (SalirHablarIdioma idioma) = reducirStress . salirHablarIdioma idioma
turistaHaceExcursion (Caminar minutos) = reducirStress . caminar minutos
turistaHaceExcursion (PaseoEnBarco marea) = reducirStress . paseoEnBarco marea 

deltaSegun :: (a -> Int) -> a -> a -> Int
deltaSegun f algo1 algo2 = f algo1 - f algo2

deltaExcursionSegun :: (Turista -> Int) -> Turista -> Excursion -> Int
deltaExcursionSegun indice turista excursion = deltaSegun indice (turistaHaceExcursion excursion turista) turista

excursionEducativa :: Turista -> Excursion -> Bool
excursionEducativa turista excursion =
    deltaExcursionSegun (length . idiomas) turista excursion > 0

esDesestresante :: Turista -> Excursion -> Bool
esDesestresante turista excursion = abs (deltaExcursionSegun stress turista excursion) >= 3

completo :: Turista -> Turista
completo turista = foldr id turista [salirHablarIdioma "melmacquiano" , irPlaya , caminar 40 , apreciarAlgunElementoDelPaisaje "cascada" , caminar 20]

ladoB :: Excursion -> Turista -> Turista
ladoB excursion turista = foldr id turista [caminar 120 , turistaHaceExcursion excursion , paseoEnBarco "Tranquila"] 

islaVecina :: String -> Turista -> Turista
islaVecina marea turista 
 | marea == "Fuerte" = foldr id turista [paseoEnBarco "Fuerte" , apreciarAlgunElementoDelPaisaje "lago", paseoEnBarco "Fuerte"]
 | otherwise = foldr id turista [paseoEnBarco "Tranquila" , irPlaya , paseoEnBarco "Tranquila"]

aumentoDelStress :: [Excursion] -> Turista -> Turista
aumentoDelStress tour turista = turista { stress = stress turista + length tour } 

tour :: [Excursion] -> Turista -> Turista
tour excursiones turista = foldr  turistaHaceExcursion (aumentoDelStress excursiones turista) excursiones

data Tour = Completo | LadoB Excursion | IslaVecina String

esConvincente :: Turista -> [Tour] -> Bool
esConvincente turista = any (`esConvincenteParaTurista` turista) 

esConvincenteParaTurista :: Tour -> Turista -> Bool
esConvincenteParaTurista Completo turista = True
esConvincenteParaTurista (LadoB excursion) turista = esDesestresante turista excursion && not (viajaSolo turista)
esConvincenteParaTurista (IslaVecina _) _ = False -- No se considera convincente

espiritualidadTour :: Tour -> Turista -> Int
espiritualidadTour tour turista = sum (map (\excursion -> deltaExcursionSegun stress turista excursion + deltaExcursionSegun cansancio turista excursion) (excursionesParaTour tour))
  where
    excursionesParaTour :: Tour -> [Excursion]
    excursionesParaTour Completo = [SalirHablarIdioma "melmacquiano" , IrPlaya , Caminar 40 , ApreciarAlgunElementoDelPaisaje "cascada" , Caminar 20]
    excursionesParaTour (LadoB ex) = [Caminar 120, ex, PaseoEnBarco "Tranquila"]
    excursionesParaTour (IslaVecina "Tranquila") = [PaseoEnBarco "Tranquila", IrPlaya, PaseoEnBarco "Tranquila"]
    excursionesParaTour (IslaVecina "Fuerte") = [PaseoEnBarco "Fuerte", ApreciarAlgunElementoDelPaisaje "lago", PaseoEnBarco "Fuerte"]

efectividadTour :: Tour -> [Turista] -> Int
efectividadTour tour = sum . map (espiritualidadTour tour) . filter (esConvincenteParaTurista tour)