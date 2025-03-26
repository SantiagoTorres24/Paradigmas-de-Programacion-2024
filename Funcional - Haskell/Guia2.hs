--1)Definir una función siguiente, que al invocarla con un número cualquiera me devuelve el resultado de sumar a ese número el 1. 
siguiente n = n + 1

--2)Definir la función mitad que al invocarla con un número cualquiera me devuelve la mitad de dicho número
mitad n =  n/2

--3)Definir una función inversa, que invocando a la función con un número cualquiera me devuelva su inversa
inversa n = 1/n

--4)Definir una función triple, que invocando a la función con un número cualquiera me devuelva el triple del mismo.
triple n = n * 3

--5)Definir una función esNumeroPositivo, que invocando a la función con un número cualquiera me devuelva true si el número es positivo y 
--false en caso contrario. 
esNumeroPositivo n = n > 0

--6)Resolver la función del ejercicio 2 de la guía anterior esMultiploDe/2, utilizando aplicación parcial y composición.
esMultiploDe :: Int -> Int -> Bool
esMultiploDe n x = (== 0) . (mod x ) $ n
noEsMultiploDe n x = (/= 0) . (mod x ) $ n

--7)Resolver la función del ejercicio 5 de la guía anterior esBisiesto/1, utilizando aplicación parcial y composición.
--esBisiesto año = 

--8)Resolver la función inversaRaizCuadrada/1, que da un número n devolver la inversa su raíz cuadrada. 
inversaRaizCuadrada  = inversa . sqrt 

--9)Definir una función incrementMCuadradoN, que invocándola con 2 números m y n, incrementa un valor n al cuadrado de m
incrementMCuadradoN m n = ((+n). (^2)) m

--10)Definir una función esResultadoPar/2, que invocándola con número n y otro m, devuelve true si el resultado de elevar n a m es par. 
esResultadoPar n m = ((even).(^m)) n