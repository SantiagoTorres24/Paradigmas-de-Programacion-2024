% 1)
usuario(markitocuchillos, 45000).
usuario(sebaElDolar, 5000).
usuario(tiqtoqera, 5000).
usuario(user99018, 1).

subio(markitocuchillos, video("Gatito toca el piano", 45, 50, 1000)).
subio(markitocuchillos, video("Gatito toca el piano 2", 65, 2, 2)).
subio(sebaElDolar, video("300 ¿es el dólar o Esparta?", 60000, 2000, 1040500)).
subio(sebaElDolar, stream).
subio(tiqtoqera, short(15, 800000, [goldenHauer, cirugiaEstetica])).
subio(tiqtoqera, short(20, 0, [])).
subio(tiqtoqera, stream).

% 2)
myTuber(MyTuber):-
    subio(MyTuber, _).

% 3) 
esMilenial(MyTuber):-
    subio(MyTuber, Video),
    videoMilenial(Video).

videoMilenial(Video):-
    subio(_, video(_, _, 1000)).
videoMilenial(Video):-
    subio(_, video(_, 1000, _)).

% 4)
noSubioVideo(Usuario):-
    usuario(Usuario, _),
    not(subio(Usuario, video(_, _, _))).

% 5)
engagementContenido(video(_, Views, Likes), EngagementVideo):-
    EngagementVideo is (Likes + Views).
engagementContenido(short(_, Likes, _), Likes).
engagementContenido(stream, 2000).

engagementMyTuber(MyTuber, EngagementTotal):-
    subio(MyTuber, _),
    findall(Engagement, 
           (subio(Mytuber, Contenido), engagementContenido(Contenido, Engagement)), Engagements),
    sumlist(Engagements, EngagementTotal).

% 6)
puntosPorContenido(MyTuber, Puntos):-
    subio(MyTuber, short(_, _, Filtros)),
    length(Filtros, CantidadDeFiltros),
    Puntos is 2 * CantidadDeFiltros.
puntosPorContenido(MyTuber, 1):-
    subio(MyTuber, Contenido),
    engagementContenido(Contenido, Engagement),
    Engagement > 10000.
puntosPorContenido(MyTuber, 2):-
    subio(MyTuber, video(_, Duracion, _, _)),
    Duracion > 6000.
puntosPorContenido(MyTuber, 1):-
    subio(MyTuber, Contenido),
    subio(MyTuber, OtroContenido),
    Contenido \= OtroContenido.
puntosPorContenido(MyTuber, 10):-
    engagementMyTuber(MyTuber, Engagement),
    Engagement > 1000000.

puntosMyTuber(MyTuber, TotalPuntos):-
    subio(MyTuber, _),
    findall(Punto, puntosPorContenido(MyTuber, Punto), Puntos),
    sumlist(Puntos, TotalPuntos).

% 7) 
esElMejor(MyTuber):-
    puntosMyTuber(MyTuber, PuntosMyTuber),
    forall((puntosMyTuber(OtroMyTuber, PuntosOtroMyTuber), MyTuber \= OtroMyTuber),
          PuntosMyTuber > PuntosOtroMyTuber).

% 8)
administra(martin, sebaElDolar).
administra(martin, markitocuchillos).
administra(iniaki, martin).
administra(iniaki, gaston).
administra(gaston, tiqtoqera).

representa(Manager, MyTuber):-
    administra(Manager, MyTuber).
representa(Manager, MyTuber):-
    administra(Manager, OtroManager),
    representa(OtroManager, MyTuber).


