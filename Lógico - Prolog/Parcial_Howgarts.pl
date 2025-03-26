% persona(Nombre, TipoSangre, Caracteristicas, CasaOdiada).
persona(harry, mestiza, [coraje, amistad, orgullo, inteligencia], slytherin).
persona(draco, pura, [inteligencia, orgullo], hufllepuff).
persona(hermione, impura, [inteligencia, orgullo, responsabilidad], _).

casa(gryffindor).
casa(slytherin).
casa(ravenclaw).
casa(hufllepuff).

%%%%%%%%%%%%%%%%%%%%%%%%%%%% SOMBRERO SELECCIONADOR %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 1)
permiteEntrar(Mago, Casa):-
    casa(Casa),
    persona(Mago, _, _, _),
    Casa \= slytherin.
permiteEntrar(Mago, slytherin):-
    persona(Mago, TipoSangre, _, _),
    TipoSangre \= impura.

% 2)
caracterApropiado(Mago, gryffindor):-
    persona(Mago, _, Caracteristicas, _),
    member(coraje, Caracteristicas).
caracterApropiado(Mago, slytherin):-
    persona(Mago, _, Caracteristicas, _),
    member(orgullo, Caracteristicas),
    member(inteligencia, Caracteristicas).
caracterApropiado(Mago, ravenclaw):-
    persona(Mago, _, Caracteristicas, _),
    member(inteligencia, Caracteristicas),
    member(responsabilidad, Caracteristicas).
caracterApropiado(Mago, hufllepuff):-
    persona(Mago, _, Caracteristicas, _),
    member(amistad, Caracteristicas).

% 3)
casaParaMago(Mago, Casa):-
    persona(Mago, _, _, CasaOdiada),
    caracterApropiado(Mago, Casa),
    permiteEntrar(Mago, Casa),
    CasaOdiada \= Casa.
casaParaMago(hermione, gryffindor).

% 4)
esAmistoso(Mago):-
    persona(Mago, _, Caracteristicas, _),
    member(amistad, Caracteristicas).

puedenEstarEnMismaCasa(Mago1, Mago2):-
    casaParaMago(Mago1, Casa1),
    casaParaMago(Mago2, Casa2),
    Casa1 = Casa2.

cadenaDeAmistades([_]).
cadenaDeAmistades([Mago1, Mago2 | Resto]):-
    esAmistoso(Mago1),
    esAmistoso(Mago2),
    puedenEstarEnMismaCasa(Mago1, Mago2),
    cadenaDeAmistades(Mago2, Resto).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% LA COPA DE LAS CASAS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
acciones(harry, [fueraDeLaCama, bosque, tercerPiso, vencerAVoldemort], 0).
acciones(hermione, [tercerPiso, seccionRestringida, salvarAmigos], 0).
acciones(draco, [mazmorras], 0).
acciones(ron, [ganarAjedrez], 50).

accionMala(fueraDeLaCama).
accionMala(bosque).
accionMala(seccionRestringida).
accionMala(tercerPiso).

accionBuena(ganarAjedrez).
accionBuena(salvarAmigos).
accionBuena(vencerAVoldemort).

esDe(hermione, gryffindor).
esDe(ron, gryffindor).
esDe(harry, gryffindor).
esDe(draco, slytherin).
esDe(luna, ravenclaw).

% 1A)
buenAlumno(Mago) :-
    acciones(Mago, Acciones, _),
    Acciones \= [],
    not((member(Accion, Acciones), accionMala(Accion))).

% 1B)
accionRecurrente(Accion):-
    acciones(Mago, Acciones, _),
    acciones(OtroMago, OtrasAcciones, _),
    member(Accion, Acciones),
    member(Accion, OtrasAcciones),
    Mago \= OtroMago.

% 2)
puntajeTotalCasa(Casa, PuntajeTotal):-
    findall(Puntaje, (esDe(Mago, Casa), acciones(Mago, _, Puntaje)), Puntajes),
    sumlist(Puntajes, PuntajeTotal).

% 3) 
casaGanadora(CasaGanadora):-
    findall(Casa, esDe(_, Casa), Casas),
    findall(PuntajeTotal-Casa, (member(Casa, CasasUnicas), puntajeTotalCasa(Casa, PuntajeTotal)), PuntajesCasas),
    max_member(MaxPuntaje-CasaGanadora, PuntajesCasas),
    \+ (member(OtroPuntaje-_, PuntajesCasas), OtroPuntaje > MaxPuntaje).

% 4) 

