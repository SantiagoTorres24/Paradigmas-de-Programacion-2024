% Nina es una joven de 22 años y 1.60m
persona(nina, jove, 22, 1.60).
% Marcos es un niño de 8 años y 1.32m.
persona(marcos, ninio, 8, 1.32).
%Osvaldo es un adolescente de 13 años y 1.29m.
persona(osvaldo, adolescente, 13, 1.29).

% PARQUE DE LA COSTA
% Tren Fantasma: Exige que la persona sea mayor o igual a 12 años.
trenFantasma(Persona):-
    persona(Persona, _, Edad, _),
    Edad >= 12.
% Montaña Rusa: Exige que la persona tenga más de 1.30 de altura.
montañaRusa(Persona):-
    persona(Persona, _, _, Altura),
    Altura > 1.30.

% PARQUE ACUATICO
% Tobogán Gigante "La Ola Azul": Altura de 22 metros para una bajada emocionante que 
% termina en una piscina de olas. Altura mínima 1.50m.
toboganGigante(Persona):-
    persona(Persona, _, _, Altura),
    Altura >= 1.50.
% Río Lento "Corriente Serpenteante": Paseo tranquilo en flotadores a través de un 
% paisaje con cascadas y grutas. Sin requisitos.

% Piscina de Olas "Maremoto": Simula olas del mar con zonas para diferentes niveles 
% de habilidad. Mínimo 5 años
piscinaOlas(Persona):-
    persona(Persona, _, Edad, _),
    Edad >= 5.
% 1)puedeSubir/2, relaciona una persona con una atracción, si la persona puede subir
% a la atracción.
puedeSubir(Persona, trenFantasma):-
    trenFantasma(Persona).
puedeSubir(Persona, montañaRusa):-
    montañaRusa(Persona).
puedeSubir(Persona, maquinaTiquetera).
puedeSubir(Persona, toboganGigante):-
    toboganGigante(Persona).
puedeSubir(Persona, rioLento).
puedeSubir(Persona, piscinaOlas):-
    piscinaOlas(Persona).

% 2) esParaElle/2, relaciona un parque con una persona, si la persona puede subir a todos
% los juegos del parque.
atraccion(trenFantasma, parqueDeLaCosta).
atraccion(montañaRusa, parqueDeLaCosta).
atraccion(maquinaTiquetera, parqueDeLaCosta).
atraccion(toboganGigante, parqueAcuatico).
atraccion(rioLento, parqueAcuatico).
atraccion(piscinaOlas, parqueAcuatico).

esParaElle(Persona, Parque):-
    persona(Persona, _, _, _),
    atraccion(_, Parque),
    forall(atraccion(Atraccion, Parque), puedeSubir(Persona, Atraccion)).

% 3) malaIdea/2, relaciona un grupo etario (adolescente/niño/joven/adulto/etc) con un
% parque, y nos dice que "es mala idea" que las personas de ese grupo vayan juntas a 
% ese parque, si es que no hay ningún juego al que puedan subir todos.
malaIdea(GrupoEtario, Parque):-
    persona(_, GrupoEtario, _, _),
    atraccion(Atraccion, Parque),
    not((forall(persona(Persona, GrupoEtario, _, _), puedeSubir(Persona, Atraccion)))).

% programaLogico/1, me dice si un programa es "bueno", es decir, todos los juegos están
% en el mismo parque y no hay juegos repetidos.
programaLogico(Programa):-
    forall(member(Juego, Programa), (atraccion(Juego, Parque)))