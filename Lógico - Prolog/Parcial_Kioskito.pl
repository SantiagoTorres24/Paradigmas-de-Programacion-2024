% dodain atiende lunes, miércoles y viernes de 9 a 15.
atiende(dodain, lunes, 9, 15).
atiende(dodain, miercoles, 9, 15).
atiende(dodain, viernes, 8, 15).
% lucas atiende los martes de 10 a 20
atiende(lucas, martes, 10, 20).
% juanC atiende los sábados y domingos de 18 a 22.
atiende(juanC, sabado, 18, 22).
atiende(juanC, domingo, 18, 22).
% juanFdS atiende los jueves de 10 a 20 y los viernes de 12 a 20.
atiende(juanFdS, jueves, 10, 20).
atiende(juanFdS, viernes, 12, 20).
% leoC atiende los lunes y los miércoles de 14 a 18.
atiende(leoC, lunes, 14, 18).
atiende(leoC, miercoles, 14, 18).
% martu atiende los miércoles de 23 a 24
atiende(martu, miercoles, 23, 24).

% vale atiende los mismos días y horarios que dodain y juanC.
atiende(vale, Dias, HoraEntrada, HoraSalida):-
    atiende(dodain, Dias, HoraEntrada, HoraSalida).
atiende(vale, Dias, HoraEntrada, HoraSalida):-
    atiende(juanC, Dias, HoraEntrada, HoraSalida).

% - nadie hace el mismo horario que leoC
% por principio de universo cerrado, no agregamos a la base de conocimiento aquello 
% que no tiene sentido agregar
% - maiu está pensando si hace el horario de 0 a 8 los martes y miércoles
% por principio de universo cerrado, lo desconocido se presume falso

% Definir un predicado que permita relacionar un día y hora con una persona, en la 
% que dicha persona atiende el kiosko.
quienAtiende(Persona, Dia, Hora):-
    atiende(Persona, Dia, HoraEntrada, HoraSalida),
    between(HoraEntrada, HoraSalida, Hora).

% Definir un predicado que permita saber si una persona en un día y horario determinado 
% está atendiendo ella sola. En este predicado debe utilizar not/1, y debe ser 
% inversible para relacionar personas.
foreverAlone(Persona, Dia, Horario):-
    quienAtiende(Persona, Dia, Horario),
    not((quienAtiende(OtraPersona, Dia, Horario), Persona \= OtraPersona)).

% Dado un día, queremos relacionar qué personas podrían estar atendiendo el kiosko en 
% algún momento de ese día. Queremos saber todas las posibilidades de atención de ese 
% día. La única restricción es que la persona atienda ese día 
posibilidadesAtencion(Dia, Personas):-
    findall(Persona, distinct(Persona, quienAtiende(Persona, Dia, _)), PersonasPosibles),
    combinar(PersonasPosibles, Personas). % distinct elimina los repetidos
  
  combinar([], []).
  combinar([Persona|PersonasPosibles], [Persona|Personas]):-
    combinar(PersonasPosibles, Personas).
  combinar([_|PersonasPosibles], Personas):-
    combinar(PersonasPosibles, Personas).

% Queremos agregar las siguientes cláusulas:
% dodain hizo las siguientes ventas el lunes 10 de agosto: golosinas por $ 1200, cigarrillos Jockey, golosinas por $ 50
venta(dodain, fecha(10, 8), [golosinas(1200), cigarrillos(jockey), golosinas(50)]).
% dodain hizo las siguientes ventas el miércoles 12 de agosto: 8 bebidas alcohólicas, 
% 1 bebida no-alcohólica, golosinas por $ 10
venta(dodain, fecha(12, 8), [bebidas(alcoholica, 8), bebidas(noAlcoholica, 1), golosinas(10)]).
% martu hizo las siguientes ventas el miercoles 12 de agosto: golosinas por $ 1000, cigarrillos Chesterfield, Colorado y Parisiennes.
venta(martu, fecha(12, 8), [golosinas(1000), cigarrillos([chesterfield, colorado, parisiennes])]).
% lucas hizo las siguientes ventas el martes 11 de agosto: golosinas por $ 600.
venta(lucas, fecha(11, 8), [golosinas(600)]).
% lucas hizo las siguientes ventas el martes 18 de agosto: 2 bebidas no-alcohólicas y cigarrillos Derby.
venta(lucas, fecha(18, 8), [bebidas(noAlcoholica, 2), cigarrillos([derby])]).

% Queremos saber si una persona vendedora es suertuda, esto ocurre si para todos los días en los que vendió,
% la primera venta que hizo fue importante. Una venta es importante:
% - en el caso de las golosinas, si supera los $ 100.
% - en el caso de los cigarrillos, si tiene más de dos marcas.
% - en el caso de las bebidas, si son alcohólicas o son más de 5.
personaSuertuda(Persona):-
  vendedora(Persona),
  forall(venta(Persona, _, [Venta|_]), ventaImportante(Venta)).

vendedora(Persona):-
    venta(Persona, _, _).

ventaImportante(golosinas(Precio)):-
    Precio > 100.
ventaImportante(cigarrillos(Marcas)):-
    length(Marcas, Cantidad), Cantidad > 2.
ventaImportante(bebidas(alcoholica, _)).
ventaImportante(bebidas(_, Cantidad)):-
    Cantidad > 5.

