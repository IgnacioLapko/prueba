object sordo{
    method aplicarCriterio(elemento, persona, otraPersona) {
        const primerElemento = otraPersona.tieneCerca().first()
        persona.tomarElemento(primerElemento)
        otraPersona.darElemento(primerElemento)
        }
}

object todosLosElementos{
    method aplicarCriterio(elemento, persona, otraPersona) {
        self.tomarTodosLosElementos(persona, otraPersona) 
        self.borrarTodosLosElementos(otraPersona)}

    method tomarTodosLosElementos(persona, otraPersona) {persona.tieneCerca().addAll(otraPersona.tieneCerca())}

    method borrarTodosLosElementos(otraPersona) {otraPersona.tieneCerca().clear()}
}

object cambioPosicion{

    method aplicarCriterio(elemento, persona, otraPersona) {
        const posicionOriginal = persona.posicion()

        persona.cambiarPosicion(otraPersona.posicion()) 
        otraPersona.cambiarPosicion(posicionOriginal)}
}

object benditoElemento{
    method aplicarCriterio(elemento, persona, otraPersona) {
        persona.tomarElemento(elemento)
        otraPersona.darElemento(elemento)
    }
}

class Persona{
    var property posicion = null
    const property tieneCerca = []
    var property criterioElemento = null
    var property criterioComida = null
    const property comidaIngerida = []

    method pedirElemento(elemento, otraPersona) = 
    if (otraPersona.tieneCerca().contains(elemento)){
        otraPersona.criterioElemento().aplicarCriterio(elemento, self, otraPersona)
    }else{
        throw new DomainException(message = "La otra persona no tiene la/el" + elemento + "cerca.")
    }

    method cambiarPosicion(nuevaPosicion) {posicion = nuevaPosicion}

    method tomarElemento(elemento) = self.tieneCerca().add(elemento)

    method darElemento(elemento) = self.tieneCerca().remove(elemento)

    method aceptaComida(bandeja) =
    if (criterioComida.aceptaComida(bandeja)){
        comidaIngerida.add(bandeja)
    }else{
        throw new DomainException(message = "La persona no acepta comer la/el "+ bandeja + " de la bandeja.")
    }

    method estaPipon() = comidaIngerida.any({comida => comida.esPesada()})

    method laEstaPasandoBien() = self.comioAlgo() && self.condicionSecundaria()

    method comioAlgo() = !comidaIngerida.isEmpty()

    method condicionSecundaria() = true

}

// const juan = new Persona(posicion = "A", tieneCerca = ["ensalada", "cuchillo", "tenedor"], criterioElemento = sordo, criterioComida = vegetariano) esta pipon
// const pedro = new Persona(posicion = "B", tieneCerca = ["banana", "mandarina"], criterioElemento = todosLosElementos, criterioComida = dietetico)
// const lucas = new Persona(posicion = "C", tieneCerca = ["molleja", "chori"], criterioElemento = cambioPosicion ,criterioComida = alternado)
// const alberto = new Persona(posicion = "D", tieneCerca = ["huevos", "cuchara"], criterioElemento = benditoElemento, criterioComida = combineta) no acepta ni superAlfajor ni pechitoDeCerdo, no esta pipon
// const combineta = new Combinacion(criteriosComida = [vegetariano, dietetico])
class Bandeja{
    const property calorias
    const property esCarne

    method esPesada() = calorias > 500
}

object vegetariano{
    method aceptaComida(bandeja) = !bandeja.esCarne()
}

object oms{
    var property caloriasRecomendadas = 500
}

object dietetico{
    method aceptaComida(bandeja) = bandeja.calorias() < oms.caloriasRecomendadas()
}

object alternado{
    var property aceptaAlternado = false

    method cambioAlternado() =
    if (!aceptaAlternado){
        aceptaAlternado = true
        return aceptaAlternado
    }else{
        aceptaAlternado = false
        return aceptaAlternado
    }

    method aceptaComida(bandeja) = self.cambioAlternado()
}

class Combinacion{
    const criteriosComida = []

    method aceptaComida(bandeja) = criteriosComida.all({criterio => criterio.aceptaComida(bandeja)})
}

// const pechitoDeCerdo = new Bandeja(calorias = 270, esCarne = true)
// const superAlfajor = new Bandeja(calorias = 800, esCarne = false)
// const ensalada = new Bandeja(calorias = 100, esCarne = false)

// Punto 3) Pipón - 2 puntos
// Queremos saber si un comensal está pipón, esto ocurre si alguna de las comidas 
// que ingirió es pesada (insume más de 500 calorias).

// Punto 4) ¡Qué bien la estoy pasando! - 3 puntos
// Queremos saber si un comensal la está pasando bien en el asado, esto ocurre en general si esa persona comió algo y
// Osky no pone objeciones, siempre la pasa bien
// Moni si se sentó en la mesa en la posición 1@1
// Facu si comió carne
// Vero si no tiene más de 3 elementos cerca

object osky inherits Persona{
    override method condicionSecundaria() = true
}

object moni inherits Persona{
    override method condicionSecundaria() = posicion == "1@1"
}

object facu inherits Persona{
    override method condicionSecundaria() = self.comioCarne() 

    method comioCarne() = comidaIngerida.any({comida => comida.esCarne()})
}

object vero inherits Persona{
    override method condicionSecundaria() = self.pocosElementosCerca()

    method pocosElementosCerca() = tieneCerca.size() <= 3
}