class Jugador {
    const nombre
    var posicion
    var golesFavor
    var golesContra
    var asistencias
    var partidosJugados
    const partidosNecesarios
    const amarillas
    const rojas
    var jugoEnSeleccion
    const altura

    method altura() = altura

    method jugoEnSeleccion() = jugoEnSeleccion
    method jugoParaLaSeleccion(){ jugoEnSeleccion = true}

    method jugoPartido(){ partidosJugados += 1}

    method nombre() = nombre
    method rojas() = rojas
    method amarillas() = amarillas

    method cambiarPosicion(nuevaPosicion){
        posicion = nuevaPosicion
        golesFavor = 0
        golesContra = 0
        asistencias = 0
        partidosJugados = 0
    }

    method esEstrella() = partidosJugados >= partidosNecesarios
    method habilidad()
}

class Arquero inherits Jugador {
    const promedioMax = 0.8
    const alturaMin = 190 // considero cms

    method promedioGolesRecibidos() = golesFavor / partidosJugados // para un arquero considero el atributo de goles como los goles que recibe

    override method esEstrella() = (super() && self.promedioGolesRecibidos() < promedioMax) || altura >= alturaMin

    override method habilidad() = 0.max(partidosJugados * 2 + golesFavor * 500 - golesContra)
}

class Defensor inherits Jugador {
    const promedioAmarillasMax = 0.5
    const rojasMin = 5

    method promedioAmarillas() = amarillas / partidosJugados

    override method esEstrella() = self.promedioAmarillas() < promedioAmarillasMax && rojas >= rojasMin

    override method habilidad() = 0.max(partidosJugados * 3 + golesFavor * 5 - amarillas - rojas * 10)
}

class MedioCampista inherits Jugador {
    const golesMin
    const asistenciasMin
    const puntosDeSeleccion = 100
    
    override method esEstrella() = (golesFavor >= golesMin && asistencias >= asistenciasMin && self.jugoEnSeleccion()) ||
                                    self.nombreTerminaEnInho()

    method nombreTerminaEnInho() = nombre.endsWith("inho")

    override method habilidad() = partidosJugados + golesFavor * 2 + asistencias * 3 + self.puntosSeleccion()

    method puntosSeleccion() {
        if(self.jugoEnSeleccion()) return puntosDeSeleccion else return 0
    }
}

class Delantero inherits Jugador {
    const habilidad = 1500

    override method esEstrella() = true
    override method habilidad() = habilidad
}

class Equipo {
    var jugadores
    const maxJugadores = 11
    var estrellas
    const maxEstrellas
    var puntaje
    var partidosJugados
    var partidosGanados
    var partidosEmpatados
    var partidosPerdidos

    method sumarPuntos(puntos){ puntaje += puntos}

    method estrellas() = estrellas
    method jugadores() = jugadores

    method admitirJugador(jugador){
        if(jugadores.size() < maxJugadores){
            if(jugador.esEstrella() && estrellas < maxEstrellas){ // si hay lugar para jugadores y estrellas
                self.agregarJugador(jugador)
                jugadores += 1
                estrellas += 1
            } else{ // si hay lugar para jugadores pero no para estrellas
                self.agregarJugador(jugador)
                jugadores += 1
            }
            } else{ // el caso en el que no haya lugar
                throw new DomainException(message = "No se puede agregar al jugador.")
            }
        }

    method agregarJugador(jugador){ jugadores.add(jugador)}

    method tienenJugadores() = jugadores.size() == maxJugadores

    method jugoPartido() {
        jugadores.forEach{ jugador => jugador.jugoPartido()
                                      jugador.jugoParaLaSeleccion()}

        partidosJugados += 1
    }

    method ganoPartido(){ partidosGanados += 1}
    method perdioPartido(){ partidosPerdidos += 1}
    method empatoPartido(){ partidosEmpatados += 1}

    method tieneMenosDeDosEstrellas() = estrellas < 2

    method tieneAMessi() = jugadores.any{ jugador => jugador.nombre().contains("Messi")}
    }


class EquipoPro inherits Equipo (maxEstrellas = 9) { 
    method cumpleLoEsperado() {
        if(self.tieneAMessi()){
            return puntaje >= 18
        } else{
            return puntaje >= 12
        }
    }
}
class EquipoMedioPelo inherits Equipo (maxEstrellas = 3) {
    method cumpleLoEsperado() = puntaje == estrellas
 }
class Brasil inherits Equipo (maxEstrellas = 11) {
    method cumpleLoEsperado() = puntaje == 21
 } // teniendo en cuenta que hay hasta 11 jugadores

class Partido {
    const equipoLocal
    const equipoVisitante
    const puntosPorLocal = 1
    const puntosExtra = 5

    method puntosPorEstrella(equipo, otroEquipo) {
        const puntos = equipo.estrellas()
        const otrosPuntos = otroEquipo.estrellas()

        equipo.sumarPuntos(puntos)
        otroEquipo.sumarPuntos(otrosPuntos)
    }

    method puntosPorLocalia(){ equipoLocal.sumarPuntos(puntosPorLocal)}

    method habilidadTotal(equipo) = equipo.jugadores().sum{ jugador => jugador.habilidad()}

    method puntosAlMejor(equipo, otroEquipo) {
        if(equipo.habilidadTotal() > otroEquipo.habilidadTotal()){
            equipo.sumarPuntos(puntosExtra)
        } else if(equipo.habilidadTotal() < otroEquipo.habilidadTotal()){
            otroEquipo.sumarPuntos(puntosExtra)
        } else{
            throw new DomainException(message = "Tiene los mismos puntos de habilidad")
        }
    }

    method jugarPartido() {
        if(equipoLocal.tienenJugadores() && equipoVisitante.tienenJugadores()){
            self.puntosPorEstrella(equipoLocal, equipoVisitante)
            self.puntosPorLocalia()
            self.puntosAlMejor(equipoLocal, equipoVisitante)

            equipoLocal.jugoPartido()
            equipoVisitante.jugoPartido()

            if(equipoLocal.puntaje() > equipoVisitante.puntaje()){
                equipoLocal.ganoPartido()
                equipoVisitante.perdioPartido()
            } else if(equipoLocal.puntaje() < equipoVisitante.puntaje()){
                equipoVisitante.ganoPartido()
                equipoLocal.perdioPartido()
            } else { 
                equipoLocal.empatoPartido()
                equipoVisitante.empatoPartido()
            }
        } else{
            throw new DomainException(message = "Uno de los equipo no tiene 11 jugadores")
        }
    }
}

class Mundial {
    const equipos 

    method huboBatacazo() {
        const equiposConMenosDeDosEstrellas = equipos.filter{ equipo => equipo.tieneMenosDeDosEstrellas()}

        return equiposConMenosDeDosEstrellas.any{ equipo => equipo.puntaje() >= 1}
    }

    method estamosBien() = equipos.all{equipo => equipo.cumpleLoEsperado()}
}