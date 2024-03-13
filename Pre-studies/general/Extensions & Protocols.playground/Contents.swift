// ### EXTENSIONS ###
// Extensões adicionam novas funcionalidades (métodos) a tipos. Não só a classes, structs, enums etc mas também a Int, String, Bool etc

struct Person {
    var name: String = "Fulano";
}

extension Person {
    // var sobrenome: String = "da Silva" Extensions must not contain stored properties
    var endereco: String {
        return "Moro na minha casa"
    }
    
    func correr() {
        print("\(self.name) corre!")
    }
}

var eu = Person(name: "Caio")
eu.correr()

// fazendo em tipos nativos
extension Double {
    var km: Double { return self * 1000.0 }
    var m: Double { return self }
    var cm: Double { return self / 100.0 }
    var mm: Double { return self / 1000.0 }
}

let umCm = 1.cm
let dezMetros = 10.m

extension Int {
    func repeticoes(task: () -> Void) {
        for _ in 0..<self {
            task()
        }
    }
    
    mutating func square() {
        self = self * self
    }
}

3.repeticoes {
    print("Olá")
}

var num = 7
num.square()
num

// tipos aninhados - extensions podem adicionar novos tipos dentro de tipos
extension Int {
    enum Kind {
        case negative, zero, positive
    }
    
    var kind: Kind {
        if self > 0 {
            return .positive
        } else if self < 0 {
            return .negative
        } else {
            return .zero
        }
    }
}

(-73).kind

// você pode definir inits em extensões
struct Ponto {
    let x: Int
    let y: Int
}

extension Ponto {
    init(reversed point: Ponto) {
        self.x = -point.x
        self.y = -point.y
    }
}

let pontoPositivo = Ponto(x: 7, y: 9) // default initializer
let pontoNegativo = Ponto(reversed: pontoPositivo) // convenient initializer

// ### PROTOCOLS ###
// Como interfaces em Java, quando você conforma a um protocolo, você diz que essa classe/struct/enum vai ter que ter todos os metodos definidos por esse protocolo. Além disso, protocolos permitem polimorfismo

protocol Fillable {
    var level: Int { get set } // aceita computed values (precisa especificar se get e/ou set)
    mutating func fill(howMuch v: Int) // métodos
    mutating func pour(howMuch v: Int) // usamos a keyword mutating se formos alterar os valores das variáveis
}

// pode usar extensions para implementar as funcs

extension Fillable {
    mutating func fill(howMuch v: Int) { // tudo que implementar o protocolo vai ter essa func funcional
        level = min(100, v)
    }
}

// Ou você pode implementar nas structs/classes específicas

struct Balde: Fillable {
    var level: Int = 0
    mutating func pour(howMuch v: Int) { //
        level = level - v
    }
}

var metal = Balde()
metal.level
metal.fill(howMuch: 120)

// Se você tem uma classe/struct que já se enquadra no protocolo e quer tipar-la de acordo, é possível

protocol Growable {
    var age: Int { get }
}

class Hobbit {
    var age = 111
}

extension Hobbit: Growable {}

func mostrarIdadeHobbit(hobbit: Growable & Hobbit) { // é possível combinar tipos como classe, protocolo e struct para reforçar
    print(hobbit.age)
}

struct Human: Growable {
    var age: Int = 0;
}

var caio = Human(age: 20)
let bilbo = Hobbit()

// mostrarIdadeHobbit(hobbit: caio) Cannot convert value of type 'Human' to expected argument type 'Hobbit'
mostrarIdadeHobbit(hobbit: bilbo)

// Protocol conformance - conformar um objeto de uma subclasse pra uma superclass

let isGrowable = bilbo is Growable // true if conforms to protocol

class Dwarf {}
class MountainDwarf: Dwarf {}

let gimli = MountainDwarf()

let aDwarf = gimli as? Dwarf // downcasts gimil > Dwarf
let notADwarf = bilbo as? Dwarf // nil

/*

 ___         _               _     _                  _
| _ \_ _ ___| |_ ___  __ ___| |   /_\  _ _ __ __ _ __| |___
|  _/ '_/ _ \  _/ _ \/ _/ _ \ |  / _ \| '_/ _/ _` / _` / -_)
|_| |_| \___/\__\___/\__\___/_| /_/ \_\_| \__\__,_\__,_\___|

*/

/*
 🕹️ Moveable Player.
*/

//Given

struct Point {
    let x: Int
    let y: Int
    
    init (_ x: Int, _ y: Int)  {
        self.x = x
        self.y = y
    }
}

struct Player {
    var position = Point(0,0)
}

// 1. Define an enum called `Direction` that allows a player to move left, right, up, and down

enum Direction {
    case up, down, left, right
}

// 2. Create a protocol called `Moveable` with two methods:
//  - func move(_ direction: Direction)
//  - func coordinates() -> String

protocol Moveable {
    mutating func move(_ direction: Direction)
    func coordinates() -> String
}

// 3. Make `Player` conform to the `Moveable` protocol via a protocol extension.

extension Player: Moveable {
    mutating func move(_ direction: Direction) {
        switch direction {
        case .up:
            let x = self.position.x
            let y = self.position.y + 1
            self.position = Point(x, y)
        case .down:
            let x = self.position.x
            let y = self.position.y - 1
            self.position = Point(x, y)
        case .left:
            let x = self.position.x - 1
            let y = self.position.y
            self.position = Point(x, y)
        case .right:
            let x = self.position.x + 1
            let y = self.position.y
            self.position = Point(x, y)
        }
    }
    
    func coordinates() -> String {
        return "(\(self.position.x), \(self.position.y))"
    }
}

var jogador = Player()
jogador.coordinates()
jogador.move(.left)
jogador.move(.left)
jogador.move(.down)
jogador.move(.up)
jogador.move(.up)
jogador.coordinates()

/*
   ___         _               _   ___      _               _
  | _ \_ _ ___| |_ ___  __ ___| | |   \ ___| |___ __ _ __ _| |_ ___
  |  _/ '_/ _ \  _/ _ \/ _/ _ \ | | |) / -_) / -_) _` / _` |  _/ -_)
  |_| |_| \___/\__\___/\__\___/_| |___/\___|_\___\__, \__,_|\__\___|
                                                 |___/
                        _                  _
                       /_\  _ _ __ __ _ __| |___
                      / _ \| '_/ _/ _` / _` / -_)
                     /_/ \_\_| \__\__,_\__,_\___|
 */

/*
 protocol WeatherServiceDelegate: AnyObject {
     func didFetchWeather(weather: String)
 }

 struct WeatherService {
     weak var delegate: WeatherServiceDelegate?
     
     func fetchWeather() {
         // asynchronous...
         delegate?.didFetchWeather(weather: "22")
     }
 }

 override func viewDidLoad() {
     super.viewDidLoad()
     weatherService.delegate = self // key!
     setupViews()
 }

 extension ViewController: WeatherServiceDelegate {
     func didFetchWeather(weather: String) {
         label.text = weather
     }
 }
 */

/*
🕹 Death Star
 
 Using the Protocol Delegate pattern, create a service that informs General Tarkin in the Command Center when the Death Star's primary canon is ready to fire.
 
 In no particular order you will need to:
  - Create the protocol.
  - Create the service.
  - Create the Command Center.
  - Register the Command Center delegate with the service.
  - Make the Command Center conform to the protocol.
  - Fire the canon! (via a print statement).

 */


protocol DeathStarDelegate {
    func readyToFire()
}

struct DeathStarCannon {
    var delegate: DeathStarDelegate?
    
    func chargeCannon() {
        // asynchronous...
        delegate?.readyToFire()
    }
}

struct CommandCenter {
    var service = DeathStarCannon()
    
    init() {
        service.delegate = self
    }
    
    func fireWhenReady() {
        service.chargeCannon()
    }
    
    private func fire() {
        print("silent boom as there are no sound in space")
    }
}

extension CommandCenter: DeathStarDelegate {
    func readyToFire() {
        fire()
    }
}

var deathStar = CommandCenter()
deathStar.fireWhenReady()
