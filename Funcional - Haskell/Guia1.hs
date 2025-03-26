--1) Definir la función esMultiploDeTres/1, que devuelve True si un número es múltiplo de 3
esMultiploDeTres :: Int -> Bool
esMultiploDeTres n = mod n 3 == 0

--2) Definir la función esMultiploDe/2, que devuelve True si el segundo es múltiplo del primero
esMultiploDeX :: Int ->Int -> Bool
esMultiploDeX x n = mod n x == 0

--3) Definir la función cubo/1, devuelve el cubo de un número.
cubo :: Int -> Int
cubo n = n*n*n

--4) Definir la función area/2, devuelve el área de un rectángulo a partir de su base y su altura.
area :: Int -> Int -> Int
area base altura = base*altura

{-5)Definir la función esBisiesto/1, indica si un año es bisiesto. (Un año es bisiesto si es divisible por 400 o es divisible por 4 pero no es 
divisible por 100) Nota: Resolverlo reutilizando la función esMultiploDe/2-}
esBisiesto :: Int -> Bool
esBisiesto año = (esMultiploDeX 400 año || esMultiploDeX 4 año) && not(esMultiploDeX 10 año)

--6) Definir la función celsiusToFahr/1, pasa una temperatura en grados Celsius a grados Fahrenheit.
celsiusToFahr :: Double -> Double
celsiusToFahr grados_celsius = (grados_celsius * 1.8) + 32

--7) Definir la función fahrToCelsius/1, la inversa de la anterior
fahrToCelsius :: Double -> Double
fahrToCelsius grados_fahr = (grados_fahr - 32) * 5/9

{-8) Definir la función haceFrioF/1, indica si una temperatura expresada en grados Fahrenheit es fría. Decimos que hace frío si la temperatura 
es menor a 8 grados Celsius.-}
haceFrio :: Double -> Bool
haceFrio temperatura = fahrToCelsius temperatura < 8

{-9) Definir la función mcm/2 que devuelva el mínimo común múltiplo entre dos números, de acuerdo a esta fórmula. 
m.c.m.(a, b) = {a * b} / {m.c.d.(a, b)} -}
mcm :: Int -> Int -> Int
mcm n1 n2 = div (n1*n2)(gcd n1 n2)

{-10) Dispersión
Trabajamos con tres números que imaginamos como el nivel del río Paraná a la altura de Corrientes medido en tres días consecutivos; cada 
medición es un entero que representa una cantidad de cm. 
P.ej. medí los días 1, 2 y 3, las mediciones son: 322 cm, 283 cm, y 294 cm. 
A partir de estos tres números, podemos obtener algunas conclusiones. 
Definir estas funciones: 

A) dispersion, que toma los tres valores y devuelve la diferencia entre el más alto y el más bajo. Ayuda: extender max y min a tres argumentos, 
usando las versiones de dos elementos. De esa forma se puede definir dispersión sin escribir ninguna guarda (las guardas están en max y min, 
que estamos usando). 

B) diasParejos, diasLocos y diasNormales reciben los valores de los tres días. Se dice que son días parejos si la dispersión es chica, que son 
días locos si la dispersión es grande, y que son días normales si no son ni parejos ni locos. Una dispersión se considera chica si es de menos
de 30 cm, y grande si es de más de un metro. 
Nota: Definir diasNormales a partir de las otras dos, no volver a hacer las cuentas. -}

dispersion :: Int -> Int -> Int -> Int
maximo :: Int -> Int -> Int -> Int
minimo :: Int -> Int -> Int -> Int

maximo dia1 dia2 dia3 = max dia1 (max dia2 dia3)
minimo dia1 dia2 dia3 = min dia1 (min dia2 dia3)

--A)
dispersion dia1 dia2 dia3 = maximo dia1 dia2 dia3 - minimo dia1 dia2 dia3

--B)
diasParejos :: Int -> Int -> Int -> Bool
diasLocos :: Int -> Int -> Int -> Bool
diasNormales :: Int -> Int -> Int -> Bool

diasParejos dia1 dia2 dia3 = dispersion dia1 dia2 dia3 < 30
diasLocos dia1 dia2 dia3 = dispersion dia1 dia2 dia3 > 100
diasNormales dia1 dia2 dia3 = not(diasParejos dia1 dia2 dia3) && not(diasLocos dia1 dia2 dia3)

{-11) En una plantación de pinos, de cada árbol se conoce la altura expresada en cm. El peso de un pino se puede calcular a partir de la altura 
así: 3 kg x cm hasta 3 metros, 2 kg x cm arriba de los 3 metros. P.ej. 2 metros ⇒  600 kg, 5 metros ⇒  1300 kg. 
Los pinos se usan para llevarlos a una fábrica de muebles, a la que le sirven árboles de entre 400 y 1000 kilos, un pino fuera de este rango 
no le sirve a la fábrica. Para esta situación: 
A)Definir la función pesoPino, recibe la altura de un pino y devuelve su peso. 
B)Definir la función esPesoUtil, recibe un peso en kg y devuelve True si un pino de ese peso le sirve a la fábrica, y False en caso contrario. 
C)Definir la función sirvePino, recibe la altura de un pino y devuelve True si un pino de ese peso le sirve a la fábrica, y False en caso 
contrario. Usar composición en la definición. -}

--A)
pesoPino :: Float -> Float
pesoPino altura 
 |altura <= 300 = altura * 3.0
 |otherwise     = 300 * 3.0 + 2.0*(altura - 300.0)

--B)
esPesoUtil :: Float -> Bool
esPesoUtil peso = (peso >= 400) && (peso <= 1000)

--C)
sirvePino :: Float -> Bool
sirvePino altura = esPesoUtil(pesoPino altura)


{-12) Este ejercicio alguna vez se planteó como un Desafío Café con Leche: Implementar la función esCuadradoPerfecto/1, sin hacer operaciones 
con punto flotante. Ayuda: les va a venir bien una función auxiliar, tal vez de dos parámetros. Pensar que el primer cuadrado perfecto es 0, 
para llegar al 2do (1) sumo 1, para llegar al 3ro (4) sumo 3, para llegar al siguiente (9) sumo 5, después sumo 7, 9, 11 etc.. También algo de 
recursividad van a tener que usar. -}

--esCuadradoPerfecto n = 

