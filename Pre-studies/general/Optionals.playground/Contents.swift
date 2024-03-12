// ### OPCIONAIS ###
// Tente usar o mínimo de opcionais possível e favoreça trabalhar com vars concretas
// E se utilizar, faça os unwraps o mais cedo possível

let numero: Int = 7;

var podeserNumero: Int?
podeserNumero = Int("12334") // isso é do tipo optional int, pois a string pode ou não ser um valor que pode ser convertido pra Int

// Optional binding - vincular um valor a uma variável apenas se o valor não for nulo

// if let (se houver valor, faça algo)
if let num2 = podeserNumero {
    print("Temos um número (\(num2))")
} else {
    print("Não temos um número.")
}

func printeNum(_ num: Int?) {
    guard let numero = num else {
        // guard let (se não houver valor, faça algo)
        print("Nenhum número foi passado.")
        return
    }
    
    print("Temos um número (\(num!))")
}

printeNum(podeserNumero)

// Unwrapping a força
var n3: Int?
// print(n3!) pode gerar um erro.

// Lidando com nulos
print(n3 ?? "Não há números") // se não houver n3, printe o que vier depois de ??

/*
    ___       _   _               _     _                  _
   / _ \ _ __| |_(_)___ _ _  __ _| |   /_\  _ _ __ __ _ __| |___
  | (_) | '_ \  _| / _ \ ' \/ _` | |  / _ \| '_/ _/ _` / _` / -_)
   \___/| .__/\__|_\___/_||_\__,_|_| /_/ \_\_| \__\__,_\__,_\___|
        |_|

 */

/*
🕹 Unwrap with if-let

Unwrap the following Optional using the if let statement
*/

let firstname: String? = "Sam"
if let name = firstname {
    print("Hello, \(firstname!)")
} else {
    print("There is no First Name")
}

/*
🕹 Unwrap with guard

Unwrap the following Optional using the guard statement
*/

enum MyError: Error {
    case invalidUsername
}

let lastname: String? = "Flynn"

func checkLastName(_ lastnm: String?) {
    guard let last = lastnm else {
        print("No last name was given.")
        return
    }
    print("\(lastnm!) allowed at the system")
}

checkLastName(nil)
checkLastName(lastname)
