% 1)
cree(gabriel, campanita).
cree(gabriel, magoDeOz).
cree(gabriel, cavenaghi).
cree(juan, conejoDePascua).
cree(macarena, reyesMagos).
cree(macarena, magoCapria).
cree(macarena, campanita).

% sueños(cantante(Discos)).
% sueños(futbolista(Equipo)).
% sueños(loteria(Numeros)).

suenios(gabriel, loteria([5, 9])).
suenios(gabriel, futbolista(arsenal)).
suenios(juan, cantante(100000)).
suenios(macarena, cantante(10000)).

% 2)
dificultadSuenio(cantante(Discos), 6):-
    Discos > 500000.
dificultadSuenio(cantante(_), 4).
dificultadSuenio(loteria(Numeros), Dificultad):-
    length(Numeros, CantidadNumeros),
    Dificultad is CantidadNumeros * 10.
dificultadSuenio(futbolista(arsenal), 3).
dificultadSuenio(futbolista(aldosivi), 3).
dificultadSuenio(futbolista(_), 16).

esAmbiciosa(Persona):-
    cree(Persona, _),
    findall(Dificultad, 
    (suenios(Persona, Suenio), dificultadSuenio(Suenio, Dificultad)), Dificultades),
    sumlist(Dificultades, DificultadTotal),
    DificultadTotal > 20.

% 3)
personajeTieneQuimicaConPersona(Personaje, Persona):-
    cree(Persona, Personaje),
    quimicaSegunSueño(Personaje, Persona).

suenioPuro(futbolista(_)).
suenioPuro(cantante(Discos)):-
    Discos =< 200000.

quimicaSegunSueño(campanita, Persona):-
    suenios(Persona, Suenio),
    dificultadSuenio(Suenio, Dificultad),
    Dificultad =< 5.
quimicaSegunSueño(_, Persona):-
    forall(suenios(Suenio, Persona), (suenioPuro(Suenio), not(esAmbiciosa(Persona)))).

% 4)
amigos(campanita, reyesMagos).
amigos(campanita, conejoDePascua).
amigos(conejoDePascua, cavenaghi).
enfermo(campanita).
enfermo(reyesMagos).
enfermo(conejoDePascua).

esAmigoDirectoOIndirecto(Personaje, OtroPersonaje):-
    amigos(Personaje, OtroPersonaje).
esAmigoDirectoOIndirecto(Personaje, OtroPersonaje):-
    amigos(Personaje, AlgunPersonaje),
    esAmigoDirectoOIndirecto(AlgunPersonaje, OtroPersonaje).

personajePuedeAlegrarPersona(Personaje, Persona):-
    suenios(Persona, _),
    personajeTieneQuimicaConPersona(Personaje, Persona),
    not(enfermo(Personaje)),
    esAmigoDirectoOIndirecto(Personaje, PersonajeBackUp),
    not(enfermo(PersonajeBackUp)).