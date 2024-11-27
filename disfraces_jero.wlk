/* Para probar: 
const fiesta1 = new Fiesta()
const mickey = new Personaje(valor = 8)
const disfraz1 = new Disfraz(nombre = "vestidin", fechaConfeccion = new Date(year = 2020, month = 3, day= 20), fechaDeCompra = new Date(year = 2020, month = 3, day= 20), nivelDeGracia = 8, personaje = mickey, caracteristicaDisfraz = tobara)
const juan = new Caprichoso(disfraz = disfraz1, edad = 60, personalidad = alegre)
*/

class Fiesta {
  const property fechaFiesta = null
  const property invitados = []

  method estaAnotadoEnLaFiesta(invitado) = invitados.contains(invitado)

  method esUnBodrio() = invitados.all({ invitado => !invitado.estaConforme()})

  method mejorDisfrazFiesta() = invitados.max({ invitado => invitado.disfraz().puntos(invitado)})

  method invitadosCambianDisfraz(invitado1, invitado2) {
    self.validarInvitadoEnFiesta(invitado1)
    self.validarInvitadoEnFiesta(invitado2)

    self.validarAlgunaDisconformidad([invitado1, invitado2])

    self.validarConformidad(invitado1, invitado2)
    self.validarConformidad(invitado2, invitado1)

    const disfrazInvitado1 = invitado1.disfraz()
    invitado1.cambioDisfraz(invitado2.disfraz())
    invitado2.cambioDisfraz(disfrazInvitado1)
  }

  method validarInvitadoEnFiesta(invitado) { 
    if (!(self.estaAnotadoEnLaFiesta(invitado)))
        throw new DomainException(message = "El supuesto invitado "+ invitado.toString() + " no esta en la fiesta.")
  }

  method validarAlgunaDisconformidad(setDeInvitados) {
    if (!(setDeInvitados.any({ invitado => !invitado.estaConforme()})))
        throw new DomainException(message = "Ninguno de los invitados en cuestion esta disconforme con su disfraz.")
  }

  method validarConformidad(invitado1, invitado2) {
    const disfrazOriginal = invitado1.disfraz()
        
    invitado1.cambioDisfraz(invitado2.disfraz())

    if (!(invitado1.estaConforme())){
        invitado1.cambioDisfraz(disfrazOriginal)
        throw new DomainException(message = "El invitado " + invitado1.toString() + " no esta conforme con su nuevo disfraz.")
    }
  }

  method agregarInvitado(invitadoNuevo) {
    self.validarDisfrazInvitado(invitadoNuevo)
    self.validarInscripcionALaFiesta(invitadoNuevo)
    self.validacionInscripcionExtra(invitadoNuevo)

    invitados.add(invitadoNuevo)
  }

  method validarDisfrazInvitado(invitadoNuevo) {
    if (invitadoNuevo.disfraz() == null)
        throw new DomainException(message = "No se puede agregar al invitado " + invitadoNuevo.toString() + " a la fiesta dado que no tiene disfraz.")
  }

  method validarInscripcionALaFiesta(invitadoNuevo) {
    if (self.estaAnotadoEnLaFiesta(invitadoNuevo)) {
        throw new DomainException(message = "El invitado "+ invitadoNuevo.toString() + " ya se encontraba agregado a la fiesta.")
    }
  }

  method validacionInscripcionExtra(invitadoNuevo) {}
}

object fiestaInolvidable inherits Fiesta {
  override method validacionInscripcionExtra(invitadoNuevo) {
    self.validarSiEsSexy(invitadoNuevo)
    self.validarSiEstaConforme(invitadoNuevo)
  }

  method validarSiEsSexy(invitado) {
    if (!(invitado.esSexy())) {
        throw new DomainException(message = "El invitado "+ invitado.toString() + " no se puede agregar porque no es sexy.")
    }
  }

  method validarSiEstaConforme(invitado) {
    if (!(invitado.estaConforme())) {
        throw new DomainException(message = "El invitado "+ invitado.toString() + " no se puede agregar porque no esta conforme.")
    }
  }
}

class Invitado {
  var property disfraz = null
  var property personalidad
  const property edad

  method esMayorDe(anios) = edad > anios 

  method esSexy() = personalidad.esSexy(self)

  method estaConforme() = self.condicionConformeBase() and self.condicionSecundaria()

  method condicionConformeBase() = disfraz.puntos(self) > 10
  method condicionSecundaria() 

  method cambioDisfraz(nuevoDisfraz) {
    disfraz = nuevoDisfraz
  }
}

class Caprichoso inherits Invitado {
  override method condicionSecundaria() = disfraz.nombrePar()
}

class Pretencioso inherits Invitado {
  override method condicionSecundaria() = disfraz.hechoHaceMenosDe(30)
}

class Numerologo inherits Invitado {
  const property puntajeDeseado
  
  override method condicionSecundaria() = disfraz.puntos(self) == puntajeDeseado
}

object alegre {
  method esSexy(persona) = false
}

object taciturnas {
  method esSexy(persona) = !persona.esMayorDe(29)
}

object cambiante {
  const personalidades = [alegre, taciturnas]

  method personalidadRandom() = personalidades.anyOne()

  method esSexy(persona) = self.personalidadRandom().esSexy(persona)
}

class Disfraz {
  const property nombre
  const property fechaConfeccion
  const property nivelDeGracia
  const property fechaDeCompra
  const property personaje
  const property caracteristicaDisfraz

  method puntos(persona) = caracteristicaDisfraz.puntos(self, persona)

  method compradoHaceMucho() = (new Date() - fechaDeCompra) >= 2

  method getValorPersonaje() = personaje.valor()

  method nombrePar() = nombre.size().even()

  method hechoHaceMenosDe(dias) = (new Date() - fechaDeCompra) < dias
}

class Personaje {
  const property valor
}

object gracioso {
  method puntos(disfraz, persona) = disfraz.nivelDeGracia() * if (persona.esMayorDe(50)) 3 else 1
}

object tobara {
  method puntos(disfraz, persona) = if (disfraz.compradoHaceMucho()) 5 else 3
}

object careta {
  method puntos(disfraz, persona) = disfraz.getValorPersonaje()
}

object sexy {
  method puntos(disfraz, persona) = if (persona.esSexy()) 15 else 2
}

class CombinacionDisfraces {
  const property disfraces = []

  method puntos(disfraz, persona) = disfraces.sum({ tipoDisfraz => tipoDisfraz.puntos(tipoDisfraz, persona) }) 
}