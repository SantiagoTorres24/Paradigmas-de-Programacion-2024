/*
Nombre: Mansilla, Joseph Thomas
Legajo: 215.449-3
*/

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Código Inicial
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Recorridos en GBA:

% recorrido(linea, zona, calle) (PUNTO DE PARTIDA).
recorrido(17, gba(sur), mitre).
recorrido(24, gba(sur), belgrano).
recorrido(247, gba(sur), onsari).
recorrido(60, gba(norte), maipu).
recorrido(152, gba(norte), olivos).

% Recorridos en CABA:
recorrido(17, caba, santaFe).
recorrido(152, caba, santaFe).
recorrido(10, caba, santaFe).
recorrido(160, caba, medrano).
recorrido(24, caba, corrientes).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Punto 1

puedeCombinarse(UnaLinea, OtraLinea):-
    recorrido(UnaLinea, Zona, Calle),
    recorrido(OtraLinea, Zona, Calle),
    UnaLinea \= OtraLinea.

%% Punto 2

cruzaGralPaz(Linea):-
    recorrido(Linea, caba, _),
    recorrido(Linea, gba(_),_).

jurisdiccionLinea(Linea, nacional):-
    cruzaGralPaz(Linea).
jurisdiccionLinea(Linea, Provincia):-
    recorrido(Linea,Zona,_),
    not(cruzaGralPaz(Linea)),
    provincia(Zona, Provincia).

provincia(gba(_), buenosAires).
provincia(caba, caba).
provincia(cordoba, cordoba).

%% PUNTO 3 

calleMasTransitadaDeZona(ZonaMasTransitada, CalleMasTransitada):-
    recorrido(_, Zona, Calle),
    lineasQuePasanPor(ZonaMasTransitada, CalleMasTransitada, MayorCantidadLineas),
    forall((recorrido(_, Zona, Calle), lineasQuePasanPor(Zona, Calle, CantidadLineas)), MayorCantidadLineas > CantidadLineas).

lineasQuePasanPor(Zona, Calle, CantidadLineas):-
    findall(Linea, recorrido(Linea, Zona, Calle), LineasQuePasan),
    sum_list(LineasQuePasan, CantidadLineas).

%% PUNTO 4

esCalleDeTransbordoDeZona(Zona, Calle):-
    recorrido(_, Zona, Calle),
    pasanAlMenosTresLineas(Zona, Calle),
    forall(recorrido(Linea, Zona, Calle), jurisdiccionLinea(Linea, nacional)).

pasanAlMenosTresLineas(Zona, Calle):-
    recorrido(Linea1, Zona, Calle),
    recorrido(Linea2, Zona, Calle),
    recorrido(Linea3, Zona, Calle),
    Linea1 \= Linea2,
    Linea1 \= Linea3,
    Linea2 \= Linea3.

%% PUNTO 5
%% A

%% COMO TIENE QUE ESTAR REGISTRADO AL SISTEMA DE SUBE DEBE FIGURAR EL PASAJERO.
pasajero(pepito).
pasajero(juanita).
pasajero(marta).
pasajero(tito).

beneficios(estudiante, 50).
beneficios(personalParticular(_), 0).
% con esta implementación es simple cambiar la tarifa del valor del pasaje de un estudiante o de un personaParticular...
% no puedo representar entre los beneficios a los jubilados por ser la mitad de un valor.

beneficiarios(pepito, personalParticular(gba(oeste))).
beneficiarios(juanita, estudiante).
beneficiarios(marta, jubilado).
%% POR PRINCIPIO DE UNIVERSO CERRADO, NO INCLUIMOS A TITO ENTRE LOS BENEFICIARIOS

%% PRIMERA PARTE B

valorBoleto(Linea, 500):- jurisdiccionLinea(Linea, nacional).
valorBoleto(Linea, 350):- jurisdiccionLinea(Linea, caba).
valorBoleto(Linea, Valor):- 
    jurisdiccionLinea(Linea, gba(_)), 
    cantidadDeCallesEnRecorrido(Linea, CantidadDeCallesRecorridas),
    valorDelPlus(Linea, Plus),
    Valor is 25 * CantidadDeCallesRecorridas + Plus.

cantidadDeCallesEnRecorrido(Linea, Cantidad):-
    findall(Calle, recorrido(Linea, _, Calle), Calles),
    sum_list(Calles, Cantidad).

pasaPorZonasDiferentes(Linea):-
    recorrido(Linea, UnaZona, _),
    recorrido(Linea, OtraZona, _),
    UnaZona \= OtraZona.

valorDelPlus(Linea, 50):- pasaPorZonasDiferentes(Linea).
valorDelPlus(Linea, 0):- recorrido(Linea, _,_), not(pasaPorZonasDiferentes(Linea)). 
%% agrego inversibilidad

%% SEGUNDA PARTE B

abonarBoleto(Pasajero, Linea, Valor):- 
    pasajero(Pasajero),
    not(beneficiarios(Pasajero,_)),
    valorBoleto(Linea, Valor).
%% NO TOMA EN CUENTA A LOS DE PERSONALPARTICULAR SI NO CUMPLE LA ZONA

abonarBoleto(NombrePasajero, Linea, ValorPasajeEstudiante):- 
    pasajero(NombrePasajero), 
    aplicarBeneficio(NombrePasajero, Linea, ValorPasajeEstudiante).

aplicarBeneficio(NombrePasajero, _, ValorPasajeEstudiante):- 
    beneficiarios(NombrePasajero, estudiante), 
    beneficios(estudiante, ValorPasajeEstudiante).
aplicarBeneficio(NombrePasajero, Linea, ValorPersonalParticular):-
    beneficiarios(NombrePasajero, personalParticular(Zona)),
    recorrido(Linea, Zona, _),
    beneficios(personalParticular(Zona), ValorPersonalParticular).
aplicarBeneficio(NombrePasajero, Linea, ValorFinal):-
    beneficiarios(NombrePasajero, jubilado),
    valorBoleto(Linea, ValorInicial),
    tarifaJubilado(ValorInicial, ValorFinal).

tarifaJubilado(ValorInicial, ValorFinal):- ValorFinal is ValorInicial / 2.

%% en caso de que se quiera cambiar facilmente el valor que abonan los jubilados

%% C 

% EN CASO DE QUERER AGREGAR OTRO BENEFICIO SIMPLEMENTE LO PODRIA AGREGAR 
% A LA BASE DE CONOCIMIENTOS INICIAL COMO BENEFICIOS/2 Y DESPUES HABRIA QUE COMPLETAR LA FUNCION 
% APLICARBENEFICIO/3 QUE SE ENCARGA DE APLICAR ESE MISMO BENEFICIO CUANDO SE USA ABONARBOLETO/3
% POR LO TANTO SE PUEDE DECRI QUE EL IMPACTO SERIA MINIMO, YA QUE NO DEBEMOS CAMBIAR EL 
% FUNCIONAMIENTO DE NINGUNA FUNCIÓN EXISTENTE