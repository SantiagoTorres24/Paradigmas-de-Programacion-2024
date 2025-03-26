personaje(pumkin, ladron([licorerias, estacionesDeServicio])).
personaje(honeyBunny, ladron([licorerias, estacionesDeServicio])).
personaje(vincent, mafioso(maton)).
personaje(jules, mafioso(maton)).
personaje(marsellus, mafioso(capo)).
personaje(winston, mafioso(resuelveProblemas)).
personaje(mia, actriz([foxForceFive])).
personaje(butch, boxeador).

pareja(marsellus, mia).
pareja(pumkin, honeyBunny).

%trabajaPara(Empleador, Empleado)
trabajaPara(marsellus, vincent).
trabajaPara(marsellus, jules).
trabajaPara(marsellus, winston).

amigo(vincent, jules).
amigo(jules, jimmie).
amigo(vincent, elVendedor).

realizaActividadPeligrosa(Personaje):-
    personaje(Personaje, mafioso(maton)).
realizaActividadPeligrosa(Personaje):-
    personaje(Personaje, ladron(Robos)),
    member(licorerias, Robos).

tieneEmpleadosPeligrosos(Personaje):-
    trabajaPara(Personaje, Empleado),
    esPeligroso(Empleado).

esPeligroso(Personaje):-
    realizaActividadPeligrosa(Personaje),
    tieneEmpleadosPeligrosos(Personaje).

sonAmigosOPareja(Personaje, OtroPersonaje):-
    pareja(Personaje, OtroPersonaje).
sonAmigosOPareja(Personaje, OtroPersonaje):-
    amigo(Personaje, OtroPersonaje).

duoTemible(Personaje, OtroPersonaje):-
    esPeligroso(Personaje),
    esPeligroso(OtroPersonaje),
    sonAmigosOPareja(Personaje, OtroPersonaje),
    Personaje \= OtroPersonaje.
%encargo(Solicitante, Encargado, Tarea). 
%las tareas pueden ser cuidar(Protegido), ayudar(Ayudado), buscar(Buscado, Lugar)
encargo(marsellus, vincent,   cuidar(mia)).
encargo(vincent,  elVendedor, cuidar(mia)).
encargo(marsellus, winston, ayudar(jules)).
encargo(marsellus, winston, ayudar(vincent)).
encargo(marsellus, vincent, buscar(butch, losAngeles)).

estaEnProblemas(Personaje):-
    trabajaPara(Jefe, Personaje),
    esPeligroso(Jefe),
    pareja(Jefe, ParejaJefe),
    encargo(Jefe, Personaje, cuidar(ParejaJefe)).
estaEnProblemas(Personaje):-
    encargo(_, Personaje, buscar(Boxeador, _)),
    personaje(Boxeador, boxeador).

tieneCerca(Personaje, Cercano):-
    amigo(Personaje, Cercano).
tieneCerca(Personaje, Cercano):-
    pareja(Personaje, Cercano).

sanCayetano(Personaje):-
    personaje(Personaje, _),
    forall(tieneCerca(Personaje, Cercano), encargo(Personaje, Cercano, _)).

encontrarCantidadDeEncargos(Personaje, TotalEncargos):-
    findall(Encargo, encargo(_, Personaje, Encargo), Encargos),
    sumlist(Encargos, TotalEncargos).

masAtareado(Personaje):-
    forall((encontrarCantidadDeEncargos(OtroPersonaje, OtrosEncargos), 
    OtroPersonaje \= Personaje),
    encontrarCantidadDeEncargos(Personaje, Encargos),
    Encargos > OtrosEncargos).

esRespetable(Personaje):-
    personaje(Personaje, actriz[Peliculas]),
    length(Peliculas, CantidadPeliculas),
    9 < CantidadPeliculas / 10.
esRespetable(Personaje):-
    personaje(Personaje, mafioso(resuelveProblemas)).
esRespetable(Personaje):-
    personaje(Personaje, mafioso(capo)).

personajesRespetables(PersonajesRespetables):-
    findall(PersonajeRespetable, esRespetable(PersonajeRespetable), PersonajesRespetables).

requiereInteractuar(Personaje, OtroPersonaje, cuidar(OtroPersonaje)).
requiereInteractuar(Personaje, OtroPersonaje, cuidar(PersonajeACuidar)):-
    amigo(OtroPersonaje, PersonajeACuidar).
requiereInteractuar(Personaje, OtroPersonaje, ayudar(OtroPersonaje)).
requiereInteractuar(Personaje, OtroPersonaje, ayudar(PersonajeAAyudar)):-
    amigo(OtroPersonaje, PersonajeACuidar).
requiereInteractuar(Personaje, OtroPersonaje, buscar(OtroPersonaje, _)).
requiereInteractuar(Personaje, OtroPersonaje, buscar(PersonajeABuscar, _)):-
    amigo(OtroPersonaje, PersonajeABuscar).

hartoDe(Personaje, OtroPersonaje):-
    personaje(Personaje, _),
    personaje(OtroPersonaje, _),
    Personaje \= OtroPersonaje,
    forall(encargo(_, Personaje, Encargo), requiereInteractuar(Personaje, OtroPersonaje, Encargo)).

caracteristicas(vincent, [negro, muchoPelo, tieneCabeza]).
caracteristicas(jules, [tieneCabeza, muchoPelo]).
caracteristicas(marvin, [negro]).

tieneCaracteristicaYDuoNo(Personaje, DuoPersonaje):-
    caracteristicas(Personaje, CaracteristicasPersonaje),
    caracteristicas(DuoPersonaje, CaracteristicasDuoPersonaje),
    member(Caracteristica, CaracteristicasPersonaje),
    not(member(Caracteristica, CaracteristicasDuoPersonaje)).

duoDiferenciable(Personaje, DuoPersonaje):-
    Personaje \= DuoPersonaje,
    sonAmigosOPareja(Personaje, DuoPersonaje),
    tieneCaracteristicaYDuoNo(Personaje, DuoPersonaje).