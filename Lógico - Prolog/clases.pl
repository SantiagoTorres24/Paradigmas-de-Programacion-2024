% un comentario
/* varios
comentarios */

persona(martin). % martin es un atomo (y tmb un individuo)
adulto(martin).
joven(inia). 

amigo(inia, martin). %inia es amigo de martin, martin no es amigo de inia, no es reciproco
amigo(martin, inia). % martin e inia son atomos martin, inia es el individuo

% declaro todas verdades, y si no estan en las verdades ==> son falsos

%% EJ RIMACS

vendedor(inia).
vendedor(martin).
vendedor(bauti).

% tengo 1 predicado (vende) y 3 clausulas

%vende(inia, siempreViva742).
%vende(martin, siempreViva742).
%vende(inia, miCasita123).

% vende(inia, Casa) devuelve las casas que vende
% vende(inia, _) me dice si vende o no alguna casa

luminosa(casaBlanca901).

ambientes(casaBlanca901, 22).
ambientes(siempreViva742, 5).
ambientes(miCasita123, 1).

grande(Casa):- ambientes(Casa, Ambientes), Ambientes > 3. % , es como un "y"

copada(Casa):- 
    luminosa(Casa).

copada(Casa):-
    grande(Casa).

% copada es la forma de hacer un "o"

animal(tigre).
animal(jirafa).
animal(tiburon).
animal(perro).
animal(gato).

biomaT(sabana).
biomaT(mar).

habitat(tigre, sabana).
habitat(tigre, bosque).
habitat(jirafa, sabana).
habitat(tiburon, mar).
habitat(perro, ciudad).
habitat(gato, ciudad).

acuatico(Animal):- habitat(Animal, mar).
terrestre(Animal):- animal(Animal), not(acuatico(Animal)). % no es inversible

templado(Bioma):- biomaT(Bioma).

friolento(Animal):- animal(Animal), forall(habitat(Animal, Bioma), templado(Bioma)).

% forall(Universo, Condicion). Universo Vacio = true

% Functores (es como un data de funcional)
% En un lugar venden libros y cd ==> vende(Articulo, Precio).

vende(libro(elResplandor, stephenKing, terror, debolsillo), 2300). %(articulo(nombre, autor, genero, editorial),precio).
vende(libro(mort, terryPratchett, aventura, plazaJanes), 1300).
vende(libro(harryPotter, jkRowling, ficcion, salamandra), 2500).
vende(cd(differentClass, pulp, pop, 2, 24), 1450). %(articulo(nombre, autor, genero, cantAlbumes, cantCanciones), precio).
vende(cd(bloodOnTheTracks, bobDylan, folk, 1, 12), 2500).

% No puedo hacer (libro(Titulo, stephenKing,_,_),_)

% tematico(Autor) : Si todo lo que vendo es del autor

tematico(Autor):-
    autor(_, Autor),
    forall(vende(Articulo, _), autor(Articulo, Autor)).

autor(libro(_, Autor, _, _), Autor):- % Esto es polimorfismo: Trata a los libros y cds de forma igual, pese a que son distintos
    vende(libro(_, Autor, _, _), _).
autor(cd(_, Autor, _, _, _), Autor):-
    vende(cd(_, Autor, _, _), _).

% findall(Selector, Consulta, Lista). Selector: Que porcion de la rta quiero.

receta(Nombre, Ingredientes).
receta(caramelo, [ingrediente(agua, 100), ingrediente(azucar, 190)]).
receta(flan, [ingrediente(caramelo, 100), ingrediente(ddl, 250), ingrediente(masa, 500)]).
receta(cazuelaDeMariscos, [ingrediente(cazuela, 150), ingrediente(mariscos, 250)]).

rapida(Receta):-
    receta(Receta, Ingredientes),
    length(Ingredientes, Total), 
    Total < 4.

postre(Receta):-
    receta(Receta, Ingredientes),
    member(ingrediente(azucar, Cantidad), Ingredientes),
    Cantidad > 250.
% findall(Nombre, receta(Nombre, Ingredientes), Recetas).
% findall(Nombre, (receta(Nombre, _), rapida(Nombre)), Recetas).
% findall(dulce(Nombre), postre(Nombre), Dulces).

cantidadDePostres(Cantidad):-
    findall(1, postre(Receta), Postres),
    sumlist(Postres, Cantidad).
