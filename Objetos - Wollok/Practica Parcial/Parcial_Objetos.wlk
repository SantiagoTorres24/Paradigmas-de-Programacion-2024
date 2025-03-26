class Jugador {
    var vida
    var property skinActual // uso property para q pueda cambiarse la skin y las considero como strings
    const items
    var arma
    var personalidad
    const vidaLimite = 50
    var zonaActual = 0.randomUpTo(10) // considero 10 zonas

    method arma() = arma
    method vida() = vida

    method cambiarPersonalidad(nuevaPersonalidad) { personalidad = nuevaPersonalidad } // uso la personalidad como un atributo para poder modificarla facilmente

    method aumentarVida(cura) { vida = 100.min(vida + cura)} // para no pasarme de 100
    method disminuirVida(danio) { vida = 0.max(vida - danio)} // para que no quede vida negativa

    method usarPotenciador(unArma) {
        if( unArma == arma){
            arma.potenciar(self, arma) 
        } else {
            self.cambiarArma(unArma)
            unArma.potenciar(self, arma)
        }
    }

    method cambiarArma(nuevaArma) { arma = nuevaArma}

    method danioAtaque() = personalidad.danioPersonalidad(self)

    method consumirItem(){
        if(vida < vidaLimite && self.tieneItemVida()){

            const item = self.itemsVida().anyOne()

            item.potenciar(self, arma) // si tiene menos de 50 consume un item de vida
        } else if(vida >= vidaLimite && self.tieneItemDanio()){ // si tiene mas de 50 consume item que no es de vida
            const item = self.itemsDanio().anyOne() 

            item.potenciar(self,arma)
        } else {
            const item = self.itemsDanio().anyOne() 

            item.potenciar(self, arma) // si tiene menos de 50 de vida y no tiene item de vida
        }
    }

    method tieneItemVida() = !self.itemsVida().isEmpty()
    method tieneItemDanio() = !self.itemsDanio().isEmpty()

    method itemsVida() = items.filter{item => item.esItemDevida()}
    method itemsDanio() = items.filter{ item => !item.esItemDeVida()}

    method quitarItem(item) { items.remove(item)}
    method agregarItem(item) { items.add(item)}

    method atacar(rival){ 
        self.danioAtaque() // potencia el arma con el daño de ataque del jugadores
        arma.atacarJugador(rival)}

    method noTieneVida() = vida == 0

    method avanzarZona() = personalidad.avanzar(self)

    method aumentarZona(avance) { zonaActual = 10.min(zonaActual + avance)}

    method pierde() { zonaActual.eliminarJugador(self)}

    method tieneSkinDelDiego() = skinActual == "Maradona"
    
}

const alfonso = new Jugador(vida = 100, personalidad = estandar, arma = escopeta, items = [], skinActual = "SpiderMan")
const brisa = new Jugador(vida = 100, personalidad = camper, arma = rifle, items = [mini, mini, botiquin], skinActual = "Lara Croft")
const changuito = new Jugador(vida = 100, personalidad = ninioRata, arma = cuchillo, items = [granada, granada, granada], skinActual = "Maradona")
const deLaCruyff = new Jugador(vida = 100, personalidad = arriesgado, arma = pistolaBalasDeFuego, items = [botiquin], skinActual = "Rubius")

class Personalidad{
    method danioPersonalidad(jugador)

    method avanzar(jugador){ jugador.aumentarZona(1)}

    method zonaCerro(jugador){
        if(!jugador.zonaActual().estaAbierta()){
            jugador.pierde()
        }
    }
}



class Estandar inherits Personalidad {
    override method danioPersonalidad(jugador) = jugador.arma().danio()
}

const estandar = new Estandar()

class Arriesgado inherits Personalidad {
    const porcentajeAmenaza = 0.25
    const vidaAmenaza = 50
    const porcentajeCritico = 1
    const vidaCritica = 10

    override method danioPersonalidad(jugador) {
        if(jugador.vida().between(vidaCritica, vidaAmenaza)){
            const danio = jugador.arma().danio() * porcentajeAmenaza

            jugador.arma().aumentarDanio(danio)
        } else if(jugador.vida() < vidaCritica) {
            const danio = jugador.arma().danio() * porcentajeCritico // no es necesario pero por si en un futuro llega a cambiar el porcentaje de vida critica

            jugador.arma().aumentarDanio(danio)
        }
    }

    override method avanzar(jugador) { jugador.aumentarZona(2)}
}

const arriesgado = new Arriesgado()
class Camper inherits Estandar {
    override method avanzar(jugador) { }

}

const camper = new Camper()

class NinioRata inherits Personalidad {
    const porcentajeDanio = 0.2

    override method danioPersonalidad(jugador){
        const danio = jugador.arma().danio() * porcentajeDanio

        jugador.arma().disminuirDanio(danio)
    }
}

const ninioRata = new NinioRata()

class Arma {
    var poderBase
    const potenciador

    method danio() = poderBase
    method potenciador() = potenciador

    method aumentarDanio(danio) { poderBase += danio }
    method disminuirDanio(danio) { poderBase = 0.max(poderBase - danio)}

    method potenciar(jugador) { potenciador.potenciar(jugador, self)}

    method atacarJugador(jugador){
        const danioAtaque = self.danio()

        jugador.disminuirVida(danioAtaque)
    }

}

class Pistola inherits Arma(poderBase = 5) {

}

const pistolaBalasDeFuego = new Pistola(potenciador = balasDeFuego)

class Escopeta inherits Arma(poderBase = 20) {

}

const escopeta = new Escopeta(potenciador = "")

class Rifle inherits Arma(poderBase = 22) {

}

const rifle = new Rifle(potenciador = "")

class Cuchillo inherits Arma(poderBase = 10) {
    override method potenciar(jugador) { }
}

const cuchillo = new Cuchillo(potenciador = "")

class Item {
    method potenciar(jugador, arma)

    method esItemDeVida() = false
}

class Botiquin inherits Item {
    const cura = 100

    override method potenciar(jugador, arma) { 
        jugador.aumentarVida(cura)
        jugador.quitarItem(self)
    }

    override method esItemDeVida() = true
}

const botiquin = new Botiquin()

class BalasDeFuego inherits Item {
    const danio = 5

    override method potenciar(jugador, arma) { 
        arma.aumentarDanio(danio)
        jugador.quitarItem(self)
    }
}

const balasDeFuego = new BalasDeFuego()

class Silenciador inherits BalasDeFuego(danio = 3) {

}

const silenciador = new Silenciador()

class Granada inherits BalasDeFuego(danio = 30) { // para quitarle vida a un enemigo simplemente es restarle a su vida el daño de su arma, entonces simplemente aumento el danio del arma

}

const granada = new Granada()

class Mini inherits Botiquin(cura = 30) {

}

const mini = new Mini()

class Partida {
    const mapa

    method jugarTurno(){
        mapa.forEach{ zona => zona.enfrentarJugadores()}
    }

    method cerrar(){
        const zonasAbiertas = mapa.filter{ zona => zona.estaAbierta()}

        zonasAbiertas.first().enfrentarJugadores()
    }

    method manoDeDios() {
        mapa.forEach{ zona => zona.manosDeDios()}
    }

    method recienArranca() = mapa.all{ zona => !zona.estaAbierta()} // si todas las zonas estan cerradas, la partida recien arranca

    method hayGanador() = self.jugadoresVivos().size() == 1

    method jugadoresVivos() = mapa.map{ zona => zona.jugadores()} // obtengo de la lista de zonas los jugadores vivos de cada zona

    method seBuggeo() = self.jugadoresVivos().isEmpty()
}

class Zona {
    const jugadores 
    var estaAbierta
    const indiceZona // divido las zonas del mapa en indices

    method estaAbierta() = estaAbierta
    method cerrarZona() { estaAbierta = false}
    method abrirZona() { estaAbierta = true}

    method pares(lista) {
        const listaMezclada = lista.randomized()
        console.println(listaMezclada)
        const resultado = []
        (0..listaMezclada.size().div(2) - 1).forEach{ i =>
            const indice = i * 2
            resultado.add([listaMezclada.get(indice), listaMezclada.get(indice+1)])
        }
        return resultado
    }

    method enfrentarJugadores(){
        const enfrentamientos = self.pares(jugadores)

        enfrentamientos.forEach{ enfrentamiento => 
            const jugador = enfrentamiento.first()
            const otroJugador = enfrentamiento.last() // tengo la lista de pares, cada elemento de esa lista es otra lista con dos indices, uno por jugador

            jugador.consumirItem()
            otroJugador.consumirItem()

            jugador.atacar(otroJugador)
            otroJugador.atacar(jugador)

            self.evaluarEnfrentamiento(jugador, otroJugador)
            }
    }


    method evaluarEnfrentamiento(jugador, otroJugador){
        if(jugador.noTieneVida()){
            self.eliminarJugador(jugador)
        } else if(otroJugador.noTieneVida()){
            self.eliminarJugador(otroJugador)
        } else {
            jugador.avanzarZona(indiceZona)
            otroJugador.avanzarZona(indiceZona)
        }
    }

    method eliminarJugador(jugador){ jugadores.remove(jugador)}

    method manoDeDios() {
        jugadores.forEach{ jugador => if(jugador.tieneSkinDelDiego()){
            jugador.agregarItem(botiquin)
        }}
    }
}