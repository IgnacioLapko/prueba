// La secretaría de Infraestructura y Mantenimiento de Espacios Verdes de un municipio nos solicita que 
// generemos un modelo para representar su dominio, que consiste en hacer un seguimiento a los trabajos 
// de mejora de cada uno de los diferentes espacios urbanos:
// plazas: tienen un espacio específico dedicado al esparcimiento, además sabemos cuántas canchas tienen
// plazoletas: delimitan un pequeño espacio medido en metros cuadrados donde no hay césped y rinden homenaje a algún prócer
// anfiteatros: tienen una capacidad (ej: 1.000 personas), un escenario con un tamaño medido en metros cuadrados
// multiespacio: está conformado por una serie de plazas, plazoletas, anfiteatros o multiespacios.
// Todos los espacios urbanos son activos del municipio, por lo tanto tienen una valuación en pesos, tienen una 
// superficie medida en metros cuadrados, llevan un nombre: “Plaza Ciudad de Banff”, “Anfiteatro Parque Centenario”,
//  y sabemos si tienen vallado que se cierra de noche. Periódicamente hay personas que hacen diferentes trabajos a 
//  cualquiera de estos espacios urbanos, como veremos más adelante

class EspacioUrbano{
    var property valuacion
    const property superficie
    const property nombre
    var property tieneVallado
    const property trabajos = []

    method esGrande() = self.superficieEsGrande() && self.condicionParticular()

    method superficieEsGrande() = superficie > 50

    method condicionParticular()

    method colocarVallado() {tieneVallado = true}

    method aumentarValuacion(aumento) {valuacion = valuacion + aumento}

    method trabajosHeavys() = trabajos.filter({trabajo => trabajo.esHeavy(self)})

    method trabajosHeavysDelUltimoMes() = self.trabajosHeavys().filter({trabajo => trabajo.fecha().month() == new Date().month()})

    method esDeUsoIntensivo() = self.trabajosHeavysDelUltimoMes().size() > 5
}

class Plaza inherits EspacioUrbano{
    const property tieneEsparcimiento
    const cantidadCanchas

    override method condicionParticular() = cantidadCanchas > 2

    method esVerde() = cantidadCanchas == 0

    method esLimpiable() = true
}

class Plazoleta inherits EspacioUrbano{
    const property metrosSinCesped
    const procer

    override method condicionParticular() = procer == "San Martin" && tieneVallado
}

class Anfiteatro inherits EspacioUrbano{
    const property capacidad
    const property metrosEscenario

    override method condicionParticular() = capacidad > 500

    method esLimpiable() = self.esGrande()
}

class Multiespacio inherits EspacioUrbano{
    const espaciosUrbanos = []

    override method condicionParticular() = espaciosUrbanos.all({espacioUrbano => espacioUrbano.condicionParticular()})

    method esVerde() = espaciosUrbanos.size() > 3
}

// 1- Espacios urbanos grandes (3 puntos)
// Queremos saber si un espacio urbano es grande, esto se da
// para todos los espacios urbanos si la superficie total supera los 50 metros cuadrados y además
// para las plazas, si tienen más de 2 canchas
// para las plazoletas, si el prócer es “San Martín” y de noche se cierra con llave
// para los anfiteatros, si la capacidad supera las 500 personas
// para los multiespacios, si cumplen todas las condiciones de los espacios urbanos que contienen 
// (ej, si tienen una plaza y una plazoleta, deben satisfacer ambas restricciones a la vez)
// No debe repetir código ni ideas de diseño. 

//const plazaGrande = new Plaza(valuacion = 100, superficie = 100, nombre = "Peru", tieneVallado = false, tieneEsparcimiento = true, cantidadCanchas = 5)
//const plazaChica = new Plaza(valuacion = 100, superficie = 20, nombre = "Bolivia", tieneVallado = true, tieneEsparcimiento = true, cantidadCanchas = 1)
//const plazoletaGrande = new Plazoleta(valuacion = 100, superficie = 100, nombre = "Hitler", tieneVallado = true, procer = "San Martin", metrosSinCesped = 50)
//const plazoletaChica = new Plazoleta(valuacion = 100, superficie = 10, nombre = "Messi", tieneVallado = false, procer = "Sarmiento", metrosSinCesped = 50)
//const anfiteatroGrande = new Anfiteatro(valuacion = 100, superficie = 100, nombre = "Cacona", tieneVallado = true, capacidad = 800, metrosEscenario = 100)
//const anfiteatroChico = new Anfiteatro(valuacion = 100, superficie = 40, nombre = "Pipi", tieneVallado = true, capacidad = 100, metrosEscenario = 100)
//const multiespacioGrande = new Multiespacio(espaciosUrbanos = [plazaGrande, plazoletaGrande], valuacion = 100, superficie = 1000, nombre = "Rata", tieneVallado = true)
//const multiespacioChico = new Multiespacio(espaciosUrbanos = [plazaGrande, plazoletaChica], valuacion = 100, superficie = 40, nombre = "Siomara", tieneVallado = true)

//______________________________________________________________________________________________________________________________________________

// 2- Trabajadores (5 puntos)
// Todas las personas tienen una profesión en algún momento. Queremos que esa profesión pueda cambiar a lo largo del tiempo. 
// Las profesiones determinan varias cosas:

// Los cerrajeros pueden trabajar con cualquier espacio urbano que no tenga vallado. 
// Una vez cumplido el trabajo el espacio urbano queda con un vallado que se cierra de noche. 
// La duración del trabajo de cerrajero es de 5 horas si el espacio es grande o 3 en caso contrario. 

// Los jardineros trabajan con espacios urbanos verdes, que son únicamente las plazas que no tienen canchas o 
// los multiespacios que contienen más de 3 espacios urbanos. Una vez cumplido su trabajo el césped se ve “más lindo”,
// lo que aumenta la valuación del espacio urbano un 10%. La duración de su trabajo es 1 hora cada 10 metros cuadrados. 
// Si tenemos 85 metros cuadrados, está bien considerar 8,5 (no es importante la exactitud en el parcial, estamos evaluando 
// conocimientos del paradigma). 

// Los encargados de limpieza traen una hidrolavadora gigante, trabajan con espacios urbanos “limpiables”, 
// que son los anfiteatros grandes y las plazas (no con plazoletas ni con multiespacios). Una vez cumplido su 
// trabajo el espacio urbano se valúa en $ 5.000 más. La duración de su trabajo es 8 horas fijo (un día de trabajo).

// El costo de cada trabajador se estima en $ 100 la hora para todos los trabajadores, menos para los jardineros que 
// siempre cobran $ 2.500 por trabajo realizado. El valor hora del trabajador puede cambiar.
// Muestre cómo haría en la consola REPL para que una persona llamada Tito comience siendo cerrajero y luego pase a ser jardinero.

class Persona{
    var property profesion

    method trabajaEspacio(espacioUrbano) = profesion.trabajaEspacio(self, espacioUrbano)

    method duracionTrabajo(espacioUrbano) = profesion.duracionTrabajo(espacioUrbano)

    method costo(espacioUrbano) = profesion.costo(espacioUrbano)

    method registrarTrabajo(espacioUrbano) {espacioUrbano.trabajos().add(new Trabajo(
        nombrePersona = self,
        fecha = new Date(),
        duracion = self.duracionTrabajo(espacioUrbano),
        costo = self.costo(espacioUrbano)
    ))}
}

class Trabajo{
    const property nombrePersona
    const property fecha
    const property duracion
    const property costo

    method esHeavy(espacioUrbano) = costo > 10000 || nombrePersona.profesion().condicionSecundaria()

    method condicionSecundaria() = false
}

object cerrajero{
    method puedeTrabajar(espacioUrbano) = !espacioUrbano.tieneVallado()

    method trabaja(espacioUrbano) = espacioUrbano.colocarVallado()

    method trabajaEspacio(persona, espacioUrbano) = 
        if (!(self.puedeTrabajar(espacioUrbano))){
            throw new DomainException(message = "El espacio " + espacioUrbano + " ya tiene vallado. El cerrajero no lo puede trabajar.")
        }else{
            self.trabaja(espacioUrbano) 
            persona.registrarTrabajo(espacioUrbano)
        }

    method duracionTrabajo(espacioUrbano) = if (espacioUrbano.esGrande()) 5 else 3

    method costo(espacioUrbano) = self.duracionTrabajo(espacioUrbano) * 100    

    method condicionSecundaria(espacioUrbano) = self.duracionTrabajo(espacioUrbano) > 5
}

// const juancho = new Persona(profesion = cerrajero)
// const plazoletaChica = new Plazoleta(valuacion = 100, superficie = 10, nombre = "Messi", tieneVallado = false, procer = "Sarmiento", metrosSinCesped = 50)
// juancho.trabajaEspacio(plazoletaChica) = true
// plazoletaChica.tieneVallado() = true
// plazoletaChica.esGrande() = false
// juancho.profesion().duracionTrabajo(plazoletaChica) = 3
// juancho.profesion().costo(plazoletaChica) = 300

// const juancho = new Persona(profesion = cerrajero)
// const plazaGrande = new Plaza(valuacion = 100, superficie = 100, nombre = "Peru", tieneVallado = false, tieneEsparcimiento = true, cantidadCanchas = 5)
// juancho.trabajaEspacio(plazaGrande) = true
// plazaGrande.tieneVallado() = true
// plazaGrande.esGrande() = true
// juancho.profesion().duracionTrabajo(plazaGrande) = 5
// juancho.profesion().costo(plazaGrande) = 500

// const juancho = new Persona(profesion = cerrajero)
// const plazoletaGrande = new Plazoleta(valuacion = 100, superficie = 100, nombre = "Hitler", tieneVallado = true, procer = "San Martin", metrosSinCesped = 50)
// juancho.profesion().trabajaEspacio(plazoletaGrande) = exception

object jardinero{
    method puedeTrabajar(espacioUrbano) = espacioUrbano.esVerde()

    method trabaja(espacioUrbano) = espacioUrbano.aumentarValuacion(espacioUrbano.valuacion() * 0.1)

    method trabajaEspacio(persona, espacioUrbano) = 
        if (!(self.puedeTrabajar(espacioUrbano))){
            throw new DomainException(message = "El espacio " + espacioUrbano + " no es verde. El jardinero no lo puede trabajar.")
        }else{
            self.trabaja(espacioUrbano)
            persona.registrarTrabajo(espacioUrbano)
        }

    method duracionTrabajo(espacioUrbano) = espacioUrbano.superficie() / 10

    method costo(espacioUrbano) = 2500

    method condicionSecundaria() = false
}

// const carlitox = new Persona(profesion = jardinero)
// const plazaGrande = new Plaza(valuacion = 100, superficie = 100, nombre = "Peru", tieneVallado = false, tieneEsparcimiento = true, cantidadCanchas = 0)
// carlitox.trabajaEspacio(plazaGrande) = true
// plazaGrande.valuacion() = 110
// carlitox.profesion().duracionTrabajo(plazaGrande) = 10
// carlitox.profesion().costo(plazaGrande) = 2500

// const carlitox = new Persona(profesion = jardinero)
// const multiespacioGrande = new Multiespacio(espaciosUrbanos = [plazaGrande, plazoletaGrande], valuacion = 100, superficie = 1000, nombre = "Rata", tieneVallado = true)
// carlitox.profesion().trabajaEspacio(multiespacioGrande) = exception

object encargadoLimpieza{
    method puedeTrabajar(espacioUrbano) = espacioUrbano.esLimpiable()

    method trabaja(espacioUrbano) = espacioUrbano.aumentarValuacion(5000)

    method trabajaEspacio(persona, espacioUrbano) = 
        if (!(self.puedeTrabajar(espacioUrbano))){
            throw new DomainException(message = "El espacio " + espacioUrbano + " no es verde. El jardinero no lo puede trabajar.")
        }else{
            self.trabaja(espacioUrbano)
            persona.registrarTrabajo(espacioUrbano)
        }

    method duracionTrabajo(espacioUrbano) = 8

    method costo(espacioUrbano) = self.duracionTrabajo(espacioUrbano) * 100

    method condicionSecundaria() = false
}


// const pepe = new Persona(profesion = encargadoLimpieza)
// const anfiteatroGrande = new Anfiteatro(valuacion = 100, superficie = 100, nombre = "Cacona", tieneVallado = true, capacidad = 800, metrosEscenario = 100)
// pepe.profesion().trabajaEspacio(anfiteatroGrande) = true
// anfiteatroGrande.valuacion() = 5100
// pepe.profesion().duracionTrabajo(plazaGrande) = 8
// pepe.profesion().costo(plazaGrande) = 800

// const pepe = new Persona(profesion = encargadoLimpieza)
// const anfiteatroChico = new Anfiteatro(valuacion = 100, superficie = 40, nombre = "Pipi", tieneVallado = true, capacidad = 100, metrosEscenario = 100)
// pepe.profesion().trabajaEspacio(anfiteatroChico) = exception

// Queremos registrar un trabajo, para lo cual 
// queremos validar que la persona pueda hacer dicho trabajo (según lo definido en el punto 2), 
// en caso de no pasar dicha validación debe informar de la manera que cree más conveniente al usuario
// a partir de aquí asumimos que pasó la validación para lo cual, debe producir efecto en el espacio urbano 
// (el efecto que causa el trabajo de dicha persona)
// por último debemos registrar la fecha y asociar la persona que realizó el trabajo con el espacio urbano involucrado, 
// además de la duración y el costo a ese momento.
