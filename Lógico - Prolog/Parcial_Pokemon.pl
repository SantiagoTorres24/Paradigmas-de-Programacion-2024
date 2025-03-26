% PARTE 1: POKEDEX
pokemon(pikachu, electrico).
pokemon(charizard, fuego).
pokemon(venusaur, planta).
pokemon(blastoise, agua).
pokemon(totodile, agua).
pokemon(snorlax, normal).
pokemon(rayquaza, dragon).
pokemon(rayquaza, volador).

entrenador(ash, pikachu).
entrenador(ash, charizard).
entrenador(brock, snorlax).
entrenador(misty, blastoise).
entrenador(misty, venusaur).
entrenador(misty, arceus).

% 1)
tipoMultiple(Pokemon):-
    pokemon(Pokemon, Tipo),
    pokemon(Pokemon, OtroTipo),
    Tipo \= OtroTipo.

% 2)
esLegendario(Pokemon):-
    tipoMultiple(Pokemon),
    not(entrenador(_, Pokemon)).

% 3) 
esMisterioso(Pokemon):-
    pokemon(Pokemon, Tipo),
    not((pokemon(OtroPokemon, Tipo), Pokemon \= OtroPokemon)).
esMisterioso(Pokemon):-
    pokemon(Pokemon, _),
    not(entrenador(_, Pokemon)).

% PARTE 2: MOVIMIENTOS
movimiento(pikachu, fisico(mordedura, 95)).
movimiento(pikachu, especial(impactrueno, electrico, 40)).
movimiento(charizard, fisico(mordedura, 95)).
movimiento(charizard, especial(garraDragon, dragon, 100)).
movimiento(blastoise, defensivo(proteccion, 10)).
movimiento(blastoise, fisico(placaje, 50)).
movimiento(arceus, especial(impactrueno, electrico, 40)).
movimiento(arceus, especial(garraDragon, dragon, 100)).
movimiento(arceus, defensivo(proteccion, 10)).
movimiento(arceus, fisico(placaje, 50)).
movimiento(arceus, defensivo(alivio, 100)).

% 1)
danioAtaque(fisico(_, Danio), Danio).
danioAtaque(defensivo(_, _), 0).
danioAtaque(especial(_, Tipo, Potencia), Danio):-
    multiplicadorTipo(Multiplicador, Tipo),
    Danio is Potencia * Multiplicador.

multiplicadorTipo(1.5, Tipo):- esBasico(Tipo).
multiplicadorTipo(3, dragon).
multiplicadorTipo(1, Tipo):- not(esBasico(Tipo)), Tipo\=dragon.

esBasico(fuego).
esBasico(agua).
esBasico(planta).
esBasico(normal).

% 2)
capacidadOfensiva(Pokemon, CapacidadOfensiva):-
    pokemon(Pokemon, _),
    findall(Ataque, 
    (movimiento(Pokemon, Movimiento), danioAtaque(Movimiento, Ataque)), 
    AtaqueTotal),
    sumlist(AtaqueTotal, CapacidadOfensiva).

% 3)
esPicante(Entrenador):-
    entrenador(Entrenador, _),
    forall(entrenador(Entrenador, Pokemon), 
    (capacidadOfensiva(Pokemon, CapacidadOfensiva), CapacidadOfensiva > 200)).
esPicante(Entrenador):-
    entrenador(Entrenador, _),
    forall(entrenador(Entrenador, Pokemon), esMisterioso(Pokemon)).


