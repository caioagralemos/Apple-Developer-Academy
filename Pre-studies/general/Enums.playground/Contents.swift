// ### ENUMS ###

enum Compasso {
    case norte
    case sul
    case leste
    case oeste
    case nordeste, noroeste, sudeste, sudoeste // single line
}

var destino = Compasso.sudoeste
destino = .nordeste // ao reescolher ele infere o tipo

switch destino {
case .norte, .nordeste, .noroeste:
    print("Todos os planetas tem um norte")
default:
    print("É perigoso levar a vida sem um norte")
}

// Podem ter associate values (aqui os enums de swift se diferenciam), associando tuplas aos valores do enum
enum CodBarras {
    case upc(Int)
    case qrCode(String)
}

var productBarcode = CodBarras.upc(188293912)

switch productBarcode {
case .upc(let num):
    print("UPC code: \(num)")
case .qrCode(let str):
    print("QR code: \(str)")
}

// É possível associar valores puros
enum ASCIIControlCharacter: String {
    case tab = "\t"
    case lineFeed = "\n"
    case carriageReturn = "\r"
}

let espacador = ASCIIControlCharacter.tab.rawValue // é uma string com valor de "/t"

// pode pegar valores implicitos (de acordo com o tipo)
enum Planeta: Int {
    case mercurio = 1, venus, terra, marte, jupiter, saturno, urano, netuno // por mercurio ser 1, ele atribui valores automaticos (venus = 2, terra = 3, ...)
}

enum CompassoImplicito: String {
    case norte, sul, leste, oeste
}

let direcao = CompassoImplicito.norte.rawValue // "norte"
let terra = Planeta.terra.rawValue // 3

// enums não salvam stored properties mas podem ter computed properties
enum Device {
  case iPad
  case iPhone

  var year: Int {
    switch self {
      case .iPhone:
        return 2007
      case .iPad:
        return 2010
    }
  }
}

let device = Device.iPhone
print(device.year)

// enums podem ter métodos internos (assim como os externos vistos anteriormente, usando switch)
enum Character {
    enum Weapon {
        case bow
        case sword
        case dagger
    }
    
    case thief(weapon: Weapon)
    case warrior(weapon: Weapon)
    
    func getDescription() -> String {
        switch self {
        case let .thief(weapon):
            return "Thief escolheu \(weapon)"
        case let .warrior(weapon):
            return "Warrior escolheu \(weapon)"
        }
    }
}

let character1 = Character.warrior(weapon: .sword)
print(character1.getDescription())

// também é possível inicializar enums
enum IntCategory {
    case pequeno
    case medio
    case grande
    case estranho

    init(number: Int) {
        switch number {
        case 0..<1000 :
            self = .pequeno
        case 1000..<100000:
            self = .medio
        case 100000..<1000000:
            self = .grande
        default:
            self = .estranho
        }
    }
}

var intCategory = IntCategory(number: 34645)
print(intCategory)

// extensions podem adicionar métodos funcionais às enums
extension IntCategory {
    mutating func aumentar() {
        // tambem poderia ter sido definida direto no enum
        switch self {
        case .pequeno:
            self = .medio
        case .medio:
            self = .grande
        case .grande:
            self = .estranho
        default:
            self = .estranho
        }
    }
}

intCategory.aumentar()
print(intCategory)

// também é possivel usar generics
enum Information<T1, T2> {
    case name(T1)
    case website(T1)
    case age(T2)
}

let info = Information<String, Int>.name("Bob") // não consegue inferir


/*
  ___                    _                  _
 | __|_ _ _  _ _ __     /_\  _ _ __ __ _ __| |___
 | _|| ' \ || | '  \   / _ \| '_/ _/ _` / _` / -_)
 |___|_||_\_,_|_|_|_| /_/ \_\_| \__\__,_\__,_\___|

 */

/*
🕹 Grid Warrior
 
 You are a game designer in which your character is exploring a grid like map. You get the original location of the character and the steps he/she will take.
 
 Write the code, that will:
  - increment y + 1 if up
  - decrement y - 1 if down
  - increment x + 1 if right
  - decrement x - 1 if left
 
 Print the final location after all the steps have been taken
 
*/

enum Direction {
    case up
    case down
    case left
    case right
}

var location = (x: 0, y: 0)

var steps: [Direction] = [.up, .up, .left, .down, .left]

func walk(location: (Int, Int), steps: [Direction]) -> (Int, Int){
    var location = location
    for step in steps {
        switch step {
        case .up:
            location.0 += 1
        case .down:
            location.0 -= 1
        case .right:
            location.1 += 1
        case .left:
            location.1 -= 1
        }
    }
    return location
}

walk(location: location, steps: steps)

// your code here


/*
🕹 Rock, Paper, Scissors

 1) Define an enumeration named HandShape with three members: .rock, .paper, .scissors.
 2) Define an enumeration named MatchResult with three members: .win, .draw, .lose.
 3) Write a function called match that takes two hand shapes and returns a match result. It should return the outcome for the first player (the one with the first hand shape).
 */

enum HandShape: String {
    case rock, paper, scissors
    init(_ num: Int) {
        switch num {
        case 1:
            self = .rock
        case 2:
            self = .paper
        case 3:
            self = .scissors
        default:
            self = .paper
        }
    }
}

enum MatchResult {
    case win, draw, lose
}

func match(_ player: HandShape) -> MatchResult {
    var cpu = HandShape(Int.random(in: 1...3))
    if player == cpu {
        return MatchResult.draw
    } else {
        if (player.self == .paper && cpu.self == .rock) || (player.self == .rock && cpu.self == .scissors) || (player.self == .scissors && cpu.self == .rock) {
            return MatchResult.win
        } else {
            return MatchResult.lose
        }
    }
}

match(HandShape.scissors)
