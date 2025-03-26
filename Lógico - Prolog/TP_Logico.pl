%% solucion.pl
%% alumno: 
% 1) 
% Modelar lo necesario para representar los jugadores, las civilizaciones y las tecnologías,
% de la forma más conveniente para resolver los siguientes puntos. Incluir los siguientes 
% ejemplos.

% Ana, que juega con los romanos y ya desarrolló las tecnologías de herrería, forja, emplumado y láminas.
civilizacion(ana, romanos).
tecnologias(ana, herreria).
tecnologias(ana, forja).
tecnologias(ana, emplumado).
tecnologias(ana, laminas).

% Beto, que juega con los incas y ya desarrolló herrería, forja y fundición.
civilizacion(beto, incas).
tecnologias(beto, herreria).
tecnologias(beto, forja).
tecnologias(beto, fundicion).

% Carola, que juega con los romanos y sólo desarrolló la herrería.
civilizacion(carola, romanos).
tecnologias(carola, herreria).

% Dimitri, que juega con los romanos y ya desarrolló herrería y fundición.
civilizacion(dimitri, romanos).
tecnologias(dimitri, herreria).
tecnologias(dimitri, fundicion).

% Elsa no juega esta partida. No hace falta agregar nada a la base de conocimientos.

/* 
2) Saber si un jugador es experto en metales, que sucede cuando desarrolló las 
tecnologías de herrería, forja y o bien desarrolló fundición o bien juega con los 
romanos.
*/
experto(Jugador):-
    civilizacion(Jugador, romanos).
experto(Jugador):-
    tecnologias(Jugador, fundicion).

expertoEnMetales(Jugador):-
    tecnologias(Jugador, herreria),
    tecnologias(Jugador, forja),
    experto(Jugador).

% 3) Saber si una civilización es popular, que se cumple cuando la eligen varios 
% jugadores (más de uno).
civilizacionPopular(Civilizacion):-
    civilizacion(Jugador, Civilizacion),
    civilizacion(OtroJugador, Civilizacion),
    Jugador \= OtroJugador.

% 4) Saber si una tecnología tiene alcance global, que sucede cuando a nadie le 
% falta desarrollarla.
tecnologiaGlobal(Tecnologia):-
    tecnologias(_,Tecnologia),
    forall(tecnologias(Jugador, _), tecnologias(Jugador, Tecnologia)).

/* 5) Saber cuándo una civilización es líder. Se cumple cuando esa civilización alcanzó 
todas las tecnologías que alcanzaron las demás. Una civilización alcanzó una tecnología
cuando algún jugador de esa civilización la desarrolló*/
civilizacionAlcanzoTecnologia(Civilizacion, Tecnologia):-
    civilizacion(Jugador, Civilizacion),
    tecnologias(Jugador, Tecnologia).
civilizacionLider(Civilizacion):-
    civilizacion(_,Civilizacion),
    forall((civilizacion(_, OtraCivilizacion), 
    tecnologias(_, Tecnologia), 
    OtraCivilizacion \= Civilizacion),
    civilizacionAlcanzoTecnologia(Civilizacion, Tecnologia)).

/*No se puede ganar la guerra sin soldados. Las unidades que existen son los campeones 
(con vida de 1 a 100), los jinetes (que los puede haber a caballo o a camello) y los 
piqueros, que tienen un nivel de 1 a 3, y pueden o no tener escudo.
6) Modelar lo necesario para representar las distintas unidades de cada jugador de la 
forma más conveniente para resolver los siguientes puntos. Incluir los siguientes 
ejemplos:
 - Ana tiene un jinete a caballo, un piquero con escudo de nivel 1, y un piquero sin 
   escudo de nivel 2.
*/
unidades(ana, jinete(caballo)).
unidades(ana, piquero(1, conEscudo)).
unidades(ana, piquero(2, sinEscudo)).

% Beto tiene un campeón de 100 de vida, otro de 80 de vida, un piquero con escudo nivel 
% 1 y un jinete a camello
unidades(beto, campeon(100)).
unidades(beto, campeon(80)).
unidades(beto, piquero(1, conEscudo)).
unidades(beto, jinete(camello)).

% Carola tiene un piquero sin escudo de nivel 3 y uno con escudo de nivel 2.
unidades(carola, piquero(3, sinEscudo)).
unidades(carola, piquero(2, conEscudo)).

% Dimitri no tiene unidades. No hace falta agregar nada a la base de conocimientos.

/* 7) Conocer la unidad con más vida que tiene un jugador, teniendo en cuenta que:
 - Los jinetes a camello tienen 80 de vida y los jinetes a caballo tienen 90.
 - Cada campeón tiene una vida distinta.
 - Los piqueros sin escudo de nivel 1 tienen vida 50, los de nivel 2 tienen vida 65 y los 
de nivel 3 tienen 70 de vida.
 - Los piqueros con escudo tienen 10% más de vida que los piqueros sin escudo.
*/
vida(jinete(camello), 80).
vida(jinete(caballo), 90).
vida(campeon(Vida), Vida).
vida(piquero(1, sinEscudo), 50).
vida(piquero(2, sinEscudo), 65).
vida(piquero(3, sinEscudo), 70).
vida(piquero(Nivel, conEscudo, VidaConEscudo)):-
    vida(piquero(Nivel, sinEscudo), VidaSinEscudo),
    VidaConEscudo is VidaSinEscudo * 1.1.

unidadConMasVida(Jugador, Unidad):-
    unidades(Jugador, Unidad),
    vida(Unidad, Vida),
    forall((unidades(Jugador, OtraUnidad), 
    vida(OtraUnidad, OtraVida), Unidad \= OtraUnidad),
    Vida >= OtraVida).

/* 8) Queremos saber si una unidad le gana a otra. Las unidades tienen una ventaja por 
tipo sobre otras. Cualquier jinete le gana a cualquier campeón, cualquier campeón le 
gana a cualquier piquero y cualquier piquero le gana a cualquier jinete, pero los jinetes 
a camello le ganan a los a caballo. En caso de que no exista ventaja entre las unidades, 
se compara la vida (el de mayor vida gana). 
Este punto no necesita ser inversible.*/

ganaA(jinete(_), campeon(_)).
ganaA(campeon(_), piquero(_, _)).
ganaA(piquero(_, _), jinete(_)).
ganaA(jinete(camello), jinete(caballo)).

unidadGanadora(Unidad, OtraUnidad):-
    ganaA(Unidad, OtraUnidad), !.

unidadGanadora(Unidad, OtraUnidad):-
    not(ganaA(OtraUnidad, Unidad)), % Verifico que no haya ventaja para OtraUnidad
    vida(Unidad, VidaUnidad),
    vida(OtraUnidad, VidaOtraUnidad),
    VidaUnidad >= VidaOtraUnidad.

% 9) Saber si un jugador puede sobrevivir a un asedio. Esto ocurre si tiene más 
% piqueros con escudo que sin escudo.
obtenerCantidadPiqueros(Jugador, Unidad, Cantidad):-
    findall(Piquero, unidades(Jugador, Unidad), Piqueros),
    length(Piqueros, Cantidad).

sobreviveAsedio(Jugador):-
    obtenerCantidadPiqueros(Jugador, piquero(_, conEscudo), CantidadConEscudo),
    obtenerCantidadPiqueros(Jugador, piquero(_, sinEscudo), CantidadSinEscudo),
    CantidadConEscudo > CantidadSinEscudo.

% 10A) Árbol de tecnologías
% Se sabe que existe un árbol de tecnologías, que indica dependencias entre ellas. 
% Hasta no desarrollar una, no se puede desarrollar la siguiente.

tecnologiaRaiz(herreria).
tecnologiaRaiz(molino).

dependeDe(emplumado, herreria).
dependeDe(forja, herreria).
dependeDe(laminas, herreria).
dependeDe(collera, molino).

dependeDe(punzon, emplumado).
dependeDe(fundicion, forja).
dependeDe(malla, laminas).
dependeDe(arado, collera).

dependeDe(horno, fundicion).
dependeDe(placas, malla).

% 10B) Saber si un jugador puede desarrollar una tecnología, que se cumple cuando ya 
% desarrolló todas sus dependencias (las directas y las indirectas). Considerar que 
% pueden existir árboles de cualquier tamaño.
desarrollo(Jugador, Tecnologia):-
    tecnologiaRaiz(Dependencia).
desarrollo(Jugador, Tecnologia):-
    dependeDe(Tecnologia, Dependencia),
    tecnologias(Jugador, Dependencia).
desarrollo(Jugador, Tecnologia):-
    dependeDe(Tecnologia, Dependencia),
    desarrollo(Jugador, Dependencia).

puedeDesarrollar(Jugador, Tecnologia):-
    desarrollo(Jugador, Tecnologia),
    not(tecnologias(Jugador, Tecnologia)).

% 11A) Encontrar un orden válido en el que puedan haberse desarrollado las tecnologías 
% para que un jugador llegue a desarrollar todo lo que tiene. Se espera una relación de 
% jugador con lista de tecnologías.
% Predicado principal para encontrar un orden válido
verificarTecnologia(Tecnologia, _):-
    tecnologiaRaiz(Tecnologia).
verificarTecnologia(Tecnologia, OrdenParcial):-
    todasDependenciasSatisfechas(Tecnologia, OrdenParcial).

ordenDesarrolloAux([], Orden, Orden).
ordenDesarrolloAux(Tecnologias, OrdenParcial, Orden) :-
    select(Tecnologia, Tecnologias, Restantes),
    verificarTecnologia(Tecnologia, OrdenParcial),
    ordenDesarrolloAux(Restantes, [Tecnologia|OrdenParcial], Orden).

todasDependenciasSatisfechas(Tecnologia, OrdenParcial) :-
    findall(Dependencia, dependeDe(Tecnologia, Dependencia), Dependencias),
    forall(member(Dep, Dependencias), member(Dep, OrdenParcial)).

ordenDesarrollo(Jugador, Orden) :-
    findall(Tecnologia, tecnologias(Jugador, Tecnologia), Tecnologias),
    ordenDesarrolloAux(Tecnologias, [], OrdenReverso),
    reverse(OrdenReverso, Orden).

/* 12) Dado un jugador defensor, encontrar el ejército que debo crear para ganarle a 
todo su ejército. El ejército atacante debe tener el mismo tamaño, y suponer que las 
batallas son uno contra uno, cada integrante atacante ataca a un integrante defensor.*/
ejercitoDefensor(Jugador,EjercitoDefensor):-
    civilizacion(Jugador,_),
    findall(Unidad, unidades(Jugador,Unidad), EjercitoDefensor).

ejercitoAtacante(Jugador,EjercitoAtacante):-
    civilizacion(Jugador,_),
    findall(Unidad, unidades(Jugador,Unidad), EjercitoAtacante).

subconjunto(_,0,[]).
subconjunto([H|T], N, [H|Subc]):-
    N>0,
    N1 is N - 1,
    subconjunto(T, N1, Subc).
subconjunto([_|T],N,Subc):-
    N>0,
    subconjunto(T,N,Subc).

esAtaqueValido([],_).
esAtaqueValido([Defensor|RestoDefensor],GrupoAtacante):-
    unidades(Jugador,UnidadAtaque),
    member(UnidadAtaque, GrupoAtacante),
    unidadGanadora(UnidadAtaque,Defensor),
    esAtaqueValido(RestoDefensor,GrupoAtacante).

esteEjercitoLeGana(JugadorDefensor, EjercitoAtacante):-
    civilizacion(JugadorDefensor,_),
    ejercitoDefensor(JugadorDefensor,EjercitoDefensor),
    findall(Unidades, unidades(_,Unidades), TodasLasUnidadesPosibles),
    length(EjercitoDefensor, Tamanio),
    subconjunto(TodasLasUnidadesPosibles, Tamanio, EjercitoAtacante),
    esAtaqueValido(EjercitoDefensor, EjercitoAtacante).





