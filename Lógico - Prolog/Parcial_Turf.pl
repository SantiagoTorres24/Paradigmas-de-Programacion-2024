% 1)
% jockey(Jockey, Altura, Peso).
jockey(valdivieso, 155, 52).
jockey(leguisamo, 161, 49).
jockey(lezcano, 149, 50).
jockey(baratucci, 153, 55).
jockey(falero, 157, 52).

% caballo(Caballo).
caballo(botafogo).
caballo(oldMan).
caballo(energica).
caballo(matBoy).
caballo(yatasto).

%leGusta(Caballo, Jockey).
leGusta(botafogo, baratucci).
leGusta(botafogo, Jockey):-
    jockey(Jockey, _, Peso),
    Peso < 52.
leGusta(oldMan, Jockey):-
    jockey(Jockey, _, _),
    atom_length(Jockey, LetrasJockey),
    LetrasJockey > 7.
leGusta(energica, Jockey):-
    jockey(Jockey, _, _),
    not(leGusta(botafogo, Jockey)).
leGusta(matBoy, Jockey):-
    jockey(Jockey, Altura, _),
    Altura > 170.

% stud(Jockey, Stud).
stud(valdivieso, elTute).
stud(falero, elTute).
stud(lezcano, lasHormigas).
stud(baratucci, elCharabon).
stud(leguisamo, elCharabon).

% gano(Caballo, Premio).
gano(botafogo, nacional).
gano(botafogo, republica).
gano(oldMan, republica).
gano(oldMan, palermoDeOro).
gano(matBoy, criadores).

% Conceptos que Intervienen:
% La base de conocimientos compone todo el universo conocido, todo lo que está fuera no
% se puede probar que existe, por lo tanto se asume falso según el Principio de Universo Cerrado. 

% Definicion por Extension:
% Se definen varias reglas en lugar de usar una lista, sucede en varios predicados y 
% esto mejora la claridad y legibilidad, la simplicidad en las consultas, la declaratividad
% y la facilidad de mantenimiento. 

% 2)
prefiereAMasDeUnJockey(Caballo):-
    leGusta(Caballo, Jockey),
    leGusta(Caballo, OtroJockey),
    Jockey \= OtroJockey.

% 3)
noPrefiereAJockeyDeCaballeria(Caballo, Caballeria):-
    caballo(Caballo),
    stud(Jockey, Caballeria),
    not(leGusta(Caballo, Jockey)).

% 4)
esPremioImportante(nacional).
esPremioImportante(republica).

esPiolin(Jockey):-
    jockey(Jockey, _, _),
    forall((gano(Caballo, Premio), esPremioImportante(Premio)), 
           leGusta(Caballo, Jockey)).

% 5)
apuestaGanadora(ganador(Caballo), Resultado):-
    nth0(0, Resultado, Caballo).
apuestaGanadora(segundo(Caballo), Resultado):-
    nth0(1, Resultado, Caballo).
apuestaGanadora(exacta(Caballo1, Caballo2), Resultado):-
    nth0(0, Resultado, Caballo1),
    nth0(1, Resultado, Caballo2).
apuestaGanadora(imperfecta(Caballo1, Caballo2), Resultado):-
    apuestaGanadora(exacta(Caballo1, Caballo2, Resultado)).
apuestaGanadora(imperfecta(Caballo1, Caballo2), Resultado):-
    apuestaGanadora(exacta(Caballo2, Caballo1, Resultado)).

% 6)
color(botafogo, negro).
color(oldMan, marron).
color(energica, gris).
color(energica, negro).
color(matBoy, marron).
color(matBoy, blanco).
color(yatasto, blanco).
color(yatasto, marron).

preferenciaPorColor(Color, Caballos):-
    findall(Caballo, color(Caballo, Color), CaballosPosibles),
    combinar(CaballosPosibles, Caballos).

combinar([], []).
combinar([Caballo|CaballosPosibles], [Caballo|Caballos]):-
  combinar(CaballosPosibles, Caballos).
combinar([_|CaballosPosibles], Caballos):-
  combinar(CaballosPosibles, Caballos).