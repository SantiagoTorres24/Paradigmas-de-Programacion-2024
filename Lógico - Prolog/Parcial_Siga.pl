%Días de cursadas (toda materia que se dicte ofrece al menos una opción horaria)
opcionHoraria(paradigmas, lunes).
opcionHoraria(paradigmas, martes).
opcionHoraria(paradigmas, sabados).
opcionHoraria(algebra, lunes).
(...)
%Correlatividades
correlativa(paradigmas, algoritmos).
correlativa(paradigmas, algebra).
correlativa(analisis2, analisis1).
(...)
%cursada(persona,materia,evaluaciones)
cursada(maria, algoritmos, [parcial(5), parcial(7), tp(mundial, bien)]).
cursada(maria,algebra,[parcial(5),parcial(8),tp(geometria,excelente)]).
cursada(maria,analisis1,[parcial(9),parcial(4),tp(gauss,bien), tp(limite,mal)]).
cursada(wilfredo,paradigmas,[parcial(7),parcial(7),parcial(7),tp(objetos,excelente),tp(logico,excelent
e),tp(funcional,excelente)]).
cursada(wilfredo,analisis2,[parcial(8),parcial(10)]).
cursada(santi, paradigmas, [parcial(8), parcial(8), parcial(8)]).

materia(Materia):-
    opcionHoraria(Materia, _).
persona(Persona):-
    cursada(Persona, _, _).

% 1)
encontrarNota(parcial(Nota), Nota).
encontrarNota(tp(_, excelente), 10).
encontrarNota(tp(_, bien), 7).
encontrarNota(tp(_, mal), 2).

notaFinal(Notas, NotaFinal):-
    findall(NotaEvaluacion, (member(Nota, Notas), encontrarNota(Nota, NotaEvaluacion)), NotasEvaluacion),
    sumlist(NotasEvaluacion, TotalNotas),
    length(Notas, CantidadNotas),
    NotaFinal is TotalNotas / CantidadNotas.
    
% 2)
aprobo(Persona, Materia):-
    cursada(Persona, Materia, EvaluacionesPersona),
    notaFinal(EvaluacionesPersona, NotaFinal),
    NotaFinal >= 4.
% 3)
puedeCursar(Persona, Materia):-
    not(aprobo(Persona, Materia)),
    correlativa(Materia, MateriaAprobada),
    aprobo(Persona, MateriaAprobada).
puedeCursar(Persona, Materia):-
    not(correlativa(Materia, _)),
    not(aprobo(Persona, Materia)).

% 4)
% 4)
opcionesDeCursada(Persona, CursadasPosibles):-
    persona(Persona),
    findall(opcion(Materia, Dia), 
            (puedeCursar(Persona, Materia), 
             opcionHoraria(Materia, Dia)), 
            CursadasPosibles).
