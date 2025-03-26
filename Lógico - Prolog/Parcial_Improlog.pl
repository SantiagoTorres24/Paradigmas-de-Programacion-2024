integrante(sophieTrio, sophie, violin).
integrante(sophieTrio, santi, guitarra).
integrante(vientosDelEste, lisa, saxo).
integrante(vientosDelEste, santi, voz).
integrante(vientosDelEste, santi, guitarra).
integrante(jazzmin, santi, bateria).

nivelQueTiene(sophie, violin, 5).
nivelQueTiene(santi, guitarra, 2).
nivelQueTiene(santi, voz, 3).
nivelQueTiene(santi, bateria, 4).
nivelQueTiene(lisa, saxo, 4).
nivelQueTiene(lore, violin, 4).
nivelQueTiene(luis, trompeta, 1).
nivelQueTiene(luis, contrabajo, 4).

instrumento(violin, melodico(cuerdas)).
instrumento(guitarra, armonico).
instrumento(bateria, ritmico).
instrumento(saxo, melodico(viento)).
instrumento(trompeta, melodico(viento)).
instrumento(contrabajo, armonico).
instrumento(bajo, armonico).
instrumento(piano, armonico).
instrumento(pandereta, ritmico).
instrumento(voz, melodico(vocal)).

tieneBuenaBase(Grupo):-
    integrante(Grupo, Integrante, Instrumento),
    integrante(Grupo, OtroIntegrante, OtroInstrumento),
    Integrante \= OtroIntegrante,
    Instrumento \= OtroInstrumento,
    instrumento(Instrumento, ritmico),
    instrumento(OtroInstrumento, armonico).

integranteTocaMasDeUnInstrumento(Integrante, Grupo):-
    integrante(Grupo, Integrante, Instrumento),
    integrante(Grupo, Integrante, OtroInstrumento),
    Instrumento \= OtroInstrumento.

superaPorAlMenos2Puntos(Persona, OtraPersona, Grupo):-
    not(integranteTocaMasDeUnInstrumento(OtraPersona, Grupo)),
    nivelQueTiene(Persona, _, NivelPersona),
    nivelQueTiene(OtraPersona, _, NivelOtraPersona),
    NivelPersona - NivelOtraPersona >= 2.
superaPorAlMenos2Puntos(Persona, OtraPersona, Grupo):-
    integranteTocaMasDeUnInstrumento(OtraPersona, Grupo),
    findall(Nivel, nivelQueTiene(OtraPersona, _, Nivel), Niveles),
    max_member(MaxNivel, Niveles),
    nivelQueTiene(Persona, _, NivelPersona),
    NivelPersona - MaxNivel >=2.
    
seDestaca(Persona, Grupo):-
    integrante(Grupo, Persona, _),
    forall((integrante(Grupo, OtraPersona, _), Persona \= OtraPersona),
    superaPorAlMenos2Puntos(Persona, OtraPersona, Grupo)).

grupo(vientosDelEste, bigBand).
grupo(sophieTrio, necesitaFormacion(contrabajo)).
grupo(sophieTrio, necesitaFormacion(guitarra)).
grupo(sophieTrio, necesitaFormacion(violin)).
grupo(jazzmin, necesitaFormacion(bateria)).
grupo(jazzmin, necesitaFormacion(bajo)).
grupo(jazzmin, necesitaFormacion(trompeta)).
grupo(jazzmin, necesitaFormacion(piano)).
grupo(jazzmin, necesitaFormacion(guitarra)).
grupo(estudio1, ensamble(3)).

sirveParaBigBand(bateria).
sirveParaBigBand(bajo).
sirveParaBigBand(piano).

sirveParaGrupo(Instrumento, Grupo):-
    grupo(Grupo, necesitaFormacion(Instrumento)).
sirveParaGrupo(Instrumento, Grupo):-
    grupo(Grupo, bigBand),
    sirveParaBigBand(Instrumento).
sirveParaGrupo(Instrumento, Grupo):-
    grupo(Grupo, ensamble(_)).

hayCupo(Instrumento, Grupo):-
    grupo(Grupo, bigBand),
    instrumento(Instrumento, melodico(viento)).
hayCupo(Instrumento, Grupo):-
    integrante(Grupo, _, OtroInstrumento),
    OtroInstrumento \= Instrumento,
    sirveParaGrupo(Instrumento, Grupo).

tieneNivelMinimo(Grupo, Persona, Instrumento):-
    grupo(Grupo, bigBand),
    nivelQueTiene(Persona, Instrumento, Nivel),
    Nivel >= 1.
tieneNivelMinimo(Grupo, Persona, Instrumento):-
    grupo(Grupo, necesitaFormacion(_)),
    findall(InstrumentoBuscado, grupo(Grupo, necesitaFormacion(InstrumentoBuscado)), Instrumentos),
    length(Instrumentos, CantidadDeInstrumentos),
    nivelQueTiene(Persona, Instrumento, Nivel),
    Nivel >= 7-CantidadDeInstrumentos.
tieneNivelMinimo(Grupo, Persona, Instrumento):-
    grupo(Grupo, ensamble(NivelMinimo)),
    nivelQueTiene(Persona, Instrumento, Nivel),
    Nivel >= NivelMinimo.  

puedeIncorporarAGrupo(Persona, Grupo, Instrumento):-
    not(integrante(Grupo, Persona, _)),
    hayCupo(Instrumento, Grupo),
    tieneNivelMinimo(Grupo, Persona, Instrumento).

seQuedoEnBanda(Persona):-
    not(integrante(_, Persona, Instrumento)),
    not(puedeIncorporarAGrupo(Persona, Grupo, Instrumento)).

tocanInstrumentosDeViento(Grupo, N):-
    findall(Viento, (integrante(Grupo, Integrante, Viento),instrumento(Viento, melodico(viento))), Vientos),
    sumlist(Vientos, CantidadDeVientos),
    CantidadDeVientos >= N.

puedeTocar(Grupo):-
    grupo(Grupo, bigBand),
    tieneBuenaBase(Grupo),
    tocanInstrumentosDeViento(Grupo, 5).
puedeTocar(Grupo):-
    grupo(Grupo, necesitaFormacion(_)),
    forall(grupo(Grupo, necesitaFormacion(Instrumento)),
    integrante(Grupo, Persona, Instrumento)).
puedeTocar(Grupo):-
    grupo(Grupo, ensamble(_)),
    tieneBuenaBase(Grupo),
    integrante(Grupo, Persona, Instrumento),
    instrumento(Instrumento, melodico(_)).