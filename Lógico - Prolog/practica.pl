/* Dado el predicado come/2 que relaciona un animal con otro al cual se come,
modelar los siguiente predicados:

1) hostil/2: Relaciona un animal con un bioma si todos los animales que lo habitan se 
lo comen.
2) terrible/2: Relaciona un animal con un bioma si todos los animales que se lo comen 
habitan en el.
3) compatibles/2: Relaciona dos animales si niniguno de los dos come al otro.
4) adaptable/1: Se cumple para los animales que habitan todos los biomas.
5) raro/1: Se cumple para los animales que habitan un unico bioma.
6) dominante/1: Se cumple para los animales que se comen a todos los otros animales del
bioma en el que viven.
*/

hostil(Animal, Bioma):- animal(Animal), bioma(Bioma),
                        forall(habitat(OtroAnimal, Bioma), come(OtroAnimal, Animal)).
terrible(Animal, Bioma):- animal(Animal), bioma(Bioma), 
                          forall(come(OtroAnimal, Animal), habitat(OtroAnimal, Animal)).
compatibles(Animal, OtroAnimal):- animal(Animal), animal(OtroAnimal),
                                  not(come(Animal, OtroAnimal)),
                                  not(come(OtroAnimal, Animal)).
adaptable(Animal):- animal(Animal),
                    forall(habitat(_, Bioma), habitat(Animal, Bioma)).
raro(Animal):- habitat(Animal, Bioma),
               not((habitat(Animal, OtroBioma), Bioma /= OtroBioma)).
dominante(Animal):- habitat(Animal, Bioma),
                    forall((habitat(OtroAnimal, Bioma), 
                    OtroAnimal /= Animal,
                    come(Animal, OtroAnimal))).


/* T.E.G.
Paradigmas de Programación - Jueves Noche - Ejercitación Paradigma Lógico
Nos piden modelar una herramienta para analizar el tablero de un juego de Táctica y 
Estratégia de Guerra. Para eso ya contamos con los siguientes predicados completamente 
inversibles en nuestra base de conocimiento:

Se pide modelar los siguientes predicados, de forma tal que sean completamente 
inversibles:

tienePresenciaEn/2: Relaciona un jugador con un continente del cual ocupa, al menos, un 
país.
puedenAtacarse/2: Relaciona dos jugadores si uno ocupa al menos un país limítrofe a 
algún país ocupado por el otro.
sinTensiones/2: Relaciona dos jugadores que, o bien no pueden atacarse, o son aliados.
perdió/1: Se cumple para un jugador que no ocupa ningún país.
controla/2: Relaciona un jugador con un continente si ocupa todos los países del mismo.
reñido/1: Se cumple para los continentes donde todos los jugadores ocupan algún país.
atrincherado/1: Se cumple para los jugadores que ocupan países en un único continente.
puedeConquistar/2: Relaciona un jugador con un continente si no lo controla, pero todos 
los países del continente que le falta ocupar son limítrofes a alguno que sí ocupa y 
pertenecen a alguien que no es su aliado.*/

%Jugadores:
jugador(Jugador).

%Relaciona un Pais con el Continente
ubicadoEn(Pais, Continente).

%Relaciona dos jugadores si son aliados
aliados(UnJugador, OtroJugador).

%Relaciona un jugador con un pais en el que tiene ejercitos
ocupa(Jugador, Pais).

%Relaciona dos paises si son limitrofes
limitrofes(UnPais, OtroPais).

tienePresenciaEn(Jugador, Continente):- 
    ocupa(Jugador, Pais),
    ubicado(Pais, Continente).

puedenAtacarse(UnJugador, OtroJugador):-
    ocupa(UnJugador, UnPais),
    ocupa(OtroJugador, OtroPais),
    limitrofes(UnPais, OtroPais).

sinTensiones(UnJugador, OtroJugador):-
    jugador(Jugador), jugador(OtroJugador),
    not(puedenAtacarse(UnJugador, OtroJugador)). % el not no es inversible

sinTensiones(UnJugador, OtroJugador):-
    aliados(UnJugador, OtroJugador).

perdio(Jugador):-
    jugador(Jugador),
    not(ocupa(Jugador, _)).

controla(Jugador, Continente):-
    jugador(Jugador), ubicadoEn(_, Continente),
    forall(ubicadoEn(Pais, Continente), ocupa(Jugador,Pais)).

reñido(Continente):-
    tienePresenciaEn(_, Continente),
    forall(jugador(Jugador), tienePresenciaEn(Jugador, Continente)).

atrincherado(Jugador):-
    jugador(Jugador), ubicadoEn(_,Continente),
    forall(ocupa(Jugador, Pais), ubicadoEn(Pais, Continente)).

puedeConquistar(Jugador, Continente):-
    jugador(Jugador), ubicadoEn(_, Continente),
    not(controla(Jugador, Continente)),
forall(not(tienePresenciaEn(Pais, Continente)), puedeAtacar(Jugador, Pais)).

puedeAtacar(Jugador, Pais):-
    ocupa(Jugaodr, UnPais),
    limitrofes(UnPais, Pais),
    not((aliados(Jugador, Aliado), ocupa(Aliado, Pais))).

/* Extender la base de conocimiento con los siguientes predicados:
1) libroMasCaro/1: Se cumple para un articulo si es el libro de mayor precio.
2) curiosidad/1: Se cumple para un articulo si es lo unico que hay a la venta de su autor.
3) sePrestaAConfusion/1: Se cumple para un titulo si pertence a mas de un articulo.
4) mixto/1: Se cumple para los autores de mas de un tipo de artiuclo.
5) Agregar soporte para vender Peliculas con titulo, director y genero. 
*/

libroMasCaro(libro(Titulo, Autor, Genero, Editorial)):-
    vende(libro(Titulo, Autor, Genero, Editorial), Precio),
    forall(vende(libro(_,_,_,_), OtroPrecio), OtroPrecio =< Precio).

curiosidad(Articulo):-
    vende(Articulo, _), 
    autor(Articulo, Autor),
    not((vende(Otro, _), autor(Otro, Autor), Articulo \= Otro)).

sePrestaAConfusion(Titulo):-
    titulo(UnArticulo, Titulo),
    titulo(OtroArticulo, Titulo),
    UnArticulo \= OtroArticulo.

titulo(libro(Titulo, _, _, _), Titulo):-
    vende(libro(Titulo, _, _, _), _).

titulo(cd(Titulo, _, _, _, _), Titulo):-
    vende(cd(Titulo, _, _, _, _), _).

titulo(pelicula(Titulo, _, _, _, _), Titulo):-
    vende(pelicula(Titulo, _, _, _, _), _).

mixto(Autor):-
    autor(libro(_,_,_,_), Autor),
    autor(cd(_,_,_,_), Autor).
    %autor(pelicula(_,_,_), Autor). No va pq las peliculas no tienen autores, tienen directores

% Agregar Pelicula

vende(pelicula(it, terror, wallace), 1600).

/* Extender la base de conocimientos con los siguientes predicados:
1) trivial/1: Se cumple para las recetas con un unico ingrediente.
2) elPeor/2: Relaciona una receta con su ingrediente mas calorico.
3) caloriasTotales/2: Relaciona una receta y su total de calorias.
4) versionLight/2: Relaciona una receta con sus ingredientes, sin el peor.
5) guasada/1: Se cumple para una receta con algun ingrediente de mas de 1000Kcal.
*/

receta(Nombre, Ingredientes). % Relaciona un nombre con una lista de ingredientes.
ingrediente(Ingrediente). % Me dice todos los posibles ingredientes. 
calorias(Ingrediente, Calorias). % Relaciona a los ingredientes con las calorias. Necesita recibir los ingredientes.

trivial(Receta):-
    receta(Receta, [_]). % La lista tiene un solo elemento.

/* Con Recursividad:
elPeor(Ingredientes, Peor):-
    elPeor([Peor], Peor).
elPeor([Ingrediente | Otros], Peor):-
    elPeor(Otros, OtroIngrediente),
    calorias(OtroIngrediente, CaloriasOtroIngrediente),
    calorias(Ingrediente, CaloriasIngrediente),
    CaloriasIngrediente >= CaloriasOtroIngrediente.
elPeor([Ingrediente | Otros], OtroIngrediente):-
    elPeor(Otros, OtroIngrediente),
    calorias(OtroIngrediente, CaloriasOtroIngrediente),
    calorias(Ingrediente, CaloriasIngrediente),
    CaloriasIngrediente < CaloriasOtroIngrediente.
*/

elPeor(Ingredientes, Peor):-
    member(Peor, Ingredientes),
    calorias(Peor, CaloriasDelPeor),
    forall(member(Ingrediente, Ingredientes),(calorias(Ingrediente, Calorias), CaloriasDelPeor >= Calorias)).

caloriasTotales(Receta, Total):-
    receta(Receta, Ingredientes),
    findall(Kcal, (member(Ing, Ingredientes), calorias(Ing, Kcal)), Kcals),
    sumlist(Kcals, Total.)

versionLight(Receta, IngredientesLight):-
    receta(Receta, Ingredientes),
    elPeor(Ingredientes, Peor),
    findall(Ing, (member(Ing, Ingredientes), Ing \= Peor), IngredientesLight).

guasada(Receta):-
    receta(Receta, Ingredientes),
    member(Ing, Ingredientes),
    calorias(Ing, Kcal),
    Kcal > 1000.
    