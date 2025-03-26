/*
BASE INICIAL

guardia(Nombre).
prisionero(Nombre, Crimen).
*/

% 1) Indicar si controla/2 es inversible

controla(piper, alex). % No hay variable, no tienen problema
controla(bennett, dayanara).
controla(Guardia, Otro):- 
    prisionero(Otro, _), % No hay problema siempre y cuando prisionero es inversible (lo es).
    not(controla(Otro, Guardia)).% Guardia se usa por 1ra vez en un not (no es inversible) por lo que para guardia no es inversible
% Entonces controla/2 es inversible solo para la 2da variable (Otro) y no para la 1ra (Guardia).

% 2) confilictoDeInteres/2:
%    Relaciona a dos personas distintas si no se controlan mutuamente y existe algun 
%    tercero al cual ambos controlan.
confilictoDeInteres(Persona1, Persona2):-
    controla(Persona1, Persona3),
    controla(Persona2, Persona3),
    not(controla(Persona1, Persona2)),
    not(controla(Persona2, Persona1)),
    Uno \= Otro. % Controla 1ro para inversivilidad
/*
3) peligroso/1:
Se cumple para un preso que solo cometio crimenes graves.
    - Un robo nunca es grave.
    - Un homicidio siempre es grave.
    - Un delito de narcotrafico es grave cuando incluye al menos 5 drogas a la vez, o
    incluye metanfetaminas. */
peligroso(Prisionero):-
    prisionero(Prisionero, _),
    forall(prisionero(Prisionero, Crimen), grave(Crimen)).

grave(homicidio(_)).
grave(narcotrafico(Drogas)):-
    member(metanfetaminas, Drogas).
grave(narcotrafico(Drogas)):-
    length(Drogas, Total),
    Total >= 5.

% 4) ladronDeGuanteBlanco: Aplica a un prisionero si solo cometio robos y todos fueron
% por mas de $100.000.
robo(robo(Monto), Monto).

ladronDeGuanteBlanco(Prisionero):-
    prisionero(Prisionero, _),
    forall(prisionero(Prisionero, Crimen), (robo(Crimen, Monto), Monto > 100.00)).
/*
5) condena/2: Relaciona a un prisionero con la cantidad total de años de condena que
debe complir:
    - La cantidad de dinero robado divido 10.000
    - 7 años por cada homicidio cometido, mas 2 años extra si la victima era un guardia.
    - 2 años por cada droga que haya traficado.
*/

pena(robo(Monto), Pena):- Pena is Monto / 10000.
pena(homicidio(Victima), 9):- guardia(Victima).
pena(homicidio(Victima), 7):- not(guardia(Victima)).
pena(narcotrafico(Drogas), Pena):-
    length(Drogas, Total),
    Pena is 2 * Total.

condena(Prisionero, CondenaTotal):-
    prisionero(Prisionero, _),
    findall(Pena, (prisionero(Prisionero, Crimen), pena(Crimen, Pena)), Penas),
    sumlist(Penas, CondenaTotal).

/*
6) capo/1: Se dice que un preso es el capo de todos los capos cuando nadie lo controla,
pero todas las personas de la carcel (guardias o personas) son controlados por el, o 
por alguien a quien el controla (directa o indirectamente).
*/
persona(Persona):-
    prisionero(Persona,_).
persona(Persona):-
    guardia(Persona).

controlaDirectaOIndirectamente(Uno, Otro):-
    controla(Uno, Otro).
controlaDirectaOIndirectamente(Uno, Otro):-
    controla(Uno, Alguien),
    controlaDirectaOIndirectamente(Alguien, Otro).
capo(Capo):-
    prisionero(Capo, _),
    not(controla(_, Capo)),
    forall(persona(Persona), controlaDirectaOIndirectamente(Capo, Persona)).