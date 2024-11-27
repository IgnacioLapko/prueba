// Punto 1: Vacunas
// Tenemos las siguientes vacunas a disposición:

// Paifer - integrante 1: multiplica por 10 los anticuerpos de la persona a la que se le da la dosis,
// otorga una inmunidad por 6 meses si la persona es mayor a 40 o 9 meses en caso contrario, siempre 
// contando desde el día de la aplicación.

// Larussa - integrante 2: cada compuesto tiene un número que indica el efecto multiplicador de anticuerpos 
// que da a la persona (hasta un máximo de 20x). Otorga una inmunidad hasta el 03/03/2022.

// AstraLaVistaZeneca - integrante 3: suma 10.000 anticuerpos a la persona. La inmunidad que otorga es 6 meses 
// si la persona tiene un nombre par o 7 en caso contrario.

// Combineta - común a todas las personas: es un compuesto que contiene varias dosis combinadas de alguna de las 
// anteriores (sabemos cuáles son). Considerar que otorga el mínimo de anticuerpos y el máximo de inmunidad de 
// todas las vacunas que conforman el combo.

// Dado que la OMS publica nuevos informes diariamente, queremos que sea fácil modelar la aparición de nuevas variantes de vacunas.

class Persona{
    var property vacuna
    var property anticuerpos
    var property fechaInmunidad
    const property edad
    const property nombre

    method multiplicaAnticuerpos(multiplicador) {anticuerpos = anticuerpos * multiplicador}

    method incrementaAnticuerpos(cantidadIncrementada) {anticuerpos = anticuerpos + cantidadIncrementada}

    method sumaInmunidad(meses) {fechaInmunidad = new Date().plusMonths(meses)}

    method inmunidadHasta(fecha) {fechaInmunidad = fecha}

    method esMayorDe40() = edad > 40

    method tieneNombrePar() = nombre.even()
}
object paifer{

    method aplicarVacuna(persona){
        persona.multiplicaAnticuerpos(10)
        persona.sumaInmunidad(self.cuantoInmuniza(persona))
    }

    method cuantoInmuniza(persona) = if (persona.esMayorDe40()) 6 else 9
}

class Larussa{
    var property multiplicador

    method aplicarVacuna(persona){
        persona.multiplicaAnticuerpos(multiplicador)
        persona.inmunidadHasta(new Date(year = 2022, month = 03, day = 03))
    }
}

object astraLaVistaZeneca{
    method aplicarVacuna(persona){
        persona.incrementarAnticuerpos(10000)
        persona.sumaInmunidad(self.cuantoInmuniza(persona))
    }

    method cuantoInmuniza(persona) = if (persona.tieneNombrePar()) 6 else 7
}

class Combineta{
    const property vacunas = []
}

// Punto 2: Costo de las vacunas
// Incorporar ahora el costo de cada vacuna, que es inicialmente $ 1.000 hasta los 30 años, y a partir de los 
// 30 años se incrementa $ 50 por año (una persona de 35 costaría $ 1.250, una persona de 81 costaría $ 3.550, 
// son 51 x 50 = 2.550 + 1.000). 

// Además cada vacuna puede agregar un extra:
// Paifer - integrante 1: le agrega un costo de $ 400 si la persona es menor a 18 años, o $ 100 en caso contrario.

// Larussa - integrante 2: le incorpora $ 100 por el efecto multiplicador de los anticuerpos (contado en el punto 1)

// AstraLaVistaZeneca - integrante 3: le agrega $ 2.000 a las personas especiales, que son las que viven en Tierra 
// del Fuego, Santa Cruz o Neuquén, en caso contrario no tiene costo extra.

// Combineta: le aplica la sumatoria de todos los costos (ej: si el costo total de una Paifer fuera $ 1.400 y el 
// costo de una Larussa fuera $ 1.500, el total sería $ 2.900). El costo extra suma 100 pesos por cada vacuna.
