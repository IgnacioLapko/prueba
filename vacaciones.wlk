class Lugar{ // usamos herencia porque un balenario no deja de ser un balneario, etc, NO CAMBIAN, ES ESTATICO
    const property nombre

    method letrasDelNombre() = nombre.size()
    // si hacemos self.nombre() permite que dentro del metodo nombre pueda llegar a cambiar, se llama ACCESO INDIRECTO
    // si hacemos nombre, hago referencia directa a una variable, se llama ACCESO DIRECTO

    method esDivertido() = self.letrasDelNombre().even() && self.condicionSegunCiudad()  // ESTE SE LLAMA TEMPLATE

    method condicionSegunCiudad() // este se llama PRIMITIVA, PUEDE HABER MAS DE UNA con esto, 
                                  //creo una clase abstracta, no puedo hacer un const lugar = new Lugar 

    method esTranquilo() // No necesito clase abstracta para tener polimorfismo, lo dejo justificando que toda clase lugar esta obligada
                        // a implementar un comportamiento frente a esTranquilo, sino lo tengo que sacar, en este caso lo dejo, en el parcial
                        // ver si se deja o no
                        // Si tuviera que definir una clase Lugar solo para esTranquilo(), no lo hago, en este caso no priorizaria la interfaz

    method esRaro() = self.letrasDelNombre() > 10

}

class Ciudad inherits Lugar{
    const property habitantes
    const property atracciones = []
    const property decibeles

    override method condicionSegunCiudad() = self.tieneMuchasAtracciones() && self.tieneMuchosHabitantes()

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

    override method condicionSegunCiudad() = self.esAntigua() || self.esDelLitoral()

    method esAntigua() = fechaFundacion.year() < 1800

    method esDelLitoral() = provinciasDelLitoral.contains(provincia)

    override method esTranquilo() = provincia == "La Pampa"
}
class Balneario inherits Lugar{
    const property metrosPlaya
    const property marEsPeligroso // declaro como const y genero un potencial objeto inmutable (esta es la justificacion)
    const property tienePeatonal

    override method condicionSegunCiudad() = self.tieneMuchaPlaya() && marEsPeligroso

    method tieneMuchaPlaya() = metrosPlaya > 300

    override method esTranquilo() = !tienePeatonal
}

//const mardel = new Balneario(nombre = "Mardel", metrosPlaya = 500, marEsPeligroso = true, tienePeatonal = false)
// elige CRITERIO TRANQUILIDAD Y DIVERSION, NO elige RAREZA

// const liam = new Persona(preferencias = diversion) elige MARDEL
// const noel = new Persona(preferencias = tranquilidad) elige MARDEL
// const tyler = new Persona(preferencias = rareza) NO elige MARDEL
// const diversionRareza = new Combinacion(preferencias = [diversion, rareza])
// const joseph = new Persona(preferencia = diversionRareza) elige MARDEL

//<<strategy stateless>>, no tienen parametros, todos tienen el mismo comportamiento para ese pueblo, ciudad, etc
object tranquilidad{
    method elige(lugar) = lugar.esTranquilo()
}

object diversion{
    method elige(lugar) = lugar.esDivertido()
}

object rareza{
    method elige(lugar) = lugar.esRaro()
}

class Combinacion{ // ACA IMPLEMENTAMOS COMPOSITE, las hojas (rareza, diversion y tranquilidad) son polimorifcas con las ramas (Combinacion)
    const preferencias = []
    method elige(lugar) = preferencias.any({preferencia => preferencia.elige(lugar)})
}

//<<context>>
class Persona{
    var property preferencia
    const property presupuesto

    method iriaDeVacaciones(lugar) = preferencia.elige(lugar)

    method puedePagar(monto) = monto <= presupuesto

}
// class Tour{
//     const property diaSalida
//     const property mesSalida
//     const property anioSalida

//     const property fechaSalida = new Date(year = anioSalida, month = mesSalida, day = diaSalida)  
//     var property personasRequeridas
//     const ciudades = []
//     //const property montoXpersona
//     //var property cupo = personasRequeridas
//     const integrantes = []

//     method puedoIncorporarPersonaAtour(persona) = 
//     self.puedeEconomicamente(persona) 
//     && 
//     self.leGustanTodosLosLugares(persona)
//     &&
//     //personasRequeridas > 0
//     self.hayLugar()

//     method puedeEconomicamente(persona) = persona.presupuesto() > montoXpersona

//     method leGustanTodosLosLugares(persona) = ciudades.all({ciudad => persona.iriaDeVacaciones(ciudad)})

//     method descuentoCapacidadDelTour() {cupo = cupo - 1}

//     method incorporoPersonaAtour(persona){ 
//     if (self.puedoIncorporarPersonaAtour(persona)) 
//         (integrantes.add(persona))
//     } // aca no pongo el exception ,porque no se que condicion no estoy cumpliendo

//     method personaSeDaDeBaja() = 
//     if (cupo < personasRequeridas) 
//         {cupo = cupo + 1}

//     method pendienteDeConfirmacion() = cupo > 0

// }

class Tour{ // Lo importante del punto es saber donde poner las excepciones y donde no.
    const integrantes = []
    const destinos = []
    var property montoTour
    const cuposTotales
    const listaDeEspera = []
    const fecha

    method validarPago(persona) =
        if (!(persona.puedePagar(montoTour))) //delego la responsabilidad de saber si puede pagar o no a la persona, si la manera d calcular el presupuesto de la persona cambia en un futuro, este metodo no se ve afectado
            throw new DomainException(message = "Usted esta dispuesto a pagar menos que" + montoTour)

    method validarPreferencia(persona) =
        if (!(self.eligeLugares(persona))) //de esta manera, la persona no tiene que conocer como implementa un tour los lugares. si manana el tour implementa de otra manera los lugares y delego el metodo a la persona, puedo romper
            throw new DomainException(message = "Algun lugar no lo elegiria")

    method validarCupos(persona) = 
        if (!(self.estaConfirmado(persona))){
            listaDeEspera.add(persona)
            throw new DomainException(message = "El Tour esta confirmado. Quedas en la lista de espera")
        }

    method agregarPersona(persona){ // no agrego ni if ni and porque si falla alguno, las excepciones directamente me cortan el flujo de ejecucion
        self.validarPago(persona)
        self.eligeLugares(persona)
        self.validarCupos(persona)
        integrantes.add(persona)
    }

    method eligeLugares(persona) = destinos.all{lugar => persona.iriaDeVacaciones(lugar)}

    method estaConfirmado(personas) = integrantes.size() < cuposTotales

    method bajarPersona(persona){
        integrantes.remove(persona)
        self.agregarPersonaEnEspera()
    }

    method agregarPersonaEnEspera(){
        const nuevoIntegrante = listaDeEspera.first()
        listaDeEspera.remove(nuevoIntegrante)
        integrantes.add(nuevoIntegrante)
    }

    method esDeEsteAnio() = fecha.year() == new Date().year()

    method montoTotal() = montoTour * integrantes.size()
}

// const costa = new Tour(diaSalida = 12, mesSalida = 5, anioSalida = 2024, personasRequeridas = 2, ciudades = [mardel, clemente], montoXpersona = 1000)
// NOEL LA elige, NO PUEDO INCORPORAR A LIAM (clemente no es divertida)

// const clemente = new Balneario(nombre = "Clemente", metrosPlaya = 500, marEsPeligroso = false, tienePeatonal = false)
// const mardel = new Balneario(nombre = "Mardel", metrosPlaya = 500, marEsPeligroso = true, tienePeatonal = false)

// const liam = new Persona(preferencias = [diversion], presupuesto = 20000) elige MARDEL
// const noel = new Persona(preferencias = [tranquilidad], presupuesto = 20000) elige MARDEL
// const tyler = new Persona(preferencias = [rareza]) NO elige MARDEL
// const joseph = new Persona(preferencias = [diversion, rareza]) elige MARDEL

// la pregunta es donde vive la lista de tours
// si es class, voy a tener varias intancias (no es lo que quiero
// si los paso por parametro, donde voy almacenando los tours??, los necesito en produccion
object chequeador{
    const property tours = []
    const property hoy = new Date()

    method toursPendientes() = tours.filter({tour => !tour.estaConfirmado()})

    method toursDeAnioActual() = tours.filter({tour => tour.esDeEsteAnio()})

    method montoTotal() = self.toursDeAnioActual().sum{tour => tour.montoTotal()}
}