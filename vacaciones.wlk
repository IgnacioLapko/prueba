class Lugar{
    const property nombre

    method letrasDelNombre() = nombre.size()

    method esDivertido() = self.letrasDelNombre().even() && self.condicionSegunTipo() 

    method condicionSegunTipo()

    method esTranquilo()

    method esRaro() = self.letrasDelNombre() > 10

}

class Ciudad inherits Lugar{
    const property habitantes
    const property atracciones = []
    const property decibeles

    override method condicionSegunTipo() = self.tieneMuchasAtracciones() && self.tieneMuchosHabitantes()

    method tieneMuchasAtracciones() = atracciones.size() > 3

    method tieneMuchosHabitantes() = habitantes > 100000

    override method esTranquilo() = decibeles < 30

}
class Pueblo inherits Lugar{
    const property extension
    const property anioFundacion
    const fechaFundacion = new Date(year = anioFundacion)
    const property provincia
    const provinciasDelLitoral = ["Entre Rios", "Corrientes", "Misiones"]

    override method condicionSegunTipo() = self.esAntigua() || self.esDelLitoral()

    method esAntigua() = fechaFundacion.year() < 1800

    method esDelLitoral() = provinciasDelLitoral.contains(provincia)

    override method esTranquilo() = provincia == "La Pampa"
}
class Balneario inherits Lugar{
    const property metrosPlaya
    const property marEsPeligroso
    const property tienePeatonal

    override method condicionSegunTipo() = self.tieneMuchaPlaya() && marEsPeligroso

    method tieneMuchaPlaya() = metrosPlaya > 300

    override method esTranquilo() = !tienePeatonal
}

//const mardel = new Balneario(nombre = "Mardel", metrosPlaya = 500, marEsPeligroso = true, tienePeatonal = false)
// CUMPLE CRITERIO TRANQUILIDAD Y DIVERSION, NO CUMPLE RAREZA

// const liam = new Persona(preferencias = [diversion]) CUMPLE MARDEL
// const noel = new Persona(preferencias = [tranquilidad]) CUMPLE MARDEL
// const tyler = new Persona(preferencias = [rareza]) NO CUMPLE MARDEL
// const joseph = new Persona(preferencias = [diversion, rareza]) CUMPLE MARDEL


// Existen diferentes tipos de lugares:
// ciudades: tienen una cierta cantidad de habitantes, atracciones turísticas 
// (ej: "Obelisco", "Cabildo", "Rosedal", "Caminito") y sabemos la cantidad de decibeles promedio que tiene.
// pueblos: nos interesa la extensión en km2, cuándo se fundó y en qué provincia se ubica.
// balnearios: son una categoría especial, conocemos los metros de playa promedio que tienen, si el mar es 
// peligroso y si tiene peatonal.

// Queremos saber qué lugares son divertidos. Para todos los lugares, esto se da si tiene una cantidad par de letras. 
// Además, para las ciudades, si tienen más de 3 atracciones turísticas y más de 100.000 habitantes. En el caso de los 
// pueblos, debemos considerar además si se fundaron antes de 1800 o si son del Litoral 
// ("Entre Ríos", "Corrientes" o "Misiones"). Y en el caso de los balnearios habrá que considerar si tiene más de 300 
// metros de playa y si el mar es peligroso.

object tranquilidad{
    method cumple(lugar) = lugar.esTranquilo()
}

object diversion{
    method cumple(lugar) = lugar.esDivertido()
}

object rareza{
    method cumple(lugar) = lugar.esRaro()
}

class Combinacion{
    const preferencias = []
    method cumple(lugar) = preferencias.any({preferencia => preferencia.cumple(lugar)})
}

class Persona{
    const property preferencia
    const property presupuesto

    method iriaDeVacaciones(lugar) = preferencia.cumple(lugar)
}

// Las personas tienen preferencias para irse de vacaciones:
// algunos quieren tranquilidad, entonces el lugar al que se van debe ser tranquilo: para una ciudad esto significa que 
// tenga menos de 20 decibeles, para un pueblo que esté en la provincia de La Pampa y para un balneario que no tenga peatonal
//
// otros quieren diversión, así que el lugar al que se van debe ser divertido
//
// están los que quieren irse a lugares raros: son aquellos cuyo nombre tiene más de 10 letras (por ejemplo "Saldungaray")
//
// y por último aquellos que combinan varios criterios (con que alguno de los criterios acepte entonces decide ir a ese lugar)
// Nos interesa que una persona pueda cambiar su preferencia en forma simple, así como agregar nuevas preferencias a futuro.

// Queremos saber si una persona se iría de vacaciones a un lugar en base a su preferencia.



class Tour{
    const property diaSalida
    const property mesSalida
    const property anioSalida

    const property fechaSalida = new Date(year = anioSalida, month = mesSalida, day = diaSalida)  
    var property personasRequeridas
    const ciudades = []
    const property montoXpersona
    var property cupo = personasRequeridas

    method puedoIncorporarPersonaAtour(persona) = 
    self.puedeEconomicamente(persona) 
    && 
    self.leGustanTodosLosLugares(persona)
    &&
    personasRequeridas > 0

    method puedeEconomicamente(persona) = persona.presupuesto() > montoXpersona

    method leGustanTodosLosLugares(persona) = ciudades.all({ciudad => persona.iriaDeVacaciones(ciudad)})

    method descuentoCapacidadDelTour() {cupo = cupo - 1}

    method incorporoPersonaAtour(persona) = 
    if (self.puedoIncorporarPersonaAtour(persona)) 
        (self.descuentoCapacidadDelTour())

    method personaSeDaDeBaja() = 
    if (cupo < personasRequeridas) 
        {cupo = cupo + 1}

    method pendienteDeConfirmacion() = cupo > 0

}

// const costa = new Tour(diaSalida = 12, mesSalida = 5, anioSalida = 2024, personasRequeridas = 2, ciudades = [mardel, clemente], montoXpersona = 1000)
// NOEL LA CUMPLE, NO PUEDO INCORPORAR A LIAM (clemente no es divertida)


// const clemente = new Balneario(nombre = "Clemente", metrosPlaya = 500, marEsPeligroso = false, tienePeatonal = false)
// const mardel = new Balneario(nombre = "Mardel", metrosPlaya = 500, marEsPeligroso = true, tienePeatonal = false)

// const liam = new Persona(preferencias = [diversion], presupuesto = 20000) CUMPLE MARDEL
// const noel = new Persona(preferencias = [tranquilidad], presupuesto = 20000) CUMPLE MARDEL
// const tyler = new Persona(preferencias = [rareza]) NO CUMPLE MARDEL
// const joseph = new Persona(preferencias = [diversion, rareza]) CUMPLE MARDEL

// Punto 3: Tour (4 puntos)
// Queremos establecer el siguiente flujo para un tour:
// Inicialmente definimos una fecha de salida, la cantidad de personas requerida, 
// una lista de ciudades a recorrer y el monto a pagar por persona
// Luego agregamos a una persona, para lo cual
// el monto a pagar debe ser adecuado para la persona: cada persona define un presupuesto máximo para irse de vacaciones
// todos los lugares deben ser adecuados para la persona, según lo definido en el punto anterior
// en caso contrario, la persona no puede incorporarse al tour
// cuando llegamos a la cantidad de personas requerida, el tour se confirma y no se permite incorporar más gente, 
// a menos de que alguna persona se quiera bajar (ud. debe implementar la forma de lograr ésto)



object chequeador{
    const property tours = []
    const property hoy = new Date()

    method toursPendientes() = tours.filter({tour => tour.pendienteDeConfirmacion()})
    method toursQueSalenEsteAnio() = tours.filter({tour => tour.fechaSalida().year() == hoy.year()})
}

// Punto 4: Reportes (3 puntos)
// Queremos saber:
// Qué tours están pendientes de confirmación: son los que tienen menos cantidad de personas anotadas de las que el tour requiere.
// Cuál es el total de los tours que salen este año, considerando el monto por persona * la cantidad de personas.
// Se considerará explícitamente la delegación y la implementación de soluciones declarativas.


