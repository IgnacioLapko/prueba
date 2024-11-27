class Persona{
    const property edad
    const property carrerasAestudiar = []
    const property carrerasEstudiadas = []
    var property plataAganar
    const property lugaresAir = []
    var property tieneHijosBiologicos
    var property cantidadHijosAdoptivos
    const property sueniosAcumplir = []
    const property sueniosCumplidos = []
    var property tipoPersona

    method quiereEstudiar(carrera) = carrerasAestudiar.contains(carrera)

    method noEstudio(carrera) = carrerasEstudiadas.contains(carrera)

    method cumplirSuenio(suenio){
        sueniosAcumplir.remove(suenio)
        sueniosCumplidos.add(suenio)
    }

    method estudiarCarrera(carrera) {
        carrerasAestudiar.remove(carrera)
        carrerasEstudiadas.add(carrera)
    }

    method tenerHijo(){
        tieneHijosBiologicos = true
    }

    method tieneHijoBiologico() = tieneHijosBiologicos

    method adoptarHijo(hijosAdoptados) {cantidadHijosAdoptivos = cantidadHijosAdoptivos + hijosAdoptados}

    method fueAlugar(lugar) = lugaresAir.remove(lugar) 

    method cobraraMas(nuevoSueldo) = nuevoSueldo > plataAganar

    method cambiarTrabajo(nuevoSueldo) {plataAganar = nuevoSueldo}

    method cumplirSuenioMasPreciado() = tipoPersona.cumplirSuenioMasPreciado()

    method cualquierSuenio() = sueniosAcumplir.randomize().first()

    method primerSuenio() = sueniosAcumplir.first()

    method calcularFelicidonios(lista) = lista.sum({elemento => elemento.felicidonios()})

    method esFeliz() = self.calcularFelicidonios(sueniosCumplidos) > self.calcularFelicidonios(sueniosAcumplir)

    method sueniosTotales() = sueniosAcumplir + sueniosCumplidos

    method esAmbiciosa() = self.sueniosTotales().size() > 3 && self.calcularFelicidonios(self.sueniosTotales()) > 100

}

// const viajarAcataratas = new ViajarA(felicidonios = 50, lugar = "cataratas")
// const tenerHijo = new TenerHijo(felicidonios = 70)
// const conseguirTrabajo10k = new ConseguirTrabajo(felicidonios = 10, plataQueGanara = 10000)
// const combineta = new Combineta(suenioMultiple = [viajarAcataratas, tenerHijo, conseguirTrabajo10k])
// const persona1 = new Persona(edad = 50, carrerasAestudiar = [mate], carrerasEstudiadas = [psico], plataAganar = 5000, lugaresAir = [cataratas], tieneHijosBiologicos = false, cantidadHijosAdoptivos = 0, sueniosAcumplir = [combineta])
class Suenio{
    var property felicidonios

    method cumpleSuenio(persona){
        self.validaciones(persona)
        self.aplicarCambios(persona)
        persona.cumplirSuenio(self)
    }

    method validaciones(persona)

    method aplicarCambios(persona)
}

class RecibirseDeCarrera inherits Suenio{
    const property carrera

    method validarQuiereEstudiar(persona) =
    if (!(persona.quiereEstudiar(carrera)))
        throw new DomainException(message = "La persona no puede cumplir el sueño de recibirse de la carrera "+ carrera.toString() +" ya que no está en su lista de carreras a estudiar.")
    

    method validarNoEstudio(persona)=
    if (!(persona.noEstudio(carrera)))
        throw new DomainException(message = "La persona no puede cumplir el sueño de recibirse de la carrera "+ carrera.toString() +" ya que ya se recibió de la misma.")
    
    override method validaciones(persona) = self.validarQuiereEstudiar(persona) && self.validarNoEstudio(persona)

    override method aplicarCambios(persona) = persona.estudiarCarrera(carrera)

}

class TenerHijo inherits Suenio{

    override method validaciones(persona) = true

    override method aplicarCambios(persona) = persona.tenerHijo()

}

class AdoptarHijos inherits Suenio{
    const property cantidadHijosAadoptar

    method validarTieneHijoBiologico(persona) =
        if (persona.tieneHijoBiologico())
            throw new DomainException(message = "La persona no puede cumplir el sueño de adpotar un hijo ya que tiene al menos uno biologico.")

    override method validaciones(persona) = self.validarTieneHijoBiologico(persona)

    override method aplicarCambios(persona) = persona.adoptarHijo(cantidadHijosAadoptar)

}

class ViajarA inherits Suenio{
    const property lugar

    override method validaciones(persona) = true

    override method aplicarCambios(persona) = persona.fueAlugar(lugar) 
}

class ConseguirBuenTrabajo inherits Suenio{
    const property plataQueGanara

    method validarCobraraMas(persona) =
        if (!(persona.cobraraMas(plataQueGanara))){
            throw new DomainException(message = "La persona va a cobrar menos de lo que cobra actualmente.")
        }

    override method validaciones(persona) = self.validarCobraraMas(persona)

    override method aplicarCambios(persona) = persona.cambiarTrabajo(plataQueGanara)
}

class Combineta{

    const property suenioMultiple = []
    
    method cumpleSuenio(persona) = suenioMultiple.forEach({suenio => suenio.cumpleSuenio(persona)})

    method felicidonios(persona) = suenioMultiple.sum({suenio => suenio.felicidonios()})

}

// Punto 2 | 2 puntos
// Modelar un sueño múltiple, que permite unir varios sueños:
// viajar a Cataratas
// tener 1 hijo
// conseguir un trabajo de $ 10,000

// Esto hace que se cumplan los 3 sueños. Si alguno de los 3 no se pueden cumplir debería tirar error y no cumplir ninguno, ej:
// viajar a Cataratas
// tener 1 hijo
// conseguir un trabajo de $ 200 (la persona quiere ganar $ 7.000)
// Esto produce un error. No hace falta considerar el estado en el que queda la persona al ir cumpliendo sueños 
// (ej: tener 1 hijo, adoptar 1 hijo podría tirar error por separado pero no si participan de un sueño múltiple)

class Realista{
    const property suenioMasImportante

    method cumplirSuenioMasPreciado(persona) = suenioMasImportante.cumpleSuenio(persona)
}

object alocado{
    method cumplirSuenioMasPreciado(persona) = persona.cualquierSuenio().cumpleSuenio(persona)
}

object obsesivo{
    method cumplirSuenioMasPreciado(persona) = persona.primerSuenio().cumpleSuenio(persona)
}

// Punto 3 | 4 puntos
// Hemos clasificado diferentes tipos de personas. Los realistas cumplen la meta más importante para ellos,
// los alocados quieren cumplir un sueño cualquiera al azar, los obsesivos cumplen el primer sueño de la lista. 
// Pueden aparecer a futuro nuevos tipos de persona. Resolver el requerimiento que pide que una persona cumpla su 
// sueño más preciado, teniendo en cuenta que queremos que una persona realista pueda pasar de alocado a realista o de realista a obsesivo.

// Punto 4 | 2 puntos
// Queremos saber si una persona es feliz, esto se da si el nivel de felicidad que tiene es mayor a los felicidonios que suman los sueños pendientes.

// Punto 5 | 2 puntos
// Queremos saber si una persona es ambiciosa, esto se da si tiene más de 3 sueños (pendientes o cumplidos) con más de 100 felicidonios.
