// Un amigo nuestro nos pidió que generemos una aplicación para ayudarlo en la 
// organización de fiestas de disfraces.

// Todo comienza cuando se celebra una fiesta, que ocurre en un lugar (ej: casa de Tina)
// , una fecha, y hay una serie de invitados. Cada invitado asiste con un disfraz, aunque 
// en cualquier momento puede cambiarlo por otro. Todos los disfraces tienen un nombre: 
// “Media naranja”, “Político de turno”, etc. y sabemos la fecha en la que fue confeccionado.

// Puntuación de un disfraz
// Queremos saber cuántos puntos tiene un disfraz, sabiendo que puede ser una combinación de 
// las siguientes características:
// graciosos: está determinado por el nivel de gracia que tiene el disfraz (va de 1 a 10) y 
// lo multiplican por 3 si el que lo lleva tiene más de 50 años. 
// tobaras: sabemos qué día lo compraron, un disfraz comprado 2 ó más días antes del día de 
// la fiesta vale 5 puntos, o 3 en caso contrario.
// caretas: la careta simula un personaje real, y el valor es el que tiene dicho personaje 
// (por ejemplo, el de Mickey Mouse vale 8, mientras que el de Oso Carolina vale 6),
// sexies: los disfraces sexies valen 15 puntos si la persona es sexy (ver más adelante), 
// o 2 por el intento.

// Como dijimos antes es posible que un disfraz sea sexy, tobara y careta, solo sexy, sexy 
// y tobara, no tener ninguna característica, ser gracioso, etc. (es una combinación).
// Personalidades 

class Fiesta{
    const property asistentes = []

    method esUnBodrio() = asistentes.all({asistente => !asistente.estaConforme()})

    method mejorDisfraz() = asistentes.max({asistente => asistente.disfraz().puntos(asistente)})

    method asistentesCambianDisfraz(asistente1, asistente2){
        const disfrazOriginal = asistente1.disfraz()
        self.validoPresencia(asistente1)
        self.validoPresencia(asistente2)
        self.validoDisconformidad(asistente1, asistente2)
        self.validoConformidadConNuevoTraje(asistente1, asistente2)
        self.validoConformidadConNuevoTraje(asistente2, asistente1)
        asistente1.cambioDisfraz(asistente2.disfraz())
        asistente2.cambioDisfraz(disfrazOriginal)
    }
    
    method estaAsistente(asistente) = asistentes.contains(asistente)

    method algunAsistenteDisconforme(asistente1, asistente2) = !asistente1.estaConforme() || !asistente2.estaConforme()

    method validoConformidadConNuevoTraje(asistente1, asistente2){
        const disfrazOriginal = asistente1.disfraz()
        asistente1.cambioDisfraz(asistente2.disfraz())
        if (!(asistente1.estaConforme())){
            throw new DomainException(message = " "+ asistente1 + " no esta conforme con su nuevo disfraz.")
            asistente1.cambioDisfraz(disfrazOriginal)
        }
    }

    method validoPresencia(asistente) =
        if (!(self.estaAsistente(asistente))) 
            throw new DomainException(message = "El supuesto asistente "+ asistente + " no esta en la fiesta.")

    method validoDisconformidad(asistente1, asistente2) =
        if (!(self.algunAsistenteDisconforme(asistente1, asistente2)))
            throw new DomainException(message = "Ambos asistentes " + asistente1 + " y " + asistente2 + " estan conformes")

    method agregarAsistente(asistente) = 
    if((asistente.disfraz() != null) && (!(self.estaAsistente(asistente))) && self.condicionSecundaria()){
        asistentes.add(asistente)
    }

    method condicionSecundaria()

}

object alegre{
    method esSexy(persona) = false
}

object taciturna{
    method esSexy(persona) = persona.edad() < 30
}

object cambiante{
    const property personalidadesPosibles = [alegre, taciturna]

    method cualquierPersonalidad() = personalidadesPosibles.anyOne() // si no funca, hacer .randomize() y tomar la primer personalidad de la lista resultante

    method esSexy(persona) = self.cualquierPersonalidad().esSexy(persona) 
}

class Invitado{
    var property disfraz
    const property edad
    var property personalidad

    method esMayor() = edad > 50

    method esSexy() = personalidad.esSexy(self)

    method estaConforme() = self.disfrazConSuficientesPuntos() && self.condicionSecundaria()

    method disfrazConSuficientesPuntos() = disfraz.puntos(self) > 10

    method condicionSecundaria()

    method cambioDisfraz(nuevoDisfraz){disfraz = nuevoDisfraz}
}

object gracioso{
    method puntos(disfraz, invitado) = disfraz.nivelGracia() * (if (invitado.esMayor()) 3 else 1)
}

object tobara {
    method puntos(disfraz, invitado) = if (disfraz.comproHaceMucho()) 5 else 3
}

class Personaje{
    const property valor
}

object careta {
    method puntos(disfraz, invitado) = disfraz.personaje().valor()
}

object sexy {
    method puntos(disfraz, invitado) = if (invitado.esSexy()) 15 else 2
}

class Combineta {
    const property tiposDisfraz = []

    method puntos(disfraz, invitado) = tiposDisfraz.sum({tipoDisfraz => tipoDisfraz.puntos(disfraz, invitado)})
}
// const disfraz1 = new Disfraz(nombre = "vestidin", fechaConfeccion = new Date(year = 2020, month = 3, day= 20), fechaCompra = new Date(year = 2020, month = 3, day= 20), nivelGracia = 8, personaje = mickey, tipoDisfraz = tobara) cumple caprichoso, no cumple pretencioso, cumple tobara 5 puntos, cumple careta 8 puntos
// const mickey = new Personaje(valor = 8)
// const juan = new Caprichoso(disfraz = disfraz1, edad = 60, personalidad = alegre)
class Disfraz{
    const property nombre
    const property fechaConfeccion
    const property nivelGracia
    const property fechaCompra
    const property personaje
    const property tipoDisfraz
    const property hoy = new Date()

    method comproHaceMucho() = (hoy - fechaCompra) >= 2

    method puntos(invitado) = tipoDisfraz.puntos(self, invitado)

    method nombreDeLetrasPares() = nombre.even()

    method fabricadoHacePoco() = (hoy - fechaCompra) < 30
}

// Personalidades (simples y múltiples)
// Una persona es sexy dependiendo de su personalidad:
// las personas alegres no son sexies
// las personas taciturnas son sexies si tienen menos de 30 años
// hay personas que tienen personalidad cambiante, a veces son alegres y a veces taciturnas

// Satisfecho o le devolvemos su traje
// Todas las personas suelen estar conformes con un traje mayor a 10 puntos, y...
// ...los caprichosos quieren además que su traje tenga un nombre que tenga una cantidad par de letras
// ...los pretenciosos quieren que el traje esté hecho hace menos de 30 días
// ...los numerólogos quieren que el traje no sólo sea mayor a 10 puntos sino también que el 
// puntaje sea exactamente una cifra que ellos determinan (por ejemplo: 15, pero ese número puede variar).
	
// Según nuestro amigo “las personas no cambian”, así que no le interesa que una persona caprichosa pueda luego ser pretenciosa.

class Caprichoso inherits Invitado{
    override method condicionSecundaria() = disfraz.nombreDeLetrasPares()
}

class Pretencioso inherits Invitado{
    override method condicionSecundaria() = disfraz.fabricadoHacePoco()
}

class Numerologo inherits Invitado{
    var property puntosEsperados

    override method condicionSecundaria() = disfraz.puntos(self) == puntosEsperados
}

// Determinar el puntaje de un disfraz. OK

// Saber si una fiesta es un bodrio, esto ocurre cuando todos los asistentes están disconformes con su disfraz. OK

// Saber cuál es el mejor disfraz de la fiesta (el que más puntos tiene).  OK

// Dada una fiesta y dos asistentes, queremos saber si pueden intercambiar trajes: esto se da si 
// ambos están en la fiesta
// alguno de los dos está disconforme con su traje
// y cambiando el traje los dos pasan a estar conformes OK

// Queremos agregar un asistente a una fiesta. Para eso debe cumplirse:
// el asistente debe tener un disfraz
// el asistente no debe estar ya cargado

// Además queremos definir una “fiesta inolvidable”, una fiesta específica única e irrepetible que considera 
// además que todo asistente:
// debe ser sexy
// y debe estar conforme con su disfraz

object fiestaInolvidable inherits Fiesta{
    override method condicionSecundaria() = asistentes.all({asistente => asistente.esSexy() && asistente.estaConforme()})
}