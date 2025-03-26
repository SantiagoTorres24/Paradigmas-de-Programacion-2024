puestoComida(hamburguesa, 2000).
puestoComida(panchos, 1500).
puestoComida(lomito, 2500).
puestoComida(caramelos, 0).

atraccion(tranquila(autitosChocadores, chicos)).
atraccion(tranquila(autitosChocadores, adultos)).
atraccion(tranquila(casaEmbrujada, chicos)).
atraccion(tranquila(casaEmbrujada, adultos)).
atraccion(tranquila(laberinto, chicos)).
atraccion(tranquila(laberinto, adultos)).
atraccion(tranquila(tobogan, chicos)).
atraccion(tranquila(calesita, chicos)).
atraccion(intensa(barcoPirata, 16)).
atraccion(intensa(tazasChinas, 6)).
atraccion(intensa(simular3D, 2)).
atraccion(montañaRusa(abismoMortalRecargada, 3, 134)).
atraccion(montañaRusa(paseoPorElBosque, 0, 45)).
atraccion(acuatica(torpedoSalpicon)).
atraccion(acuatica(esperoQueHayasTraidoUnaMudaDeRopa)).

% visitante(Nombre, Grupo, Edad, Dinero, Hambre, Aburrimiento).
visitante(eusebio, viejitos, 80, 3000, 50, 0).
visitante(carmela, viejitos, 80, 0, 0, 25).
visitante(santi, solo, 19, 10000000, 50, 0).
visitante(pp, solo, 19, 0, 0, 100).

esChico(Persona):-
    visitante(Persona, _, Edad, _, _, _),
    Edad < 13.
% 2)
felicidadPlena((_, _, _, _, 0, 0)):-
    not(visitante(_, solo, _, _, _, _)).
podriaEstarMejor((_, solo, _, _,0, 0)).
podriaEstarMejor((_, _, _, _, Hambre, Aburrimiento)):-
    between(1, 50, (Hambre + Aburrimiento)).
necesitaEntretenerse((_, _, _, _, Hambre, Aburrimiento)):-
    between(51, 99, (Hambre + Aburrimiento)).
seQuiereIrACasa((_, _, _, _, Hambre, Aburrimiento)):-
    Hambre + Aburrimiento > 100.

% 3) 
tieneDineroSuficiente(Persona, Comida):-
    visitante(Persona, _, _, Dinero, _, _),
    puestoComida(Comida, Precio),
    Dinero >= Precio.

quitaHambre(hamburguesa, Persona):-
    visitante(Persona, _, _, _, Hambre, _),
    Hambre < 50.
quitaHambre(panchos, Persona):-
    esChico(Persona).
quitaHambre(lomito, _).
quitaHambre(caramelos, Persona):-
    puestoComida(OtraComida, _),
    not(tieneDineroSuficiente(Persona, caramelos)),
    not(tieneDineroSuficiente(Persona, OtraComida)).

satisfaceGrupoConComida(Grupo, Comida):-
    visitante(_, Grupo, _, _, _, _),
    puestoComida(Comida, _),
    forall(visitante(Persona, _, _, _, _, _), 
    (tieneDineroSuficiente(Persona, Comida), quitaHambre(Comida, Persona))).

% 4)
subeAUnaAtraccion(intensa(_, CoeficienteLanzamiento), _):-
    CoeficienteLanzamiento > 10.
subeAUnaAtraccion(montañaRusa(Nombre, Giros, Duracion), Persona):-
    esPeligrosa(montañaRusa(Nombre, Giros, Duracion), Persona).
subeAUnaAtraccion(tranquila(tobogan, _), _).

esPeligrosa(montañaRusa(Nombre, Giros, _), Persona):-
    not(esChico(Persona)),
    atraccion(montañaRusa(OtroNombre, OtrosGiros, _)),
    Giros >= OtrosGiros,
    Nombre \= OtroNombre.
esPeligrosa(_, Persona):-
    not(necesitaEntretenerse(Persona)).
esPeligrosa(montañaRusa(_, _, Duracion), Persona):-
    esChico(Persona),
    Duracion > 60.

puedeProducirseLluviaDeHamburguesas(Persona, Atraccion):-
    tieneDineroSuficiente(Persona, hamburguesa),
    subeAUnaAtraccion(Atraccion, Persona).

% 5)
opcionesDeEntretenimiento(Persona, Mes, Comida, Atraccion):-
    tieneDineroSuficiente(Persona, Comida),
    subeAUnaAtraccion(acuatica(_), _),
    not(between(10, 12, Mes)),
    subeAUnaAtraccion(Atraccion, Persona).
opcionesDeEntretenimiento(Persona, _, _, tranquila(_, chicos)):-
    visitante(Persona, Grupo, _, _, _, _),
    visitante(OtraPersona, Grupo, _, _, _, _),
    esChico(OtraPersona),
    not(esChico(Persona)).

    
    
    

