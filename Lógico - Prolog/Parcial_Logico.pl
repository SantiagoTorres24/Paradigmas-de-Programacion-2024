% 1)
palabra(pgt, perro, 2112).
palabra(piscis, perro, 2150).
palabra(pongAI, perro, 2112).

palabra(pgt, gato, 2215).
palabra(piscis, gato, 2215).
palabra(pongAI, gato, 2215).

palabra(pgt, comida, 2450).
palabra(piscis, comida, 2700).
palabra(pongAI,comida 2492).

palabra(pgt, morfi, 2452).
palabra(piscis, morfi, 2721).
% Morfi no existe en PongAI y por el principio del Universo Cerrado todo lo que no este
% en la base de conocimientos se considera como falso. Por lo tanto, no agrego esta
% informacion a mi base de conocimientos. 

palabra(pgt, corcho, 1852).
palabra(piscis, corcho, 1918).
palabra(pongAI, corcho, 1918).

palabra(pgt, palabra, 1999).

palabra(pgt, cosito, 1000).
palabra(piscis, cosito, 1000).
palabra(pongAI, cosito, 1000).

palabra(pgt, ruby, 2000).

% MartínEsElMejorProfe tampoco existe y en este caso en ningun modelo, entonces por 
% principio del Universo Cerrado se considera como falso.

modelo(Modelo):-
    palabra(Modelo, _, _).
persona(Persona):-
    perfil(Persona, _).

% 2)
noLaSabeNadie(Palabra):-
    not(palabra(_, Palabra, _)).
% 3)
sabePalabra(Palabra, Modelo) :-
    palabra(Modelo, Palabra, _).

esPalabraDificil(Palabra) :-
    palabra(Modelo, Palabra, _),  % Asegura que la palabra es conocida por algún modelo
    findall(OtroModelo, 
            (palabra(OtroModelo, _, _), Modelo \= OtroModelo, not(sabePalabra(Palabra, OtroModelo))), 
            OtrosModelos),
    length(OtrosModelos, CantidadModelosNoSaben),
    CantidadModelosNoSaben >= 2.

    
% 4)
diferenciaAbsoluta(Modelo, Palabra, OtraPalabra, Valor):-
    palabra(Modelo, Palabra, ValorPalabra),
    palabra(Modelo, OtraPalabra, ValorOtraPalabra),
    Diferencia is ValorPalabra - ValorOtraPalabra,
    Valor is abs(Diferencia).


sonPalabrasCercanasAux(Palabra1, Palabra2, Modelo):-
    palabra(Modelo, Palabra1, _),
    palabra(Modelo, Palabra2, _),
    Palabra1 \= Palabra2,
    diferenciaAbsoluta(Modelo, Palabra1, Palabra2, Valor),
    Valor < 200.

% 5)
sonSinonimos(cosito, Palabra, Modelo):-
    palabra(Modelo, Palabra, ValorPalabra),
    between(1800, 2100, ValorPalabra).
sonSinonimos(Palabra, OtraPalabra, Modelo):-
    palabra(Modelo, Palabra, _),
    palabra(Modelo, OtraPalabra, _),
    Palabra \= OtraPalabra,
    diferenciaAbsoluta(Modelo, Palabra, OtraPalabra, Valor),
    Valor < 20.

% Paradigmas no tiene sinonimo, y al no agregarla a mi base de conocimientos, siempre 
% que se consulte sobre esta palabra dara falso, por el principio del Universo Cerrado.

% 6)
modeloMenosBot(Modelo, Palabra, OtraPalabra) :-
    modelo(Modelo),
    palabra(Modelo, Palabra, _),
    palabra(Modelo, OtraPalabra, _),
    diferenciaAbsoluta(Modelo, Palabra, OtraPalabra, ValorModelo),
    forall((diferenciaAbsoluta(OtroModelo, Palabra, OtraPalabra, ValorOtroModelo),
            Modelo \= OtroModelo),
            ValorModelo < ValorOtroModelo).
    
% 7)
encontrarCantidadSinonimos(Palabra, Modelo, Cantidad):-
    modelo(Modelo),
    palabra(Modelo, Palabra, _),
    findall(Sinonimo, (palabra(Sinonimo), Palabra \= Sinonimo, sonSinonimos(Palabra, Sinonimo, Modelo)), 
    Sinonimos),
    length(Sinonimos, Cantidad).

palabraComodin(Palabra, Modelo):-
    palabra(Modelo, Palabra, _),
    not(( palabra(Modelo, OtraPalabra, _),
          Palabra \= OtraPalabra,
          encontrarCantidadSinonimos(Palabra, Modelo, CantidadSinonimosPalabra),
          encontrarCantidadSinonimos(OtraPalabra, Modelo, CantidadSinonimosOtraPalabra),
          CantidadSinonimosPalabra < CantidadSinonimosOtraPalabra )).

% 8)
perfil(pedro, programador(ruby, 5)).
perfil(maria, estudiante(programacion)).
perfil(sofia, estudiante(psicologia)).
perfil(juan, hijoDePapi).

esRelevante(Palabra, Persona, Modelo):-
    palabra(Modelo, Palabra, _),
    perfil(Persona, programador(Lenguaje, Experiencia)),
    palabra(Modelo, Lenguaje, _),
    Palabra \= Lenguaje,
    diferenciaAbsoluta(Modelo, Palabra, Lenguaje, Valor),
    Valor < Experiencia * 50.
esRelevante(Palabra, Persona, Modelo):-
    palabra(Modelo, Palabra, _),
    perfil(Persona, estudiante(programacion)),
    palabra(Modelo, wollok, _),
    diferenciaAbsoluta(Modelo, Palabra, wollok, Valor),
    Palabra \= wollok,
    Valor < 50.
esRelevante(Palabra, Persona, Modelo):-
    palabra(Modelo, Palabra, _),
    perfil(Persona, estudiante(Carrera)),
    diferenciaAbsoluta(Modelo, Palabra, Carrera, Valor),
    palabra(Modelo, Carrera, _),
    Palabra \= Carrera,
    Valor <= 200.
esRelevante(Palabra, Persona, Modelo):-
    palabra(Modelo, Palabra, _),
    perfil(Persona, hijoDePapi),
    palabra(Modelo, guita, _),
    sonSinonimos(Palabra, guita, Modelo). 
esRelevante(Palabra, Persona, Modelo):-
    palabra(Modelo, Palabra, _),
    perfil(Persona, futbolista),
    palabra(Modelo, pelotita, _),
    sonSinonimos(Palabra, pelotita, Modelo). % bonus


palabrasRelevantes(Palabras, Persona, Modelo):-
    persona(Persona), 
    modelo(Modelo), 
    findall(Palabra, esRelevante(Palabra, Persona, Modelo), Palabras).


% 9)
gusta(juan, plata).
gusta(maria, joda).
gusta(maria, tarjeta).
gusta(inia, estudiar).
gusta(bauti, utn).
gusta(martin, comer).

relacionado(plata, gastar).
relacionado(gastar, tarjeta).
relacionado(tarjeta, viajar).
relacionado(estudiar, utn).
relacionado(utn, titulo).
relacionado(tarjeta, finanzas).

relacionadoDirectoOIndirecto(OtroGusto, Gusto):- % relacion directa
    relacionado(OtroGusto, Gusto).
relacionadoDirectoOIndirecto(OtroGusto, Gusto):- % relacion indirecta
    relacionado(OtroGusto, AlgunGusto),
    relacionadoDirectoOIndirecto(AlgunGusto, Gusto).

leInteresa(Persona, Gusto):-
    gusta(Persona, Gusto).
leInteresa(Persona, Gusto):-
    gusta(Persona, OtroGusto),
    relacionadoDirectoOIndirecto(OtroGusto, Gusto).