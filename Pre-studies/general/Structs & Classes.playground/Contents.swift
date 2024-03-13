// ### Structs & Classes ###

// Functional Programming - alguns termos básicos
func double(_ value: Int) -> Int {
    // Função pura (não salva nada em seu próprio escopo)
    return value * 2
}

let doubled = double(2)

// Immutabilidade
let imutavel = "unchangeable"

var numbers = [1,2,3,4,5,6]

// Programação Declarativa x Imperativa
func doubleValue(_ numbers: [Int]) -> [Int] { // declarativa (declara funções)
    var result = [Int]()
    for number in numbers {
        result.append(number * 2)
    }
    return result
}

let imperative = doubleValue(numbers)

let declarative = numbers.map { $0 * 2 } // imperative

// Diferenças entre Structs & Classes
// 1. Structs são implementadas em Stacks (muito rápidas e com baixa complexidade) enquanto Classes são implementadas em Heaps (mais lentas e com alta complexidade)

// 2. Structs não possuem herança (nesse caso, utilizar protocolos e extensões)
struct StructA {}
// struct StructB: StructA {}

// 3. Structs te dão um inicializador padrão
struct Resolution {
    var width = 0
    var height = 0
}

let vga = Resolution(width: 640, height: 480)

// 4. Structs são value types. Classes são reference types.
var ps2 = vga
ps2.width = 720

vga
ps2

class Animal {
    var genero: String
    var especie: String
    
    init(genero: String, especie: String) {
        self.genero = genero
        self.especie = especie
    }
}

var cachorro = Animal(genero: "Macho", especie: "Canis lupus")
var canino = cachorro
canino.genero = "Fêmea"

canino.genero
cachorro.genero

// 5. Classes tem operadores de identificação (===) pra checar se as vars se referem a mesma instância
if canino === cachorro {
    print("Canino e Cachorro referenciam a mesma instância.")
}

// Inicializadores (init)
struct Color { // structs tem inits auto atribuidos
    let red, green, blue: Double
}

let magenta = Color(red: 1.0, green: 0.0, blue: 1.0)

class Post {
    var title: String
    var content: String
    var user: String
    init(title: String, content: String, user: String) { // é necessário atribuir o init para os valores não opcionais
        self.title = title
        self.content = content
        self.user = user
    }
}
