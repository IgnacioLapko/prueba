// Cada persona sabe su posición y qué elementos cerca tiene: sal, aceite, vinagre, aceto, oliva, 
// cuchillo que corta bien, etc.
// Queremos modelar que un comensal le pida a otro si le pasa una cosa.

// Si la otra persona no tiene el elemento, la operaclassción no puede realizarse.

// Lo que ocurre depende del criterio de cada persona tiene:
// algunos son sordos, le pasan el primer elemento que tienen a mano
// otros le pasan todos los elementos, “así me dejás comer tranquilo”
// otros le piden que cambien la posición en la mesa, “así de paso charlo con otras personas” 
// (ambos intercambian posiciones, A debe ir a la posición de B y viceversa)
// y finalmente están las personas que le pasan el bendito elemento al otro comensal

// Nos interesa que se puedan agregar nuevos criterios a futuro y que sea posible que una persona 
// cambie de criterio dinámicamente (que pase de darle todos los elementos a sordo, por ejemplo). 
// Cuando una persona le pasa un elemento a otro éste (el elemento) deja de estar cerca del comensal 
// original para pasar a estar cerca del comensal que pidió el elemento.

object sordo{
    method aplicarCriterio(elemento, persona, otraPersona) {self.alcanzarPrimerElemento(persona, otraPersona) self.eliminarPrimerElemento(otraPersona)}

    method alcanzarPrimerElemento(persona, otraPersona) {persona.tieneCerca().add(otraPersona.tieneCerca().first())}

    method eliminarPrimerElemento(otraPersona) {otraPersona.remove(otraPersona.tieneCerca().first())}
}

object todosLosElementos{
    method aplicarCriterio(elemento, persona, otraPersona) {self.tomarTodosLosElementos(persona, otraPersona) self.borrarTodosLosElementos(otraPersona)}

    method tomarTodosLosElementos(persona, otraPersona) {persona.tieneCerca().addAll(otraPersona.tieneCerca())}

    method borrarTodosLosElementos(otraPersona) {otraPersona.tieneCerca().clear()}
}

object cambioPosicion{
    method aplicarCriterio(elemento, persona, otraPersona) {self.cambiarPosicion(persona, otraPersona) self.cambiarPosicion(otraPersona, persona)}

    method cambiarPosicion(persona, otraPersona) {persona.posicion() = otraPersona.posicion()}
}

object benditoElemento{
    method aplicarCriterio(elemento, persona, otraPersona) {self.alcanzarElemento(elemento, persona) self.borrarElemento(elemento, otraPersona)}

    method alcanzarElemento(elemento, persona) {persona.tieneCerca().add(elemento)}

    method borrarElemento(elemento, otraPersona) {otraPersona.tieneCerca().remove(elemento)}
}

class Persona{
    var property posicion
    const property tieneCerca = []
    var property criterio

    method pedirElemento(elemento, persona, otraPersona) = 
    if (otraPersona.tieneCerca().contains(elemento)){
        criterio.aplicarCriterio(elemento, persona, otraPersona)
    }else{
        throw new DomainException(message = "La otra persona no tiene el elemento:" + elemento)
    }
}