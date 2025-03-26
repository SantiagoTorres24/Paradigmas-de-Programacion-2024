class Ninio {
    const elementos
    const actitud
    var caramelos

    method caramelos() = caramelos
    method sumarCaramelos(cantidad){ caramelos += cantidad}
    method comerCaramelos(cantidad){
        if(caramelos > 0){
            caramelos = 0.max(caramelos - cantidad)
        } else{
            throw new DomainException(message = "No tiene caramelos para comer")
        }
    }

    method capactidadDeAsustar() = elementos.sum{ elemento => elemento.asusta()} * actitud

    method asustar(adulto){
        if(adulto.puedeSerAsustado(self)){
            adulto.darCaramelos(self)
        } else{
            throw new DomainException(message = "El niño no pudo asustar al adulto")
        }
    }
}

class Maquillaje {
    var susto = 3

    method asusta() = susto
    method cambiarSusto(nuevoSusto){ susto = nuevoSusto}
}

class TrajeTierno {
    const susto = 2

    method asusta() = susto
}

class TrajeTerrorifico {
    const susto = 5

    method asusta() = susto
}

class AdultoComun {
    const niniosQueLoAsustaronAntes

    method puedeSerAsustado(ninio) = self.tolerancia() >= ninio.capactidadDeAsustar()

    method tolerancia() {
        const ninios = niniosQueLoAsustaronAntes.filter{ ninio => ninio.caramelos() >= 15}

        return ninios.size() * 10
    }

    method darCaramelos(ninio) = ninio.sumarCaramelos(self.tolerancia() / 2)
}

class AdultoAbuelo inherits AdultoComun{

    override method puedeSerAsustado(ninio) = true

    override method darCaramelos(ninio) = ninio.sumarCaramelos(self.tolerancia() / 2)
}

class AdultoNecio {

    method puedeSerAsustadio(ninio) = false

    method darCaramelos(ninio) { }
}

class Legion {
    var miembros

    method capacidadDeAsustar() = miembros.sum{ miembro => miembro.capacidadDeAsustar()}

    method caramelosTotales() = miembros.sum{ miembro => miembro.caramelos()}

    method asustar(adulto){
        if(self.puedenAsustar(adulto)){
            const lider = miembros.max{ miembro => miembro.capacidadDeAsustar()}
            adulto.darCaramelos(lider)
        }
    }

    method puedenAsustar(adulto) = miembros.any{ miembro => adulto.puedeSerAsustado(miembro)}

    method constructor(ninios){
        if(ninios.size() >= 2){
            throw new DomainException(message = "Tienen que ser por lo menos 2 niños para crear la Legión")
        } else{
            miembros = ninios
        }
    }
}

class Barrio {
    const ninios 

    method tresConMasCaramelos() {
        const niniosConMasCaramelos = ninios.sortBy{ ninio => ninio.caramelos()}

        const tresConMasCaramelos = niniosConMasCaramelos.take(3)

        return tresConMasCaramelos
    } 

    method elementos(){
        const elementosDeNinios = ninios.filter{ ninio =>  if(ninio.caramelos() >= 10){ ninio.elementos()}}

        const elementos = elementosDeNinios.asSet()

        return elementos
    }
}