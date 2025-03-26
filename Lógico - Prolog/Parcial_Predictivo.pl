% mensaje(ListaDePalabras, Receptor).
%	Los receptores posibles son:
%	Persona: un simple átomo con el nombre de la persona; ó
%	Grupo: una lista de al menos 2 nombres de personas que pertenecen al grupo.
mensaje(['hola', ',', 'que', 'onda', '?'], nico).
mensaje(['todo', 'bien', 'dsp', 'hablamos'], nico).
mensaje(['q', 'parcial', 'vamos', 'a', 'tomar', '?'], [nico, lucas, maiu]).
mensaje(['todo', 'bn', 'dsp', 'hablamos'], [nico, lucas, maiu]).
mensaje(['todo', 'bien', 'despues', 'hablamos'], mama).
mensaje(['¿','y','q', 'onda', 'el','parcial', '?'], nico).
mensaje(['¿','y','que', 'onda', 'el','parcial', '?'], lucas).

% abreviatura(Abreviatura, PalabraCompleta) relaciona una abreviatura con su significado.
abreviatura('dsp', 'después').
abreviatura('q', 'que').
abreviatura('q', 'qué').
abreviatura('bn', 'bien').

% signo(UnaPalabra) indica si una palabra es un signo.
signo('¿').    signo('?').   signo('.').   signo(','). 

% filtro(Contacto, Filtro) define un criterio a aplicar para las predicciones para un contacto
filtro(nico, masDe(0.5)).
filtro(nico, ignorar(['interestelar'])).
filtro(lucas, masDe(0.7)).
filtro(lucas, soloFormal).
filtro(mama, ignorar(['dsp','paja'])).

recibioMensaje(Persona, Mensaje):-
    mensaje(Mensaje, Persona).
    
recibioMensaje(Persona, Mensaje):-
    mensaje(Mensaje, Personas),
    member(Persona, Personas).

tieneAbreviatura(Mensaje):-
    member(Abv, Mensaje),
    abreviatura(Abv, _).

demasiadoFormal(Mensaje):-
    mensaje(Mensaje, _),
    length(Mensaje, CantidadPalabras),
    CantidadPalabras > 20,
    member(Signo, Mensaje),
    signo(Signo),
    not(tieneAbreviatura(Mensaje)).
demasiadoFormal(Mensaje):-
    mensaje(Mensaje, _),
    nth0(0, Mensaje,'¿'),
    not(tieneAbreviatura(Mensaje)).

tasaDeUso(Palabra, Persona, TasaDeUso):-
    findall(PalabraTasa, (mensaje(Mensaje, Persona), member(PalabraTasa, Mensaje)), PalabrasTasa),
    findall(PalabraEnTotal, (mensaje(Mensaje, _), member(PalabraEnTotal, Mensaje), PalabraEnTotales)),
    length(PalabrasTasa, TotalPersona),
    length(PalabraEnTotales, TotalPalabra),
    TasaDeUso is TotalPersona / TotalPalabra.

palabraPasaFiltro(Palabra, masDe(N), Persona):-
    tasaDeUso(Palabra, Persona, TasaDeUso),
    TasaDeUso > N.
palabraPasaFiltro(Palabra, ignorar(Palabras), _):-
    not(member(Palabra, Palabras)).
palabraPasaFiltro(Palabra, soloFormal, _):-
    mensaje(Mensaje, _),
    member(Palabra, Mensaje),
    demasiadoFormal(Mensaje).

esAceptable(Palabra, Persona):-
    persona(Persona, _),
    forall(filtro(Persona, Filtro), palabraPasaFiltro(Palabra, Filtro, Persona)).

esIgualA(Palabra, OtraPalabra):-
    Palabra = OtraPalabra.
esIgualA(Palabra, OtraPalabra):-
    abreviatura(Palabra, PalabraCompleta),
    PalabraCompleta = OtraPalabra.
esIgualA(Palabra, OtraPalabra):-
    abreviatura(OtraPalabra, PalabraCompleta),
    Palabra = PalabraCompleta.

dicenLoMismo([], []).
dicenLoMismo([Palabra1|Resto1], [Palabra2|Resto2]) :-
    esIgualA(Palabra1, Palabra2),
    dicenLoMismo(Resto1, Resto2).

tieneMensaje(Mensaje, Persona):-
    mensaje(Mensaje, Persona).
tieneMensaje(Mensaje, Persona):-
    mensaje(OtroMensaje, Persona),
    dicenLoMismo(Mensaje, OtroMensaje).

contactosDelUsuario(Contactos) :-
    findall(Persona, recibioMensaje(Persona, _), ListaContactos),
    sort(ListaContactos, Contactos).

mensajeEsIgualParaTodos(Mensaje, Contactos) :-
    mensaje(Mensaje, _),
    forall(member(Persona, Contactos), tieneMensaje(Mensaje, Persona)).

fraseCelebre(Mensaje) :-
    contactosDelUsuario(Contactos),
    mensajeEsIgualParaTodos(Mensaje, Contactos).

% prediccion(Mensaje, Receptor, Prediccion):-

