class Baculo {
  const poderBaculo
  method poderArma() = poderBaculo 
}

class Espada { // armo una clase para las espadas e instancio cada una
  const valorOrigen 
  var  multiplicador

  method cambiarMultiplicador(nuevoMultiplicador) { multiplicador = 1.max(20.min(nuevoMultiplicador))} 

  method poderArma() = valorOrigen * multiplicador
}

class Daga inherits Espada {
  override method poderArma() = super() / 2
}

class Arco {
  var tension = 40 
  const largo

  method cambiarTension(nuevaTension) { tension = 0.max(nuevaTension)}

  method poderArma() = tension * largo / 10
}

class Hacha{
  const largoMango 
  const pesoHoja

  method poderArma() = largoMango * pesoHoja 
}