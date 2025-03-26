% Dodain se va a Pehuenia, San Martín (de los Andes), Esquel, Sarmiento, Camarones y 
% Playas Doradas
destino(dodain, pehuenia).
destino(dodain, sanMartin).
destino(dodain, esquel).
destino(dodain, sarmiento).
destino(dodain, camarones).
destino(dodain, playasDoradas).

% Alf, en cambio, se va a Bariloche, San Martín de los Andes y El Bolsón
destino(alf, bariloche).
destino(alf, sanMartin).
destino(alf, elBolson).

% Nico se va a Mar del Plata, como siempre
destino(nico, marDelPlata).

% Y Vale se va para Calafate y El Bolsón.
destino(vale, calafate).
destino(vale, elBolson).

% Martu se va donde vayan Nico y Alf. 
destino(martu, Destinos):-
    destino(nico, Destinos).
destino(martu, Destinos):-
    destino(alf, Destinos).
destino(santi, esquel).
destino(santi, pehuenia).
% Juan no sabe si va a ir a Villa Gesell o a Federación
% No hay certeza de a donde va Juan, entonces no agrego nada a mi base de conociemientos

% Carlos no se va a tomar vacaciones por ahora
% No va a niingun lado, no hace falta agregarlo pq todo lo q no este en mi base de
% concimientos se considera como falso

% Esquel tiene como atracciones un parque nacional (Los Alerces) y dos excursiones 
% (Trochita y Trevelin). 
atracciones(esquel, parque(losAlerces)).
atracciones(esquel, excursion(trochita)).
atracciones(esquel, excursion(trevelin)).

/*Villa Pehuenia tiene como atracciones un cerro (Batea Mahuida de 2.000 m) y dos 
cuerpos de agua (Moquehue, donde se puede pescar y tiene 14 grados de temperatura 
promedio y Aluminé, donde se puede pescar y tiene 19 grados de temperatura promedio). */
atracciones(pehuenia, cerro(bateaMahuida, 2000)).
atracciones(pehuenia, cuerpoDeAgua(puedePescar, 14)).
atracciones(pehuenia, cuerpoDeAgua(noPuedePescar, 19)).

% un cerro es copado si tiene más de 2000 metros
atraccionCopada(cerro(_, Altura)):-
    Altura > 2000.
% un cuerpoAgua es copado si se puede pescar o la temperatura es mayor a 20
atraccionCopada(cuerpoDeAgua(puedePescar, Temperatura)):-
    Temperatura > 20.
% una playa es copada si la diferencia de mareas es menor a 5
atraccionCopada(playa(DiferenciaMareas)):-
    DiferenciaMareas =< 5.
atraccionCopada(excursion(Nombre)):-
    atom_length(Nombre, Tamanio),
    Tamanio > 7.
% cualquier parque nacional es copado
atraccionCopada(parque(_)).

% Queremos saber qué vacaciones fueron copadas para una persona. Esto ocurre cuando 
% todos los lugares a visitar tienen por lo menos una atracción copada. 
vacacionesCopadas(Persona):-
    destino(Persona, _),
    forall(destino(Persona, Destino),
    (atracciones(Destino, Atraccion), atraccionCopada(Atraccion))).

% Cuando dos personas distintas no coinciden en ningún lugar como destino decimos que 
% no se cruzaron.
noSeCruzaron(Persona, OtraPersona):-
    Persona \= OtraPersona,
    forall(destino(Persona, Destino), not(destino(OtraPersona, Destino))).

% Incorporamos el costo de vida de cada destino
costoDeVida(sarmiento, 100).
costoDeVida(esquel, 150).
costoDeVida(pehuenia, 180).
costoDeVida(sanMartin, 150).
costoDeVida(camarones, 135).
costoDeVida(playasDoradas, 170).
costoDeVida(bariloche, 140).
costoDeVida(calafate, 240).
costoDeVida(elBolson, 145).
costoDeVida(marDelPlata, 140).

% Queremos saber si unas vacaciones fueron gasoleras para una persona. Esto ocurre si 
% todos los destinos son gasoleros, es decir, tienen un costo de vida menor a 160.
destinoGasolero(Destino):-
    costoDeVida(Destino, CostoDeVida),
    CostoDeVida < 160.
vacacionesGasoleras(Persona):-
    destino(Persona, _),
    forall(destino(Persona, Destino), destinoGasolero(Destino)).

% Queremos conocer todas las formas de armar el itinerario de un viaje para una persona 
% sin importar el recorrido. Para eso todos los destinos tienen que aparecer en la 
% solución (no pueden quedar destinos sin visitar).
itinerario(Persona, Lista):-
    destino(Persona, _),
    findall(Destino, destino(Persona, Destino), Destinos),
    permutation(Destinos, Lista),
    distinct(Lista, permutation(Destinos, Lista)).
    
