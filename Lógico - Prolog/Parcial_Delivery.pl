%composicion(plato, [ingrediente])%
composicion(platoPrincipal(milanesa),[ingrediente(pan,3),
ingrediente(huevo,2),ingrediente(carne,2)]).
composicion(entrada(ensMixta),[ingrediente(tomate,2),
ingrediente(cebolla,1),ingrediente(lechuga,2)]).
composicion(entrada(ensFresca),[ingrediente(huevo,1),
ingrediente(remolacha,2),ingrediente(zanahoria,1)]).
composicion(postre(budinDePan),[ingrediente(pan,2),ingrediente(caramelo,1)]).

%calorías(nombreIngrediente, cantidadCalorias)%
calorias(pan,30).
calorias(huevo,18).
calorias(carne,40).
calorias(caramelo,170).

%proveedor(nombreProveedor, [nombreIngredientes])%
proveedor(disco, [pan, caramelo, carne, cebolla]).
proveedor(sanIgnacio, [zanahoria, lechuga, miel, huevo]).

% 1)
caloriasTotal(Plato, CaloriasTotales):-
    composicion(Plato, Ingredientes),
    findall(Caloria, (member(ingrediente(Ingrediente, Cantidad), Ingredientes),
    encontrarCaloriasPorIngrediente(Ingrediente, Cantidad, Caloria)), Calorias),
    sumlist(Calorias, CaloriasTotales).

encontrarCaloriasPorIngrediente(Ingrediente, Cantidad, CaloriasIngrediente):-
    calorias(Ingrediente, Calorias),
    CaloriasIngrediente is Cantidad * Calorias.

% 3)
platoSimpatico(Plato):-
    composicion(Plato, Ingredientes),
    member(ingrediente(pan, _), Ingredientes),
    member(ingrediente(huevo, _), Ingredientes).
platoSimpatico(Plato):-
    caloriasTotal(Plato, CaloriasTotales),
    CaloriasTotales < 200.

% 4)
menuDiet(Plato1, Plato2, Plato3):-
    Plato1 \= Plato2,
    Plato2 \= Plato3,
    Plato1 \= Plato3,
    esEntrada(Plato1),
    esPlatoPrincipal(Plato2),
    esPostre(Plato3),
    caloriasDelMenu(Plato1, Plato2, Plato3, CaloriasMenu),
    CaloriasMenu < 450.

esEntrada(entrada(_)).
esPlatoPrincipal(platoPrincipal(_)).
esPostre(postre(_)).

caloriasDelMenu(Plato1, Plato2, Plato3, CaloriasMenu),
    caloriasTotal(Plato1, CaloriasPlato1),
    caloriasTotal(Plato2, CaloriasPlato2),
    caloriasTotal(Plato3, CaloriasPlato3),
    CaloriasMenu is CaloriasPlato1 + CaloriasPlato2 + CaloriasPlato3.

% 5)
tieneTodo(Proveedor, Plato):-
    proveedor(Proveedor, IngredientesProveedor),
    composicion(Plato, IngredientesPlato),
    forall(member(ingrediente(Ingrediente, _), IngredientesPlato), 
    member(Ingrediente, IngredientesProveedor)).

% 6)
ingredientePopular(Ingrediente):-
    composicion(_, IngredientesPlato),
    member(Ingrediente, IngredientesPlato),
    findall(TieneIngrediente, (composicion(Plato, Ingredientes), 
    member(Ingrediente, Ingredientes)), TieneIngredientes),
    sumlist(TieneIngredientes, TotalIngredientes),
    TotalIngredientes > 3.

% 7)
cantidadTotal(Ingrediente, ListaDeCantidades, TotalIngredientes):-
    findall(IngredienteUtilizado, (member(Cantidad, ListaDeCantidades), 
    encontrarCantidad(Cantidad, Ingrediente, IngredienteUtilizado)), Ingredientes),
    sumlist(Ingredientes, TotalIngredientes).

encontrarCantidad(cantidad(Plato, Cantidad), Ingrediente, CantidadEnLista):-
    composicion(Plato, Ingredientes),
    member(ingrediente(Ingrediente, CantidadEnPlato), Ingredientes),
    CantidadEnLista is CantidadEnPlato * Cantidad.