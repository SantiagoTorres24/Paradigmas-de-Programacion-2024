% Relaciona al dueño con el nombre del juguete y la cantidad de años que lo ha tenido
duenio(andy, woody, 8).
duenio(sam, jessie, 3).
% Relaciona al juguete con su nombre
% los juguetes son de la forma:
% deTrapo(tematica)
% deAccion(tematica, partes)
% miniFiguras(tematica, cantidadDeFiguras)
% caraDePapa(partes)
juguete(woody, deTrapo(vaquero)).
juguete(jessie, deTrapo(vaquero)).
juguete(buzz, deAccion(espacial, [original(casco)])).
juguete(soldados, miniFiguras(soldado, 60)).
juguete(monitosEnBarril, miniFiguras(mono, 50)).
juguete(señorCaraDePapa,
caraDePapa([ original(pieIzquierdo),
original(pieDerecho),
repuesto(nariz) ])).

% Dice si un juguete es raro
esRaro(deAccion(stacyMalibu, 1, [sombrero])).
% Dice si una persona es coleccionista
esColeccionista(sam).

% 1A)
tematica(deTrapo(Tematica), Tematica).
tematica(deAccion(Tematica, _), Tematica).
tematica(miniFiguras(Tematica, _), Tematica).
tematica(caraDePapa(_), caraDePapa).

% 1B)
esDePlastico( miniFiguras(_, _)).
esDePlastico(caraDePapa(_)).

% 1C)
esDeColeccion(deTrapo(_)).
esDeColeccion(deAccion(_, _)):-
    esRaro(deAccion(_, _)).
esDeColeccion(caraDePapa(_)):-
    esRaro(caraDePapa(_)).

% 2)
amigoFiel(Duenio, NombreJuguete):-
    duenio(Duenio, NombreJuguete, Anios),
    juguete(NombreJuguete, Juguete),
    not(esDePlastico(Juguete)),
    forall((juguete(Duenio, OtroNombreJuguete, OtroAnio), 
           NombreJuguete \= OtroNombreJuguete),
           Anios > OtroAnio).

% 3)
superValioso(NombreJuguetesValiosos):-
    findall(NombreJuguete, esValioso(NombreJuguete), NombreJuguetesValiosos).

esValioso(NombreJuguete):-
    juguete(NombreJuguete, Juguete),
    esDeColeccion(Juguete),
    not(duenio(Duenio, NombreJuguete, _)),
    esColeccionista(Duenio),
    tienePartesOriginales(Juguete).

tienePartesOriginales(deTrapo(_)).
tienePartesOriginales(deAccion(_, Partes)):-
    not(member(repuesto(_), Partes)).
tienePartesOriginales(miniFiguras(_, _)).
tienePartesOriginales(caraDePapa(Partes)):-
    not(member(repuesto(_), Partes)).

% 4)
duoDinamico(Duenio, NombreJuguete1, NombreJuguete2):-
    duenio(Duenio, NombreJuguete1, _),
    duenio(Duenio, NombreJuguete2, _),
    NombreJuguete1 \= NombreJuguete2,
    hacenBuenaPareja(NombreJuguete1, NombreJuguete2).

hacenBuenaPareja(woody, buzz).
hacenBuenaPareja(NombreJuguete1, NombreJuguete2):-
    juguete(NombreJuguete1, Juguete1),
    juguete(NombreJuguete2, Juguete2),
    tematica(Juguete1, Tematica),
    tematica(Juguete2, Tematica).

% 5)
felicidad(Duenio, CantidadDeFelicidad):-
    duenio(Duenio, _, _),
    findall(Felicidad, (duenio(Duenio, NombreJuguete, _), juguete(NombreJuguete, Juguete),
    felicidadPorJuguete(Duenio, Juguete, Felicidad)), FelicidadTotal),
    sumlist(FelicidadTotal, CantidadDeFelicidad).

felicidadPorJuguete(_, miniFiguras(_, CantidadFiguras), Felicidad):-
    Felicidad is CantidadDeFelicidad * 20.
felicidadPorJuguete(_, caraDePapa(Piezas), Felicidad):-
    encontrarPiezas(Piezas, PiezasOriginales, PiezasDeRepuesto),
    Felicidad is (PiezasOriginales * 5 + PiezasDeRepuesto * 8).
felicidadPorJuguete(_, deTrapo(_), 100).
felicidadPorJuguete(Duenio, deAccion(_, _), 120):-
    esColeccionista(Duenio),
    esDeColeccion(deAccion(_, _)).
felicidadPorJuguete(_, deAccion(_, _), 100):-
    not(esColeccionista(deAccion(_, _))).

encontrarPiezas(Piezas, CantidadPiezasOriginales, CantidadPiezasDeRepuesto):-
    findall(PiezaOriginal, member(original(PiezaOriginal), Piezas), PiezasOriginales),
    findall(PiezaRepuesto, member(repuesto(PiezaRepuesto), Piezas), PiezasRepuesto),
    length(PiezasOriginales, CantidadPiezasOriginales),
    length(PiezaRepuesto, CantidadPiezasDeRepuesto).

% 6)
puedeJugarCon(Alguien, NombreJuguete):-
    duenio(Alguien, NombreJuguete, _).
puedeJugarCon(Alguien, NombreJuguete):-
    puedeJugarCon(Otro, NombreJuguete),
    puedePrestar(Otro, Alguien),
    Alguien \= Otro.

puedePrestar(Otro, Alguien):-
    encontrarCantidadDeJuguetes(Otro, JuguetesDeOtro),
    encontrarCantidadDeJuguetes(Alguien, JuguetesDeAlguien),
    JuguetesDeOtro >= JuguetesDeAlguien
    
encontrarCantidadDeJuguetes(Persona, CantidadDeJuguetes):-
    duenio(Persona, _, _),
    findall(Juguete, duenio(Persona, Juguete, _), Juguetes),
    length(Juguetes, CantidadDeJuguetes).

% 7)
podriaDonar(Duenio, JuguetesDuenio, Felicidad):-
    duenio(Duenio, _, _),
    findall(FelicidadJuguete, (member(Juguete, JuguetesDuenio),
            felicidadPorJuguete(Duenio, Juguete, FelicidadJuguete)), FelicidadJuguetes),
    sumlist(FelicidadJuguetes, FelicidadDeLosJuguetes),
    Felicidad > FelicidadDeLosJuguetes.