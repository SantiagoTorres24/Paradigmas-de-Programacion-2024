--1)Definir las funciones fst3, snd3, trd3, que dada una tupla de 3 elementos devuelva el elemento correspondiente
fst3 (x, _, _) = x
snd3 (_, y, _) = y
trd3 (_, _, z) = z

--2)Definir la función aplicar, que recibe como argumento una tupla de 2 elementos con funciones y un entero, me devuelve como resultado una 
--tupla con el resultado de aplicar el elemento a cada una de la funciones

doble n = 2 * n
triple n = 3 * n

aplicar (f,g) x = (f x, g x)

--3)Definir la función cuentaBizarra, que recibe un par y: si el primer elemento es mayor al segundo devuelve la suma, si el segundo le lleva 
--más de 10 al primero devuelve la resta 2do – 1ro, y si el segundo es más grande que el 1ro pero no llega a llevarle 10, devuelve el producto.
cuentaBizarra (x,y) 
    | x > y = x + y
    | (y - x)> 10 = y - x
    | otherwise = x * y

{-4) Representamos las notas que se sacó un alumno en dos parciales mediante un par (nota1,nota2), p.ej. un patito en el 1ro y un 7 en el 2do se 
representan mediante el par (2,7). A partir de esto: -}
--A) Definir la función esNotaBochazo, recibe un número y devuelve True si no llega a 6, False en caso contrario. No vale usar guardas. 
esNotaBochazo x = not (x >= 6)
--B) Definir la función aprobo, recibe un par e indica si una persona que se sacó esas notas aprueba. Usar esNotaBochazo. 
aprobo (x,y)  = not(esNotaBochazo x) && not(esNotaBochazo y)
--C) Definir la función promociono, que indica si promocionó, para eso tiene las dos notas tienen que sumar al menos 15 y además haberse sacado 
--al menos 7 en cada parcial. 
promociono (x,y) = ((x + y) >= 15) && (x >= 7) && (y >= 7)
--D) Escribir una consulta que dado un par indica si aprobó el primer parcial, usando esNotaBochazo y composición.
--consulta (x,y) = (aproboPrimerParcial . esNotaBochazo) x
consulta = (not.esNotaBochazo).fst

{-5) Siguiendo con el dominio del ejercicio anterior, tenemos ahora dos parciales con dos recuperatorios, lo representamos mediante un par de 
pares ((parc1,parc2),(recup1,recup2)). 
Si una persona no rindió un recuperatorio, entonces ponemos un "-1" en el lugar correspondiente. 
Observamos que con la codificación elegida, siempre la mejor nota es el máximo entre nota del parcial y nota del recuperatorio. 
Considerar que vale recuperar para promocionar. En este ejercicio vale usar las funciones que se definieron para el anterior. -}
--A)Definir la función notasFinales que recibe un par de pares y devuelve el par que corresponde a las notas finales del alumno para el 1er y 
--el 2do parcial. 
notasFinales :: ((Int, Int), (Int, Int)) -> (Int, Int)
notasFinales ((parc1, parc2),(recup1,recup2)) = (max parc1 recup1, max parc2 recup2)
--B) Escribir la consulta que indica si un alumno cuyas notas son ((2,7),(6,-1)) recursa o no. O sea, la respuesta debe ser True si recursa, y 
--False si no recursa. Usar las funciones definidas en este punto y el anterior, y composición. 
recursa (x,y) = x <= 6 && y <= 6
recursaConsulta  = recursa . notasFinales
--C) Escribir la consulta que indica si un alumno cuyas notas son ((2,7),(6,-1)) recuperó el primer parcial. Usar composición. 
recuperoPrimerParcial  =  ((>0).fst.snd)
--D) Definir la función recuperoDeGusto que dado el par de pares que representa a un alumno, devuelve True si el alumno, pudiendo promocionar 
--con los parciales (o sea sin recup.), igual rindió al menos un recup. Vale definir funciones auxiliares. Hacer una definición que no use 
--pattern matching, en las eventuales funciones auxiliares tampoco; o sea, manejarse siempre con fst y snd.
recuperoDeGusto ((parc1, parc2),(recup1,recup2)) = (parc1 >= 8 && parc2 >= 8)  && (recup1 > 0 || recup2 > 0)

--6) Definir la función esMayorDeEdad, que dada una tupla de 2 elementos (persona, edad) me devuelva True si es mayor de 21 años y False en 
--caso contrario.
esMayorDeEdad :: (String, Int) -> Bool
esMayorDeEdad = ((>21).snd)


--7)Definir la función calcular, que recibe una tupla de 2 elementos, si el primer elemento es par lo duplica, sino lo deja como está y con el 
--segundo elemento en caso de ser impar le suma 1 y si no deja esté último como esta. 
calcular :: (Int, Int) -> (Int, Int)
calcular (num1, num2)
    | even num1 = (2 * num1, num2)
    | odd num2 = (num1, num2 +1)
    | otherwise = (num1, num2)
