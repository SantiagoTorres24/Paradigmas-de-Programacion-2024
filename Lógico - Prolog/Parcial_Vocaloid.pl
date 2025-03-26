% megurineLuka sabe cantar la canción nightFever cuya duración es de 4 min y también 
% canta la canción foreverYoung que dura 5 minutos.
cantante(megurineLuka, nightFever, 4).
cantante(megurineLuka, foreverYoung, 5).
% hatsuneMiku sabe cantar la canción tellYourWorld que dura 4 minutos.
cantante(hatsuneMiku, tellYourWorld, 4).
% gumi sabe cantar foreverYoung que dura 4 min y tellYourWorld que dura 5 min
cantante(gumi, foreverYoung, 4).
cantante(gumi, tellYourWorld, 5).
% seeU sabe cantar novemberRain con una duración de 6 min y nightFever con una 
% duración de 5 min
cantante(seeU, novemberRain, 6).
cantante(seeU, nightFever, 5).

% un vocaloid es novedoso cuando saben al menos 2 canciones y el tiempo total 
% que duran todas las canciones debería ser menor a 15.
cantidadCanciones(Vocaloid, TotalCanciones):-
    findall(Cancion, cantante(Vocaloid, Cancion, _), Canciones),
    length(Canciones, TotalCanciones).
duracionTotal(Vocaloid, DuracionTotal):-
    findall(Minuto, cantante(Vocaloid, _, Minuto), Minutos),
    sumlist(Minutos, DuracionTotal).

vocaloidNovedoso(Vocaloid):-
    cantante(Vocaloid, _, _),
    cantidadCanciones(Vocaloid, TotalCanciones),
    TotalCanciones >= 2,
    duracionTotal(Vocaloid, DuracionTotal),
    DuracionTotal < 15.
    
% es acelerado, condición que se da cuando todas sus canciones duran 4 
% minutos o menos. Resolver sin usar forall
vocaloidAcelerado(Vocaloid):-
    cantante(Vocaloid, _, _),
    not((cantante(Vocaloid, Cancion, Duracion), Duracion > 4)).

% Miku Expo, es un concierto gigante que se va a realizar en Estados Unidos, le brinda 
% 2000 de fama al vocaloid que pueda participar en él y pide que el vocaloid sepa más 
% de 2 canciones y el tiempo mínimo de 6 minutos.
concierto(mikuExpo, estadosUnidos, 2000, gigante(2,6)).
% Magical Mirai, se realizará en Japón y también es gigante, pero da una fama de 3000 y 
% pide saber más de 3 canciones por cantante con un tiempo total mínimo de 10 minutos. 
concierto(magicalMirai, japon, 3000, gigante(3, 10)).
% Vocalekt Visions, se realizará en Estados Unidos y es mediano brinda 1000 de fama y 
% exige un tiempo máximo total de 9 minutos
concierto(vocalektVisions, estadosUnidos, 1000, mediano(9)).
% Miku Fest, se hará en Argentina y es un concierto pequeño que solo da 100 de fama al 
% vocaloid que participe en él, con la condición de que sepa una o más canciones de 
% más de 4 minutos.
concierto(mikuFest, argentina, 100, pequeño(4)).

% Se requiere saber si un vocaloid puede participar en un concierto, esto se da cuando
% cumple los requisitos del tipo de concierto. También sabemos que Hatsune Miku puede 
% participar en cualquier concierto.
puedeParticipar(hatsuneMiku, _).
puedeParticipar(Vocaloid, Concierto):-
    cantante(Vocaloid, _, _ ),
    Vocaloid \= hatsuneMiku,
    concierto(Concierto, _, _, Requisitos),
    cumpleRequisitos(Vocaloid, Requisitos).
cumpleRequisitos(Vocaloid, gigante(CantidadCanciones, DuracionTotalRequerida)):-
    cantidadCanciones(Vocaloid, TotalCanciones),
    TotalCanciones >= CantidadCanciones,
    duracionTotal(Vocaloid, DuracionTotal),
    DuracionTotal > DuracionTotalRequerida.
cumpleRequisitos(Vocaloid, mediano(DuracionTotalRequerida)):-
    duracionTotal(Vocaloid, DuracionTotal),
    DuracionTotal < DuracionTotalRequerida.
cumpleRequisitos(Vocaloid, pequeño(DuracionRequerida)):-
    cantante(Vocaloid, _, Duracion),
    Duracion > DuracionRequerida.
% Conocer el vocaloid más famoso, es decir con mayor nivel de fama. El nivel de fama de
% un vocaloid se calcula como la fama total que le dan los conciertos en los cuales 
% puede participar multiplicado por la cantidad de canciones que sabe cantar.
vocaloidMasFamoso(Vocaloid):-
    nivelDeFama(Vocaloid, Fama),
    forall(nivelDeFama(_, OtraFama), Fama >= OtraFama).
nivelDeFama(Vocaloid, FamaTotal):-
    cantidadCanciones(Vocaloid, TotalCanciones),
    famaPorConciertos(Vocaloid, FamaConciertos),
    Fama is (TotalCanciones * FamaConciertos).
famaPorConciertos(Vocaloid, FamaConciertos):-
    findall(Fama, (puedeParticipar(Vocaloid, Concierto), 
    concierto(Concierto, _, Fama, _), FamaTotal)),
    sumlist(FamaTotal, famaPorConciertos).
/* Sabemos que:
megurineLuka conoce a hatsuneMiku  y a gumi 
gumi conoce a seeU
seeU conoce a kaito

Queremos verificar si un vocaloid es el único que participa de un concierto, esto se 
cumple si ninguno de sus conocidos ya sea directo o indirectos (en cualquiera de los 
niveles) participa en el mismo concierto.*/
conoceA(megurineLuka, hatsuneMiku).
conoceA(megurineLuka, gumi).
conoceA(gumi, seeU).
conoceA(seeU, kaito).
%Conocido directo
conocido(Cantante, OtroCantante) :- 
    conoceA(Cantante, OtroCantante).
 %Conocido indirecto
conocido(Cantante, OtroCantante) :- 
    conoceA(Cantante, UnCantante), 
    conocido(UnCantante, OtroCantante).
unicoEnConcierto(Vocaloid, Concierto):-
    puedeParticipar(Vocaloid, Concierto)
    forall(puedeParticipar(OtroVocaloid, Concierto), 
    not(conocido(Vocaloid, OtroVocaloid))).