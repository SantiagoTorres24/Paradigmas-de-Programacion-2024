%tarea(agente, tarea, ubicacion)
%tareas:
%  ingerir(descripcion, tamaño, cantidad)
%  apresar(malviviente, recompensa)
%  asuntosInternos(agenteInvestigado)
%  vigilar(listaDeNegocios)

tarea(vigilanteDelBarrio, ingerir(pizza, 1.5, 2),laBoca).
tarea(vigilanteDelBarrio, vigilar([pizzeria, heladeria]), barracas).
tarea(canaBoton, asuntosInternos(vigilanteDelBarrio), barracas).
tarea(sargentoGarcia, vigilar([pulperia, haciendaDeLaVega, plaza]),puebloDeLosAngeles).
tarea(sargentoGarcia, ingerir(vino, 0.5, 5),puebloDeLosAngeles).
tarea(sargentoGarcia, apresar(elzorro, 100), puebloDeLosAngeles). 
tarea(vega, apresar(neneCarrizo,50),avellaneda).
tarea(jefeSupremo, vigilar([congreso,casaRosada,tribunales]),laBoca).

% Las ubicaciones que existen son las siguientes:
ubicacion(puebloDeLosAngeles).
ubicacion(avellaneda).
ubicacion(barracas).
ubicacion(marDelPlata).
ubicacion(laBoca).
ubicacion(uqbar).

% Por último, se sabe quién es jefe de quién:
%jefe(jefe, subordinado)
jefe(jefeSupremo,vega ).
jefe(vega, vigilanteDelBarrio).
jefe(vega, canaBoton).
jefe(jefeSupremo,sargentoGarcia).

% 1)
frecuenta(vega, quilmes).
frecuenta(_, buenosAires).
frecuenta(Agente, marDelPlata):-
    tarea(Agente, vigilar(LugaresAVigilar), _),
    member(negocioAlfajores, LugaresAVigilar).
frecuenta(Agente, Ubicacion):-
    tarea(Agente, _, Ubicacion).

% 2) No hace falta agregar predicados a la base de conociemientos para saber si un lugar
% es inaccesible

% 3)
afincado(Agente):-
    tarea(Agente, _, Ubicacion),
    forall(tarea(Agente, _, OtraUbicacion), Ubicacion = OtraUbicacion).

% 4)
cadenaDeMando([_]).
cadenaDeMando([Primero, Segundo | Resto]):-
    jefe(Primero, Segundo),
    cadenaDeMando([Segundo | Resto]).

% 5)
agentePremiado(Agente):-
    tarea(Agente, _, _), 
    puntosDeAgente(Agente, Puntos),
    forall((puntosDeAgente(OtroAgente, OtrosPuntos), Agente \= OtroAgente),
            Puntos >= OtrosPuntos).

puntosDeAgente(Agente, PuntosTotales)
    findall(Punto, (tarea(Agente, Tarea, _), puntosPorTarea(Tarea, Punto)), Puntos),
    sumlist(Puntos, PuntosTotales).

puntosPorTarea(vigilar(LugaresAVigilar), Puntos):-
    length(LugaresAVigilar, CantidadDeLugares),
    Puntos is CantidadDeLugares* 5.
puntosPorTarea(ingerir(_, Tamanio, Cantidad), Puntos):-
    Puntos is -10 * Tamanio * Cantidad.
puntosPorTarea(apresar(_, Recompensa), Puntos):-
    Puntos is Recompensa / 2.
puntosDeAgente(asuntosInternos(AgenteInvestigado), Puntos):-
    puntosDeAgente(AgenteInvestigado, PuntosInvestigado),
    Puntos is PuntosInvestigado * 2.



    