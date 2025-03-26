% jugadores
% jugador(Nombre, PuntosVida, PuntosMana, CartasMazo, CartasMano, CartasCampo)

% cartas
% criatura(Nombre, PuntosDaño, PuntosVida, CostoMana)
% hechizo(Nombre, FunctorEfecto, CostoMana)

% efectos
% daño(CantidadDaño)
% cura(CantidadCura)


% Se cuenta con los siguientes predicados auxiliares:
nombre(jugador(Nombre,_,_,_,_,_), Nombre).
nombre(criatura(Nombre,_,_,_), Nombre).
nombre(hechizo(Nombre,_,_), Nombre).

vida(jugador(_,Vida,_,_,_,_), Vida).
vida(criatura(_,_,Vida,_), Vida).
vida(hechizo(_,curar(Vida),_), Vida).

daño(criatura(_,Daño,_), Daño).
daño(hechizo(_,daño(Daño),_), Daño).
mana(jugador(_,_,Mana,_,_,_), Mana).
mana(criatura(_,_,_,Mana), Mana).
mana(hechizo(_,_,Mana), Mana).

cartasMazo(jugador(_,_,_,Cartas,_,_), Cartas).
cartasMano(jugador(_,_,_,_,Cartas,_), Cartas).
cartasCampo(jugador(_,_,_,_,_,Cartas), Cartas).

cartasDe(jugador(_,_,_,CartasMazo,_,_), mazo, CartasMazo).
cartasDe(jugador(_,_,_,_,CartasMano,_), mano, CartasMano).
cartasDe(jugador(_,_,_,_,_,CartasCampo), campo, CartasCampo).

cartasJugador(Jugador, Carta):-
    cartasDe(Jugador, _, Cartas),
    member(Carta, Cartas).

esGuerrero(Jugador):-
    forall(cartasJugador(Jugador, _, Cartas), 
    (member(Carta, Cartas), criatura(Carta, _, _, _))).

jugadorDespuesDeTurno(jugador(Nombre, Vida, ManaActual, CartasMazo, CartasMano, CartasCampo)):-
        nth0(0, CartasMazo, PrimeraCarta, CartasMazoRestante),
        append([PrimeraCarta], CartasMano, NuevasCartasMano),
        NuevoMana is ManaActual + 1, 
        jugador(Nombre, Vida, NuevoMana, CartasMazoRestante, NuevasCartasMano, CartasCampo).

puedeJugarCarta(Jugador, Carta):-
    mana(Carta, ManaCarta),
    mana(Jugador, ManaJugador),
    ManaJugador >= ManaCarta.


    
    