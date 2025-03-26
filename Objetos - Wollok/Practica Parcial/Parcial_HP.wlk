class Bot {
    var cargaElectrica
    var aceitePuro

    method aceitePuro() = aceitePuro
    method ensuciar(){ aceitePuro = false}

    method disminuirCargaElectrica(valor){ cargaElectrica = 0.max(cargaElectrica - valor)}
    method anularCargaElectrica() { cargaElectrica = 0}
    method estaActivo() = cargaElectrica > 0
    method disminuirCargaALaMitad(){ cargaElectrica = cargaElectrica / 2}

    method esProfesor() = false

    method lleganBotsACasa(bots) = bots.forEach{ bot => bot.seleccionarCasa(sombreroSeleccionador)}
}

class Estudiante inherits Bot {
    var casa
    const hechizos
    const hechizosMin = 3
    const cargaMin = 50

    method hechizos() = hechizos
    method aprenderHechizo(hechizo){
        if(self.sabeHechizo(hechizo)){
            hechizos.add(hechizo)
        }
    }

    method seleccionarCasa(sombreroSeleccionador) { casa = sombreroSeleccionador.asignarCasa()} 

    method sabeHechizo(hechizo) = hechizo.cumpleRequisitos(self)
    method lanzaHechizo(hechizo, otroBot) = hechizo.consecuenciasHechizo(otroBot)
    
    method esExperimentado() = self.sabeHechizosNecesarios() && self.tieneCargaMinima()

    method sabeHechizosNecesarios() = hechizos.size() >= hechizosMin
    method tieneCargaMinima() = cargaElectrica >= cargaMin

    method asistanAMateria(materia, estudiantes){
        estudiantes.forEach{ estudiante => materia.enseniarHechizo(estudiante)}
    }

    method lanzarUltimoHechizo(bot){
        const hechizo = hechizos.last()

        self.lanzaHechizo(hechizo, bot)
    }
    method esEstudiante() = true
}

class Profesor inherits Estudiante{
    const materias
    const materiasMin = 2

    override method esExperimentado() = super() && self.tieneMateriasNecesarias()

    method tieneMateriasNecesarias() = materias.size() >= materiasMin

    method defenderHechizo(hechizo){
        hechizo.consecuencia().realizarHechizo(self)
}

    override method esProfesor() = true

    override method esEstudiante() = false
}

class Materia{
    const profesor
    const hechizoAEnseniar

    method profesor() = profesor
    
    method enseniarHechizo(estudiante) { estudiante.aprenderHechizo(hechizoAEnseniar)}
}

object sombreroSeleccionador {
    const casas = ["Gryffindor", "Slytherin", "Ravenclaw", "Hufflepuff"]
    var indiceCasaActual = 0

    method asignarCasa(bot) {
        const casaAsignada = casas.get(indiceCasaActual)
        indiceCasaActual = (indiceCasaActual + 1) % casas.size()
        return casaAsignada
    }

    method ensuciar(){ }
}

class Casa {
    const integrantes

    method esPeligrosa() = self.cantidadEstudiantesAceiteSucio() > self.cantidadEstudiantesAceitePuro()

    method cantidadEstudiantesAceitePuro() {
        return integrantes.count{integrante => integrante.esEstudiante() && integrante.aceitePuro()}
    }

    method cantidadEstudiantesAceiteSucio() {
        return integrantes.count{integrante => integrante.esEstudiante() && integrante.aceitePuro()}
    }

    method atacarBot(bot){
        integrantes.forEach{ integrante => integrante.esEstudiante() && integrante.lanzarUltimoHechizo(bot)}
    }
    }


class Gryffindor inherits Casa {
    
    override method esPeligrosa() = false
}

class Slytherin inherits Casa {
    
    override method esPeligrosa() = true
}

class Hechizo {
    const consecuencia

    method consecuencia() = consecuencia

    method cumpleRequisitos(bot) = true
    method consecuenciasHechizo(bot){ 
        if(self.esSectumSempra()){
            if(bot.aceitePuro()){
                consecuencia.realizarHechizo(bot)
            }
        }else{
            consecuencia.realizarHechizo(bot)}
}
    method esSectumSempra() = false
}

class DisminuirCarga {
    const valor
    
    method realizarHechizo(bot){ 
        if(!bot.esProfesor()) {
            bot.disminuirCarga(valor)}
    }

}

class AnulaCarga {
    method realizarHechizo(bot){ 
        if(bot.esProfesor()){
            bot.disminuirCargaALaMitad()
        }else{
            bot.anularCargaElectrica()}
    }
}

class Ensucia {
    method realizarHechizo(bot){ bot.ensuciar()}
}

class Inmobulus inherits Hechizo (consecuencia = consecuenciaInmobulus){
}

const consecuenciaInmobulus = new DisminuirCarga(valor = 50)

class SectumSempra inherits Hechizo (consecuencia = consecuenciaSectumSempra){
    override method cumpleRequisitos(bot) = bot.esExperimentado()

    override method esSectumSempra() = true

}

const consecuenciaSectumSempra = new Ensucia()