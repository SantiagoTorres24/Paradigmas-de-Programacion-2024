gador(ana,laminas).

tecnoJugador(beto,herreria).
tecnoJugador(beto,forja).
tecnoJugador(beto,fundicion).

tecnoJugador(carola,herreria).

tecnoJugador(dimitri,herreria).
tecnoJugador(dimitri,fundicion).

%Punto 2: Expertos en metales

expertoEnMetales(Jugador) :- 
	tecnoJugador(Jugador,herreria),
	tecnoJugador(Jugador,forja),
	tecnoJugador(Jugador,fundicion).
expertoEnMetales(Jugador) :- 
	tecnoJugador(Jugador,herreria),
	tecnoJugador(Jugador,forja),
	civilizacion(Jugador,romanos).

%Punto 3: Civilizacion popular

civilizacionPopular(Civilizacion) :- 
	civilizacion(Jugador,Civilizacion),
	civilizacion(Jugador2,Civilizacion),
	Jugador\=Jugador2.
	

%Punto 4: Alcance Global

alcanceGlobal(Tecnologia):-
	forall(tecnoJugador(Jugador,_),tecnoJugador(Jugador,Tecnologia)).

%Punto 5: Civilizacion Lider

civilizacionTieneTecnologia(Civilizacion, Tecnologia) :-
	civilizacion(Jugador, Civilizacion),
  tecnoJugador(Jugador, Tecnologia).
	
	civilizacionLider(Civilizacion) :-
	forall(
	(civilizacion(_, OtraCivilizacion), tecnoJugador(_,Tecnologia),
	OtraCivilizacion \= Civilizacion),
	civilizacionTieneTecnologia(Civilizacion, Tecnologia)
	).

%Punto 6 Unidades

% Unidades ANA

unidades(ana,jinete(caballo)).
unidades(ana,piquero(1,con_escudo)).
unidades(ana,piquero(2,sin_escudo)).

%Unidades BETO

unidades(beto,campeon(100)).
unidades(beto,campeon(80)).
unidades(beto,piquero(1,con_escudo)).
unidades(beto,jinete(camello)).

%Unidades Carola 

unidades(carola,piquero(3,sin_escudo)).
unidades(carola,piquero(2,con_escudo)).

%Punto 7  Unidades con mas vida

vida(jinete(caballo),90).
vida(jinete(camello),80).
vida(piquero(1,sin_escudo),50).
vida(piquero(2,sin_escudo),65).
vida(piquero(3,sin_escudo),70).

%piquero con escudo
vida(piquero(Nivel,escudo),Vida):-
    vida(piquero(Nivel,sin_escudo),VidaSinEscudo),
    Vida is VidaSinEscudo * 1.1.

%campeones
vida(campeon(Vida),Vida).

%determinar quien tiene mas vida
unidadConMasVida(Jugador, UnidadConMasVida) :-
    unidades(Jugador, UnidadConMasVida),
    vida(UnidadConMasVida, VidaConMasVida),
    forall(
    (unidades(Jugador, OtraUnidad), OtraUnidad \= UnidadConMasVida, vida(OtraUnidad, VidaOtraUnidad)),
    VidaConMasVida >= VidaOtraUnidad
    ).

%Punto 8
ventaja(jinete(_),campeon(_)).
ventaja(campeon(),piquero(_,_)).
ventaja(piquero(_,_),jinete(_)).
ventaja(jinete(camello),jinete(caballo)).

leGana(UnidadGana,OtraUnidad):-
	ventaja(UnidadGana,OtraUnidad).
	
leGana(UnidadGana,OtraUnidad):-
	not(ventaja(OtraUnidad,UnidadGana)),
	vida(UnidadGana,VidaGanadora),
  vida(OtraUnidad,VidaPerdedora),
  VidaGanadora>VidaPerdedora.
	

%Punto 9

listaPiquero(Jugador,Unidad,Cantidad):-
findall(_,unidades(Jugador,Unidad),Lista),
length(Lista, Cantidad).

sobreviveAsedio(Jugador):-
  listaPiquero(Jugador,piquero(_,con_escudo),CantCon),
	listaPiquero(Jugador,piquero(_,sin_escudo),CantSin),
	CantCon>CantSin.

%Punto 10a:

tecnoSinDependencia(molino).
tecnoSinDependencia(herreria).

dependencia(collera,molino).
dependencia(arado,collera).

dependencia(emplumado,herreria).
dependencia(punzon,emplumado).

dependencia(forja,herreria).
dependencia(fundicion,forja).
dependencia(horno,fundicion).
    
dependencia(laminas,herreria).
dependencia(malla,laminas).
dependencia(placas,malla). 

% 10.b)
puedeDesarrollar(Jugador,Tecnologia):-
	alcanzable(Jugador,Tecnologia),
	not(tecnoJugador(Jugador,Tecnologia)).
	
	alcanzable(_,Tecnologia):-  %ninguna dependencia
	tecnoSinDependencia(Tecnologia).
	
	alcanzable(Jugador,Tecnologia):-   %una dependencia
	dependencia(Tecnologia,Dependencia),
	tecnoJugador(Jugador,Dependencia).
	
	alcanzable(Jugador,Tecnologia):-   %mas de una dependencia
	dependencia(Tecnologia, Dependencia), 
	alcanzable(Jugador, Dependencia).
