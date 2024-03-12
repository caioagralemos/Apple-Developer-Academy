// ### CLOSURES ###
// Closures são pedaços de código que podem ser utilizados em todo seu código
// Funções também são consideradas closure, pois são blocos de código que podem ser utilizados e reutilizados
// Meio parecidas com as Arrow Functions do JavaScript

let closureCodigo = {
    let player1 = "Jogador 1"
    let computer = "Computador"
    
    if player1 > computer {
        print("\(player1) venceu")
    } else {
        print("Game over!")
    }
}

closureCodigo() // executando

let closureComoVariavel = { print("Eu sou uma closure") }
closureComoVariavel()

// Closures também possuem tipo
var hello: () -> (String) = {
    // uma closure que não recebe parametros e retorna uma String
    return "Olá"
}

hello()

// o tipo é auto atribuido assim como nas variáveis
var hello2 = {
    return "Olá"
}

hello2()

// closure que recebe uma int e retorna uma int
var cubo: (Int) -> (Int) = { x in
    return x * x * x
}

cubo(13)

// você pode passar closures como variaveis
var tambemCubo = cubo
tambemCubo(15)


// Ready Player 1 - fazer uma closure que sorta o array por len da string
var strings = ["Ewa", "Alex", "Chris", "Barry", "Daniella"]
let orderStrings = strings.sorted() { $0.count < $1.count } // $0 e $1 representam dois valores aleatorios do array

// Capturing Values
// Uma closure pode capturar constantes e variaveis quando é definida pra que elas possam ser referenciadas e modificadas mesmo em outro escopo
func incrementador(quantoAumentar amount: Int) -> () -> Int {
    var total = 0
    func incremente() -> Int {
        total += amount
        return total
    }
    return incremente
}

let aumentarDez = incrementador(quantoAumentar: 10)

aumentarDez() // sempre referenciando a variavel 'total', mesmo que ela não esteja no escopo
aumentarDez()

// Closures são reference types, ou seja, quando chamamos uma closure, criamos um ponteiro pra referenciar a original e não uma nova (value types)
let tambemAumentarPorDez = aumentarDez


// Escaping Closures
// são closures que vivem além do escopo em que elas são definidas
func escapingClosure (completionHandler: @escaping () -> Void) {}
func nonEscapingClosure (closure: () -> Void) {}

class SomeClass {
    var x = 10
    func doSomething() {
        // mecanicamente a diferença aqui é essa
        escapingClosure { self.x = 20 }
        nonEscapingClosure { x = 200 }
    }
}

// Autoclosures
// normalmente quando vamos passar uma closure inline por parametro precisamos envolver-la em {}, mas passar o tipo @autoclosure faz com que o parametro ja espere uma closure e assim não seja necessário passar as {}

struct Person: CustomStringConvertible {
     let name: String
     
     var description: String {
         print("Asking for Person description.")
         return "Person name is \(name)"
     }
 }

let isDebuggingEnabled: Bool = false

func debugLog(_ message: @autoclosure () -> String) {
    if isDebuggingEnabled {
        print("[DEBUG] \(message())")
    }
}

let person = Person(name: "Bernie")
debugLog(person.description)


/*
     ___ _                         _                  _
    / __| |___ ____  _ _ _ ___    /_\  _ _ __ __ _ __| |___
   | (__| / _ (_-< || | '_/ -_)  / _ \| '_/ _/ _` / _` / -_)
    \___|_\___/__/\_,_|_| \___| /_/ \_\_| \__\__,_\__,_\___|
 
*/

/*
🕹 K times

Write a function named applyKTimes that takes an integer K and a closure and calls the closure K times. The closure will not take any parameters and will not have a return value.

> applyKTimes(K: 3, closure: { print("I heart Swift") })

*/

func applyKTimes(K times: Int, closure: () -> ()) {
    for i in 1...times {
        closure()
    }
}

applyKTimes(K: 3, closure: { print("🥵") })

/*

🕹 Div3

Use filter to create an array called multiples that contains all the multiples of 3 from a given array.
                 // Hint: Modulus Operator

// [3, 6, 9, 3, 12]

*/

let numbers = [1, 2, 3, 4, 6, 8, 9, 3, 12, 11]

let multiples = numbers.filter { $0 % 3 == 0 }


/*
🕹 Max

Find the largest number from numbers and then print it. Use reduce to solve this exercise.

*/

func max(_ array: [Int]) -> Int {
    return array.reduce(array[0]) {
        if $0 > $1 {
            return $0
        } else {
            return $1
        }
    }
}

max(numbers)

/*

🕹 Join

Join all the strings from strings into one using reduce. Add spaces in between strings. Print your result.

> var strings = ["We", "Heart", "Swift"]
> "We Heart Swift"

*/

func join(_ array: [String]) -> String{
    return array.reduce("") {
        if $0 == "" {
            return $1
        }
        return "\($0) \($1)"
    }
}

var strgs = ["We", "Heart", "Swift"]
join(strgs)

/*

🕹 Chains

Find the sum of the squares of all the odd numbers from numbers and then print it. Use map, filter and reduce to solve this problem.

> var numbers = [1, 2, 3, 4, 5, 6]
> 25 // 1 + 9 + 25 -> 25

*/

var xxO = [1, 2, 3, 4, 5, 6]

func chains(_ array: [Int]) -> Int {
    var arr = array.filter() { $0 % 2 == 1 }
    arr = arr.map { $0 * $0 } // a func map não é mutating e sim retorna o array mutado
    return arr.reduce(0) { $0 + $1 }
}

chains(xxO)
/*

🕹 For each

Implement a function forEach(array: [Int], _ closure: Int -> ()) that takes an array of integers and a closure and runs the closure for each element of the array.

var array = [1,2,3,4]
forEach(array) {
    print($0 + 1)
}
// This will be printed:
// 2
// 3
// 4

*/

func forEach(array: [Int], _ closure: (Int) -> ()) {
    array.map({ closure($0) })
}

forEach(array: numbers) { x in
    print("\(x)")
}

/*
🕹 Bonus: Combine arrays

Implement a function combineArrays that takes 2 arrays and a closure that combines 2 Ints into a single Int. The function combines the two arrays into a single array using the provided closure. Assume that the 2 arrays have equal length.

> var array1 = [1,2,3,4]
> var array2 = [5,5,5,3]

combineArrays(array1,array2) {
    $0 * $1
}

> [5,10,15,12]
 
*/

var array1 = [1,2,3,4]
var array2 = [5,5,5,3]

func combineArrays(_ array1: [Int], _ array2: [Int], closure: (Int, Int) -> (Int)) -> [Int] {
    var array3: [Int] = [];
    for (cont, num) in array1.enumerated() {
        array3.append(closure(num, array2[cont]))
    }
    return array3
}

combineArrays(array1,array2) {
    $0 * $1
}
