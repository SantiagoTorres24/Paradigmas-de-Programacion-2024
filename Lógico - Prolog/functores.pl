/* En un juego de "construya su cañería", hay piezas de distintos tipos: codos, caños 
y canillas.
De los codos me interesa el color, p.ej. un codo rojo.
De los caños me interesan color y longitud, p.ej. un caño rojo de 3 metros.
De las canillas me interesan: tipo (de la pieza que se gira para abrir/cerrar), color 
y ancho (de la boca).
P.ej. una canilla triangular roja de 4 cm de ancho.
Definir un predicado que relacione una cañería con su precio. Una cañería es una lista 
de piezas. Los precios son:
codos: $5.
caños: $3 el metro.
canillas: las triangulares $20, del resto $12 hasta 5 cm de ancho, $15 si son de más 
de 5 cm.
*/

% Definicion de las Piezas
precio(codo(Color)).
precio(caño(Color, Longitud)).
precio(canilla(Tipo, Color, Ancho)).

% Precios

precio(codo(_), 5).
precio(caño(_, Longitud), 3 * Longitud).
precio(canilla(triangular, _, _), 20).
precio(canilla(_, _, Ancho), 12):-
    Ancho =< 0.5.
precio(canilla(_, _, Ancho), 15):-
    Ancho > 0.5.

/* Definir el predicado puedoEnchufar/2, tal que puedoEnchufar(P1,P2) se verifique si 
puedo enchufar P1 a la izquierda de P2. Puedo enchufar dos piezas si son del mismo 
color, o si son de colores enchufables. Las piezas azules pueden enchufarse a la 
izquierda de las rojas, y las rojas pueden enchufarse a la izquierda de las negras. 
Las azules no se pueden enchufar a la izquierda de las negras, tiene que haber una 
roja en el medio. P.ej.
sí puedo enchufar (codo rojo, caño negro de 3 m).
sí puedo enchufar (codo rojo, caño rojo de 3 m) (mismo color).
no puedo enchufar (caño negro de 3 m, codo rojo) (el rojo tiene que estar a la 
izquierda del negro).
no puedo enchufar (codo azul, caño negro de 3 m) (tiene que haber uno rojo en el medio).
*/

color(codo(Color), Color).
color(cano(Color, _), Color).
color(canilla(_, Color, _), Color).

enchufables(azul, rojo).
enchufables(rojo, negro).

puedoEnchufar(Pieza1, Pieza2):-
    color(Pieza1, Color),
    color(Pieza2, Color).
puedoEnchufar(Pieza1, Pieza2):-
    color(Pieza1, Color1),
    color(Pieza2, Color2),
    enchufables(Color1, Color2).

/* Modificar el predicado puedoEnchufar/2 de forma tal que pueda preguntar por elementos
sueltos o por cañerías ya armadas. 
P.ej. una cañería (codo azul, canilla roja) la puedo enchufar a la izquierda de un 
codo rojo (o negro), y a la derecha de un caño azul. Ayuda: si tengo una cañería a la 
izquierda, ¿qué color tengo que mirar? Idem si tengo una cañería a la derecha.*/
color_ultimo([Pieza], Color) :-
    color(Pieza, Color).
color_ultimo([_ | Resto], Color) :-
    color_ultimo(Resto, Color).