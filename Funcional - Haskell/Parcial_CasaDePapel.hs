import Text.Show.Functions
import Data.List

data Ladron = Ladron {
    nombreLadron :: String,
    habilidades :: [String],
    armas :: [Arma]
} deriving (Show)

data Rehen = Rehen {
    nombreRehen :: String,
    nivelDeComplot :: Int,
    nivelDeMiedo :: Int,
    plan :: [Plan]
} deriving (Show)

instance Eq Ladron where
    (==) ladron otroLadron = nombreLadron ladron == nombreLadron otroLadron

tokyo :: Ladron 
tokyo = Ladron "Ursula" ["trabajo psicologico", "entrar en moto"] [pistola 9, pistola 9, ametralladora 30]

profesor :: Ladron
profesor = Ladron "Profe" ["disfrazarse de linyera", "disfrazarse de payaso", "estar siempre un paso adelante"] []

pablo :: Rehen
pablo = Rehen "Pablo" 40 30 [esconderse]

arturito :: Rehen
arturito = Rehen "Arturo" 70 50 [esconderse, atacarAlLadron] -- ataca con Pablo

modificarMiedo :: Int -> Rehen -> Rehen
modificarMiedo valor rehen = rehen {nivelDeMiedo = nivelDeMiedo rehen + valor}

type Arma = Rehen -> Rehen

pistola :: Int -> Arma
pistola calibre rehen = 
    rehen {nivelDeComplot = max 0 (nivelDeComplot rehen - 5 * calibre), nivelDeMiedo = nivelDeMiedo rehen + 3 * length (nombreRehen rehen)} 

ametralladora :: Int -> Arma
ametralladora balasRestantes rehen =
    rehen {nivelDeComplot = nivelDeComplot rehen `div` 2, nivelDeMiedo = nivelDeMiedo rehen + balasRestantes}

cualGeneraMasMiedo :: Arma -> Arma -> Rehen -> Arma
cualGeneraMasMiedo pistola ametralladora rehen 
    | nivelDeMiedo (pistola rehen) > nivelDeMiedo (ametralladora rehen) = pistola
    | otherwise = ametralladora

disparar :: Arma -> Arma -> Rehen -> Rehen
disparar pistola ametralladora rehen = cualGeneraMasMiedo pistola ametralladora rehen rehen

hacerseElMalo :: Ladron -> Rehen -> Rehen
hacerseElMalo ladron rehen
    | ladron == tokyo = modificarMiedo (sum (map length (habilidades ladron))) rehen
    | ladron == profesor = rehen {nivelDeComplot = nivelDeComplot rehen + 20}
    | otherwise = modificarMiedo 10 rehen

eliminarArmas :: Int -> Rehen -> Rehen -> Ladron -> Ladron 
eliminarArmas valor rehen1 rehen2 ladron 
    | nivelDeComplot rehen1 >= nivelDeMiedo rehen1 && nivelDeComplot rehen2 >= nivelDeMiedo rehen2 = 
        ladron {armas = drop valor (armas ladron)}
    | otherwise = ladron

type Plan = Rehen -> Rehen -> Ladron -> Ladron

atacarAlLadron :: Plan
atacarAlLadron rehen1 rehen2 = eliminarArmas (length (nombreRehen rehen2)) rehen1 rehen2 

esconderse :: Plan
esconderse rehen1 rehen2 ladron = eliminarArmas (length(habilidades ladron) `div` 3) rehen1 rehen2 ladron

esInteligente :: Ladron -> Bool
esInteligente ladron = length (habilidades ladron) > 2

consigueArmaNueva :: Ladron -> Arma -> Ladron
consigueArmaNueva ladron arma = ladron {armas = armas ladron ++ [arma]}

-- pajaaa muy easy
