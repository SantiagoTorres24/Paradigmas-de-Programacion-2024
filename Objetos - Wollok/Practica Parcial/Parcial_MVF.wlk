class Villano {
    const minions 
    const ciudad

    method minions() = minions

    method ciudad() = ciudad

    method nuevoMinion(){
        const nuevoMinion = new MinionAmarillo(bananas = 5, armas = [rayoCongelante])

        minions.add(nuevoMinion)
    }

    method realizarMaldad(maldad) {
        maldad.consecuenciasMaldad()
    }

    method minionMasUtil() = minions.max{ minion => minion.cantidadMaldades()}

    method minionsInutiles() = minions.filter{ minion => minion.noHizoMaldad()}
}

class Minion {
    var bananas
    const armas
    var maldades

    method esPeligroso()
    method esAmarillo()
    method nivelConcentracion() 

    method beberSuero(){
        if(self.esAmarillo()){
            return new MinionVioleta(bananas = bananas - 1, armas = [])
        } else {
            return new MinionAmarillo(bananas = bananas - 1, armas = armas)
        }
    }

    method alimentar(cantidadBananas) { bananas += cantidadBananas}
    method estaBienAlimentado(cantidadBananas) = bananas >= cantidadBananas
    
    method otorgarArma(arma){ armas.add(arma)}
    method armaMasPotente() = armas.max{ arma => arma.potencia()}

    method tieneArma(arma) = armas.contains(arma)

    method superaConcentracion(concentracion) = self.nivelConcentracion() >= concentracion

    method cantidadMaldades() = maldades
    method hizoMaldad() { maldades += 1}

    method noHizoMaldad() = maldades == 0
}

class MinionAmarillo inherits Minion {

    override method esPeligroso() = armas.size() >= 2

    override method esAmarillo() = true

    override method nivelConcentracion() = self.armaMasPotente().potencia() + bananas
}

class MinionVioleta inherits Minion {

    override method esPeligroso() = true

    override method esAmarillo() = false

    override method nivelConcentracion() = bananas
}

class Arma {
    const nombre
    const potencia

    method potencia() = potencia
}

const rayoCongelante = new Arma(nombre = "Rayo Congelante", potencia = 10)
const rayoEncogedor = new Arma(nombre = "Rayo Encogedor", potencia = 10)

class Maldad {
    const villano
    const minionsCapaces = self.estanCapacitados()

    method estanCapacitados()
    method consecuenciasMaldad() {
        if(minionsCapaces.isEmpty()){
            throw new DomainException(message = "No hay minions capaces para esta maldad")
        } 
    }
}

class Congelar inherits Maldad {
    var nivelConcentracion = 500
    const temperatura = 30
    const bananas = 10

    method cambiarNivelConcetracion(nuevoValor){ nivelConcentracion = nuevoValor}

    override method estanCapacitados() = villano.minions().filter{ minion => minion.tieneArma(rayoCongelante) && minion.superaConcentracion(nivelConcentracion)}

    override method consecuenciasMaldad() {
        super()

        villano.ciudad().bajarTemperatura(temperatura)
        minionsCapaces.forEach{ minion => minion.alimentar(bananas) && minion.hizoMaldad()}
    }
}

class Robar inherits Maldad {
    const objetivo

    override method estanCapacitados() = villano.minions().filter{ minion => minion.esPeligroso() && 
                                        minion.superaConcentracion(objetivo.concentracion()) && objetivo.requisitos(minion)}

    override method consecuenciasMaldad(){
        super()

        villano.ciudad().perderElemento(objetivo)
        minionsCapaces.forEach{ minion => objetivo.premio(minion) && minion.hizoMaldad()}
    }
}

class Ciudad {
    const nombre
    var temperatura

    method bajarTemperatura(valor){ temperatura -= valor} // puede ser negativa
}

class Objetivo {
    const concentracion

    method concentacion() = concentracion
    method requisitos(minion) 
    method premio(minion)
}

class Piramide inherits Objetivo (concentracion = altura / 2) {
    const altura
    const bananas = 10

    override method requisitos(minion) = true
    override method premio(minion){ minion.alimentar(bananas)}
}

class SueroMutante inherits Objetivo (concentracion = 23){
    const bananasMin = 1000

    override method requisitos(minion) = minion.estaBienAlimentado(bananasMin) 
    override method premio(minion){ minion.beberSuero()}

}

class Luna inherits Objetivo (concentracion = 0){  // para representar que cualquier nivel de concentracion es suficiente 

    override method requisitos(minion) = minion.tieneArma(rayoEncogedor)
    override method premio(minion){ otorgarArma(rayoCongelante)}
}