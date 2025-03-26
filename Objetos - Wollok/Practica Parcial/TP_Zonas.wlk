import TP_Guerreros.*

class Zona {
    const requerimiento
    const consecuencias 

    method permitePasar(grupo) = requerimiento.cumpleRequerimiento(grupo)
    method recorreZona(grupo) = consecuencias.consecuenciasRecorrer(grupo)
} 

class ConsecuenciaNula {
    method consecuenciasRecorrer(grupo) { }
}

class ConsecuenciaModificarVida {
    const condicion

    method consecuenciasRecorrer(grupo) { grupo.forEach(condicion)}
}

class RequerimientoVacio {
    method cumpleRequerimiento(grupo) = true
}

class RequerimientoItem {
    const item
    const cantidad

    method cumpleRequerimiento(grupo) = grupo.sum{ guerrero => guerrero.cantidadItem(item)} >= cantidad
}

class RequerimientoGuerrero {
    const condicion

    method cumpleRequerimiento(grupo) = grupo.any(condicion)
}

class Camino{
  var property zonas 

  method puedeRecorrerCamino(grupo) = zonas.all{zona => zona.permitePasar(grupo)}
}
