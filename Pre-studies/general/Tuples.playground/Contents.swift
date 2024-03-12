// ### TUPLAS ###
// Tuplas são grupos de zero ou mais valores representados como um valor
// São utilizadas como lightweight classes pra classes mais enxutas

let error = (404, "Not Found")
let code = error.0
let description = error.1

// Também é possível fazer como parâmetros nomeados
var pessoa = (nome: "Chandler", sobrenome: "Bing")
print(pessoa.nome)

// São definidas como qualquer outra variável e atendem a let x var
var point = (x: 0,y: 0)
point.x = 15
print(point)

var origem = point
origem.x = 0
// Tuplas são value types, ou seja, se cria uma cópia

// Tuplas tem tipos
let umaTupla = ("tupla", 1, true) // (String, Int, Bool)

var (nome, sobrenome) = pessoa // decomposing
var (_, numero, _) = umaTupla // _ ignora e não precisa que o nome dos parametros seja igual

/*
  _____          _         _                  _
 |_   _|  _ _ __| |___    /_\  _ _ __ __ _ __| |___
   | || || | '_ \ / -_)  / _ \| '_/ _/ _` / _` / -_)
   |_| \_,_| .__/_\___| /_/ \_\_| \__\__,_\__,_\___|
           |_|
 */

/*
🕹 Status code
 
 Write a method called getStatusCode() that returns a hard coded tuple of type (Int, String) containing values 400 and "Not found". Unpack the tuple, and print out the returned values.

 > func getStatusCode() -> tuple {
    // create and retrn tuple here
 }
 
*/

func getStatusCode() -> (Int, String) {
    return (404, "Not Found")
}

/*
🕹 Class to tuple

 Convert the following class into a light weight tuple.
 
 class Flight {
     var airport:String
     var airplane:Int
 }

 Use the class variable names as tuple named parameters, and print out the flight details in a print statement.
 
*/

var flight = (airport: "Maceió MCZ", airplane: "Latam A320")
flight.airport
