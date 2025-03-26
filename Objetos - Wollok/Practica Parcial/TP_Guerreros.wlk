import TP_Arsenal.*
import TP_Zonas.*
class Guerrero {
    const armas 
    var vida
    const items

    method armas() = armas
    method poderArmas() = armas.sum{ arma => arma.poderArma()}
    method agregarArma(arma) { armas.add(arma)}
    method quitarArma(arma) { armas.remove(arma)} 
    method tieneArmas() = !armas.isEmpty()
     
    method vidaActual() = vida
    method disminuirVida(valor) { vida = 0.max(vida - valor)} // vida entre 0 y 100
    method aumentarVida(valor) { vida = 100.min(vida + valor)} 

    method items() = items
    method cantidadItem(elemento) = items.count{ item => item == elemento}
    method agregarItem(item) { items.add(item)}
    method agregarItem10Veces(item) { 10.times { _ => self.agregarItem(item) } }

    method recorrerZona(zona) {
        if (self.puedePasar(zona)) {zona.recorreZona(self)}}  
    method puedePasar(zona) = zona.permitePasar(self) 
    
    method poder() 
}

class Hobbit inherits Guerrero { 
  override method poder() = self.vidaActual() + self.poderArmas() + self.items().size()
}
class Enano inherits Guerrero {
  const factorPoder

  override method poder() = self.vidaActual() + (factorPoder * self.poderArmas())}

class Elfo inherits Guerrero {
  var destrezaBase = 2
  var destrezaPropia

  method destrezaBase() = destrezaBase
  method cambiarDestrezaBase(nuevaDestrezaBase) { destrezaBase = nuevaDestrezaBase}

  method destrezaPropia() = destrezaPropia
  method cambiarDestrezaPropia(nuevaDestrezaPropia) { destrezaPropia = nuevaDestrezaPropia }

  override method poder() = self.vidaActual() + self.poderArmas() * (destrezaBase + destrezaPropia)

}
class Humano inherits Guerrero {
  const limitadorPoder

  override method poder() {
    return self.vidaActual() * self.poderArmas() / limitadorPoder
  }
}


class Maiar inherits Guerrero {
  var poderBasico = 15
  var poderBajoAmenaza = 300 // considero ambos poderes >= 0  
  const vidaAmenaza

  method factorActual() {
    if(self.vidaActual() <= vidaAmenaza) return poderBajoAmenaza else return poderBasico }


  method cambiarPoderBasico(nuevoPoderBasico) { poderBasico = 0.max(nuevoPoderBasico)}
  method cambiarPoderBajoAmenaza(nuevoPoderBajoAmenaza) { poderBajoAmenaza = 0.max(nuevoPoderBajoAmenaza)}

  override method poder() = (self.vidaActual() * self.factorActual()) + (self.poderArmas() * 2)
}
class Gollum inherits Hobbit {
  override method poder(){
    return super() / 2
  }
}


object tomBombadil inherits Guerrero (vida = 100, armas = [], items = []) {

  override method recorrerZona(zona) { }
  override method puedePasar(zona) = true
  override method poder() = 10000000 
}