class UserException inherits Exception {}

// Punto 1.
class EspacioUrbano {
  var property valuacion
  const property superficie
  const property nombre
  var property tieneValladoNocturno

  method agregarValladoNocturno() {
    tieneValladoNocturno = true
  }

  method superficieGrande() = superficie > 50 

  method aumentarValuacionxPorcentaje(porcentaje) {
    valuacion = valuacion * (1 + porcentaje)
  }
  method aumentarValuacion(monto) {
    valuacion = valuacion + monto
  }

  method esGrande() = self.superficieGrande() and self.condicionParaSerGrande()

  method condicionParaSerGrande()
  method esVerde() = false
  method esLimpiable() = false 
}

class Plaza inherits EspacioUrbano {
  const property espacioEsparcimiento
  const property cantidadCanchas

  override method condicionParaSerGrande() = cantidadCanchas > 2

  override method esVerde() = cantidadCanchas == 0
  override method esLimpiable() = true
}

class Plazoleta inherits EspacioUrbano {
  const property espacioSinCesped
  const property homenaje

  method homenajeaAProcer(procer) = homenaje == procer

  override method condicionParaSerGrande() = self.homenajeaAProcer("San Martin") and tieneValladoNocturno
}

class Anfiteatro inherits EspacioUrbano {
  const property capacidad
  const property tamanioEscenario

  override method condicionParaSerGrande() = capacidad > 500

  override method esLimpiable() = self.esGrande()
}

class Multiespacio {
  var property espacios = []
  
  method esGrande() = espacios.all({ espacio => espacio.esGrande() })

  method esVerde() = espacios.size() > 3
}

// Punto 2.
class Persona {
  var property profesion
  var property costoXhora = 100

  method trabajar(espacioUrbano) {
    profesion.trabajar(espacioUrbano)
  }
}

object cerrajero {
  method trabajar(espacioUrbano) {
    if (espacioUrbano.tieneValladoNocturno()) {
        throw new UserException(message = "El espacio " + espacioUrbano.nombre() + " ya tiene vallado nocturno, no puede trabajar el cerrajero.")
    } else {
        espacioUrbano.agregarValladoNocturno()
    }
  }

  method duracionDeTrabajo(espacioUrbano) = if (espacioUrbano.esGrande()) 5 else 3
}

object jardinero {
  method trabajar(espacioUrbano) {
    if (!espacioUrbano.esVerde()) {
        throw new UserException(message = "El espacio " + espacioUrbano.nombre() + " no es verde, no puede trabajar el jardinero.")
    } else {
        espacioUrbano.aumentarValuacionxPorcentaje(0.10)
    }
  }
  
  method duracionDeTrabajo(espacioUrbano) = espacioUrbano.superficie() / 10
}

object encargado {
  method trabajar(espacioUrbano) {
    if (!espacioUrbano.esLimpiable()) {
        throw new UserException(message = "El espacio " + espacioUrbano.nombre() + " no es limpiable, no puede trabajar el encargado de limpieza.")
    } else {
        espacioUrbano.aumentarValuacion(5000)
    }
  }

  method duracionDeTrabajo(espacioUrbano) = 8
}