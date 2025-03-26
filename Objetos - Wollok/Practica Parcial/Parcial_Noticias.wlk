class Noticia {
    const fecha
    const publicador
    const importancia
    const titulo
    const desarrollo
    
    method titulo() = titulo
    method desarrollo() = desarrollo

    method esCopada() = self.esImportante() && self.esReciente() && self.requisitosPorEstilo()
    
    method esImportante() = importancia >= 8
    method esReciente() {
        const hoy = new Date() 
        const haceTresDias = hoy.minusDays(3) 
        
        return fecha > haceTresDias 
    }

    method requisitosPorEstilo()

    method esChivo() = false

    method estaBienEscrita() = titulo.size() >= 2 && !desarrollo.isEmpty()

    method esReciente(){
        const hoy = new Date()

        return hoy - fecha <= 7
    }
}

class Comun inherits Noticia {
    const linksOtrasNoticias

    override method requisitosPorEstilo() = linksOtrasNoticias.size() >= 2
}

class Chivo inherits Noticia {
    const pago // lo considero en millones

    override method requisitosPorEstilo() = pago >= 2

    override method esChivo() = true
}

class Reportaje inherits Noticia {
    const entrevistado

    override method requisitosPorEstilo() = entrevistado.size().odd()
}

class Cobertura inherits Noticia {
    const noticias

    override method requisitosPorEstilo() = noticias.all{ noticia => noticia.esCopada()}
}

class Periodista {
    const fechaIngreso
    const noticiasPublicadas
    var noticiasQueNoPrefiere = 0

    method publicaSi(noticia)

    method publicar(noticia) {
        const hoy = new Date()

        if(self.publicaSi(noticia) && noticia.estaBienEscrita()){
            self.agregarNoticia(noticia)
        } else if(noticiasQueNoPrefiere <= 1 && noticia.estaBienEscrita()){
            self.agregarNoticia(noticia)
            noticiasQueNoPrefiere += 1

        if(noticia.fecha() != hoy){
            noticiasQueNoPrefiere = 0
        }
        } else {
            throw new DomainException(message = "Ya alcanzo el limite de noticias que no prefiere por dia o la noticia esta mal escrita")
        }
    }

    method agregarNoticia(noticia){ noticiasPublicadas.add(noticia)}

    method esReciente() = self.ingresoReciente() && self.publicacionReciente()

    method ingresoReciente(){
        const hoy = new Date()

        return hoy - fechaIngreso <= 365
    }

    method publicacionReciente() = noticiasPublicadas.any{ noticia => noticia.esReciente()}
}

class Copado inherits Periodista {

    override method publicaSi(noticia) = noticia.esCopada()
}

class Sensacionalista inherits Periodista {
    const palabrasClave = ["espectacular", "increible", "grandioso"]

    override method publicaSi(noticia) = palabrasClave.contains(noticia.titulo())
}

class Reportero inherits Periodista {
    const reportado = "Dibu Martinez"

    override method publicaSi(noticia) = noticia.entrevistado() == reportado
}

class Vago inherits Periodista {

    override method publicaSi(noticia) = noticia.esChivo() || noticia.desarrollo().size() < 100
}

object joseDeZer inherits Periodista (fechaIngreso = "fecha", noticiasPublicadas = []) {
    const letraDePreferencia = "T"

    override method publicaSi(noticia) = noticia.titulo().substring(0,1) == letraDePreferencia
}

