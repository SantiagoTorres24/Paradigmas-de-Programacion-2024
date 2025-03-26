herramientasRequeridas(ordenarCuarto, [aspiradora(100), trapeador, plumero]).
herramientasRequeridas(limpiarTecho, [escoba, pala]).
herramientasRequeridas(cortarPasto, [bordedadora]).
herramientasRequeridas(limpiarBanio, [sopapa, trapeador]).
herramientasRequeridas(encerarPisos, [lustradpesora, cera, aspiradora(300)]).

% 1)
% Egon tiene una aspiradora de 200 de potencia.
cazafantasma(egon, aspiradora(200)).
% Egon y Peter tienen un trapeador, Ray y Winston no.
cazafantasma(egon, trapeador).
cazafantasma(peter, trapeador).
cazafantasma(winston, varitaDeNeutrones).

% 2) Definir un predicado que determine si un integrante satisface la necesidad de una
% herramienta requerida. Esto será cierto si tiene dicha herramienta, teniendo en cuenta
% que si la herramienta requerida es una aspiradora, el integrante debe tener una con
% potencia igual o superior a la requerida.
satisfaceHerramienta(Persona, Herramienta):-
    cazafantasma(Persona, Herramienta).
satisfaceHerramienta(Persona, aspiradora(PotenciaRequerida)):-
    cazafantasma(Persona, aspiradora(Potencia)),
    Potencia >= PotenciaRequerida.

% 3) Queremos saber si una persona puede realizar una tarea, que dependerá de las 
% herramientas que tenga. Sabemos que:
% - Quien tenga una varita de neutrones puede hacer cualquier tarea, independientemente 
% de qué herramientas requiera dicha tarea.
% - Alternativamente alguien puede hacer una tarea si puede satisfacer la necesidad de
% todas las herramientas requeridas para dicha tarea.
puedeRealizarTarea(winston, _).
puedeRealizarTarea(Persona, Tarea):-
    cazafantasma(Persona, _),
    herramientasRequeridas(Tarea, _),
    forall((herramientasRequeridas(Tarea, ListaHerramientas), member(Herramienta, ListaHerramientas)),
    satisfaceHerramienta(Persona, Herramienta)).

/* 4) Nos interesa saber de antemano cuanto se le debería cobrar a un cliente por un 
pedido (que son las tareas que pide). Para ellos disponemos de la siguiente información 
en la base de conocimientos:
- tareaPedida/3: relaciona al cliente, con la tarea pedida y la cantidad de metros 
  cuadrados sobre los cuales hay que realizar esa tarea.
- precio/2: relaciona una tarea con el precio por metro cuadrado que se cobraría al 
  cliente.
Entonces lo que se le cobraría al cliente sería la suma del valor a cobrar por cada 
tarea, multiplicando el precio por los metros cuadrados de la tarea.*/
cobroPorTarea(Cliente, Tarea, Monto):-
    tareaPedida(Cliente, Tarea, Metros),
    precio(Tarea, Precio), 
    Monto is Precio * Metros.
cobroPorPedido(Cliento, PrecioFinal):-
    tareaPedida(Cliente, _, _),
    finall(Precio, cobroPorTarea(Cliente, _, Precio), Precios),
    sumlist(Precios, PrecioFinal).
