class Raton {
    var dinero
    const inversionesRealizadas
    const inversionesDeseadas

    method costoInversionesPendientes() = inversionesDeseadas.sum{ inversion => inversion.valorInversion()}
    method costoInversionesRealizadas() = inversionesRealizadas.sum{ inversion => inversion.valorInversion()}

    method realizarInversion(){
        const inversion = inversionesDeseadas.anyOne()

        if(self.puedeRealizarInversion(inversion)){
            self.agregarInversion(inversion)
            self.eliminarInversion(inversion)
            self.disminuirDinero(inversion.valorInversion())
        } else {
            throw new DomainException(message = "No tiene el dinero suficiente")
        }
    }

    method puedeRealizarInversion(inversion) = inversion.valorInversion() < dinero

    method agregarInversion(inversion){ inversionesRealizas.add(inversion)}
    method eliminarInversion(inversion){ inversionesDeseadas.remove(inversion)}

    method disminuirDinero(valor){ dinero = 0.max(dinero - valor)}

    method realizarInversionesPendientes() = inversionesDeseadas.forEach{ inversion => self.realizarInversion(inversion)}

    method esAmbicioso() = self.costoInversionesPendientes() >= dinero * 2

    method todosSusPersonajes() = inversionesRealizadas.forEach{ inversion => inversion.personajesInvolucrados()}

    method peorPersonaje() = self.todosSusPersonajes().min{ personaje => personaje.sueldo()}
}

const mickey = new Raton (dinero = 10000, inversionesRealizadas = [], inversionesDeseadas = [])
const cerebro = new Raton (dinero = 10000, inversionesRealizadas = [], inversionesDeseadas = [])
const jerry = new Raton (dinero = 10000, inversionesRealizadas = [], inversionesDeseadas = [])
const perez = new Raton (dinero = 10000, inversionesRealizadas = [], inversionesDeseadas = [])
const daly = new Raton (dinero = 10000, inversionesRealizadas = [], inversionesDeseadas = [])

class ComprarCompania {
    const peliculasRealizadas
    var porcentaje

    method porcentaje() = porcentaje
    method cambiarPorcentaje(nuevoPorcentaje) { porcentaje = nuevoPorcentaje}

    method recaudacionTotal() = peliculasRealizadas.sum{ pelicula => pelicula.recaudacion()}

    method valorInversion() = self.recaudacionTotal() * porcentaje

    method personajesInvolucrados() = peliculasRealizadas.forEach{ pelicula => pelicula.personajesInvolucrados()}
}

class Pelicula {
    const recaudacion

    method recaudacion() = recaudacion
}

class ContruirParque {
    const atracciones 
    const metrosCuadrados
    var precioPorMetroCuadrado

    method cambiarPrecioMetroCuadrado(nuevoPrecio){ precioPorMetroCuadrado = nuevoPrecio}

    method costoAtracciones() = atracciones.sum{ atraccion => atraccion.costo()}
    method costoMetros() = metrosCuadrados * precioPorMetroCuadrado

    method valorInversion() = self.costoAtracciones() + self.costoMetros()

    method personajesInvolucrados() { }
}

class Atraccion {
    const costo

    method costo() = costo
}

class ProducirPelicula {
    const costoProduccion
    const personajes

    method sueldoPersonajes(personajesPelicula) = personajesPelicula.sum{ personaje => personaje.sueldo()}

    method valorInversion() = self.sueldoPersonajes() + costoProduccion

    method personajesInvolucrados() = personajes.asSet()
}

class PeliculaIndependiente inherits ProducirPelicula {

    override method sueldoPersonajes(){
        const nuevosPersonajes = personajes.take(4)

        return super(nuevosPersonajes)
    }
}

class Personaje {
    var sueldo

    method sueldo() = sueldo

    method duplicarSueldo() { sueldo = sueldo * 2}
}

object flautista {
    const ratones = [mickey, jerry, daly, perez, cerebro]

    method esMasQue(raton, otroRaton) = raton.costoInversionesRealizadas() <= otroRaton.costoInversionesRealizadas()

    method tocarFlauta() = ratones.forEach{ raton => 
    if(raton.esAmbicioso()){
        raton.realizarInversionesPendientes()
    }}

    method duplicarPagoPeorPersonaje(raton){
        const peorPersonaje = raton.peorPersonaje()

        peorPersonaje.duplicarSueldo()
    }
}