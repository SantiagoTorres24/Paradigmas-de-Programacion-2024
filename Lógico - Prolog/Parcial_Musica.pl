% De cada disco sabemos en qué año salió y cuántas copias vendió
% disco(artista, nombreDelDisco, cantidad, año).
disco(floydRosa, elLadoBrillanteDeLaLuna, 1000000, 1973).
disco(tablasDeCanada, autopistaTransargentina, 500, 2006).
disco(rodrigoMalo, elCaballo, 5000000, 1999).
disco(rodrigoMalo, loPeorDelAmor, 50000000, 1996).
disco(rodrigoBueno, loMejorDe, 50000000, 2018).
disco(losOportunistasDelConurbano, ginobili, 5, 2018).
disco(losOportunistasDelConurbano, messiMessiMessi, 5, 2018).
disco(losOportunistasDelConurbano, marthaArgerich, 15, 2019).

% De los artistas podemos conocer a su manager y sus característica:
%manager(artista, manager).
manager(floydRosa, habitual(15)).
manager(tablasDeCanada, internacional(cachito, canada)).
manager(rodrigoMalo, trucho(tito)).

% habitual(porcentajeComision) 
% internacional(nombre, lugar)
% trucho(nombre) 

% 1) clasico: Permite deducir si un artista tiene un disco llamado loMejorDe o alguno 
% con más de 100000 de copias vendidas.
clasico(Artista):-
    disco(Artista, loMejorDe, _, _).
clasico(Artista):-
    disco(Artista, _, CopiasVendidas, _),
    CopiasVendidas > 100000.

% 2) cantidadesVendidas: Relaciona un artista con la cantidad total de unidades vendidas 
% en la historia.
cantidadesVendidas(Artista, TotalVentas):-
    disco(Artista, _, _, _),
    findall(Venta, disco(Artista, _, Venta, _), Ventas),
    sumlist(Ventas, TotalVentas).
    
% 3) derechosDeAutor: Relaciona a un artista con importe total en concepto de derechos de
% autor. Cada venta aporta 100 pesos al artista, descontando la parte que se cobra su 
% manager, en caso de contar con uno (si no tiene manager, no se le descuenta nada): 
%   -Un manager habitual se queda con un porcentaje de las ganancias de cada artista.
%   -Un manager internacional cobra un porcentaje de las ganancias que depende de su 
%    lugar de residencia. (Por ejemplo, para Canadá es un 5%, para México un 15%, etc) 
%   -Un manager trucho se queda con todo.
derechosDeAutor(Artista, ImporteTotal):-
    cantidadesVendidas(Artista, Cantidad),
    not(manager(Artista, _)),
    ImporteTotal is Cantidad * 100.
derechosDeAutor(Artista, ImporteTotal):-
    cantidadesVendidas(Artista, Cantidad),
    manager(Artista, Manager),
    importeTotal(Manager, Cantidad, ImporteTotal).

importeTotal(habitual(Porcentaje), Cantidad, ImporteTotal):-
    ImporteTotal is Cantidad * 100 * (1 - Porcentaje / 100).
importeTotal(internacional(_, Lugar), Cantidad, ImporteTotal):-
    porcentajeSegunResidencia(Lugar, Porcentaje),
    ImporteTotal is Cantidad * 100 * (1 - Porcentaje / 100).
importeTotal(trucho(_), _, 0).

porcentajeSegunResidencia(canada, 5).
porcentajeSegunResidencia(mexico, 15). % etc...

% 4) namberuan: Encontrar al artista autogestionado número 1 de un año, que es el artista
% sin manager con el disco que tuvo más unidades vendidas en dicho año. Importante: no 
% usar max_member
esAutogestionado(Artista):-
    disco(Artista, _, _, _),
    not(manager(Artista, _)).

% Encuentra el disco con la mayor cantidad de ventas en un año
discoMasVendidoAnio(Disco, Anio):-
    disco(_, Disco, _, Anio),
    findall(Cantidad, disco(_, Disco, Cantidad, Anio), Cantidades),
    % Encontrar la cantidad máxima
    max_member(MaxCantidad, Cantidades),
    % Verificar que el disco tiene la cantidad máxima
    disco(_, Disco, MaxCantidad, Anio).


namberuan(Artista, Anio):-
    esAutogestionado(Artista),
    disco(Artista, Disco, _, Anio),
    discoMasVendidoAnio(Disco, Anio).



