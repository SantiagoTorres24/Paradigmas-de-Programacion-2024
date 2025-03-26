% alumno(Nombre, Edad, IdiomaNativo).
% plan(Nombre, Plan).
% curso(Nombre, Idioma, Nivel).

% 1)
idioma(ingles, gratuito).
idioma(espaniol, gratuito).
idioma(portugues, gratuito).
idioma(italiano, premium).
idioma(hebreo, premium).
idioma(frances, premium).
idioma(chino, premium).
idioma(esperanto, excentrico).
idioma(klingon, excentrico).
idioma(latin, excentrico).

alumno(cristian, 22, espaniol).
plan(cristian, gratuito).
curso(cristian, ingles, 7).
curso(cristian, portugues, 15)

alumno(maria, 34, ingles).
plan(maria, premium(bronce)).
curso(maria, hebreo, 1).

alumno(felipe, 60, italiano).
plan(felipe, premium(oro)).

alumno(juan, 12, espaniol).
plan(juan, cuentaGotas).
curso(juan, ingles, 20).

% 2)
estaAvanzado(Alumno, Idioma):-
    curso(Alumno, Idioma, Nivel),
    Nivel >= 15.

% 3)
tieneCertificado(Alumno):-
    curso(Alumno, _, 20).

% 4) 
lenguaCodiciada(IdiomaNativo, IdiomaNuevo):-
    idioma(IdiomaNativo, _),
    idioma(IdiomaNuevo, _),
    forall(alumno(Alumno, _, IdiomaNativo), curso(Alumno, IdiomaNuevo, _)).

% 5) 
hablaIdioma(Alumno, Idioma):-
    alumno(Alumno, _, Idioma).
hablaIdioma(Alumno, Idioma):-
    estaAvanzado(Alumno, Idioma).

leFaltaAprender(Alumno, Idioma):-
    alumno(Alumno, _, _),
    idioma(Idioma, _),
    not(hablaIdioma(Alumno, Idioma)).

% 6)
poliglota(Alumno):-
    alumno(Alumno, _, _),
    findall(Idioma, hablaIdioma(Alumno, Idioma), Idiomas),
    length(Idiomas, CantidadDeIdiomas),
    CantidadDeIdiomas >= 3.

% 7)
puedeHacerCurso(Alumno, Idioma):-
    plan(Alumno, Plan),
    cursoSegunPlan(Alumno, Plan, Idioma).

cursoSegunPlan(_, _, Idioma):-
    idioma(Idioma, gratuito).
cursoSegunPlan(_, premium(oro), _).
puedeHacerCurso(Alumno, premium(bronce), idioma):-
    noExcedeLimiteCursos(Persona, Idioma, 3).
puedeHacerCurso(Alumno, premium(plata), idioma):-
    noExcedeLimiteCursos(Persona, Idioma, 7).

noExcedeLimiteCursos(Alumno, Idioma, CantidadLimite):-
    idioma(Idioma, premium),
    cantidadCursosPremium(Alumno, Cantidad),
    Cantidad <= CantidadLimite

cantidadCursosPremium(Alumno, Cantidad):-
    findall(Idioma, (curso(Alumno, Idioma, _), idioma(Idioma, premium)), Idiomas),
    length(Idiomas, Cantidad).
    
% 8)
sigue(alumno1, alumno2).
sigue(alumno3, alumno4).
sigue(alumno5, alumno6).

esExcentrico(Alumno):-
    hablaIdioma(Alumno, Idioma),
    idioma(Idioma, excentrico).
esExcentrico(Alumno):-
    not(hablaIdioma(Alumno, ingles)),
    cantidadIdiomasQueHabla(Alumno, Cantidad),
    Cantidad >= 5.

cantidadIdiomasQueHabla(Alumno, Cantidad):-
    findall(Idioma, hablaIdioma(Alumno, Idioma), Idiomas),
    length(Idiomas, Cantidad).

tieneExcentricismo(Alumno):-
    alumno(Alumno, _, _),
    forall(sigue(Seguidor, Alumno), esExcentrico(Seguidor)).

% 9)
conocePersona(Persona, OtraPersona):-
    sigue(Persona, OtraPersona).
conocePersona(Persona, OtraPersona):-
    sigue(Persona, TerceraPersona),
    conocePersona(TerceraPersona, OtraPersona).

idiomaQueTraduce(Persona, Idioma):-
    hablaIdioma(Persona, Idioma).
idiomaQueTraduce(Persona, Idioma):-
    conocePersona(Persona, OtraPersona),
    hablaIdioma(OtraPersona, Idioma).
