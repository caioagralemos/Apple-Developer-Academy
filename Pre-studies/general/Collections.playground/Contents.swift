// ### Arrays ###

// declarando array vazio
let arrayVazio = [Int]()

// declarando array na vera
var equipes = ["Red Bull Racing", "Ferrari", "McLaren", "Mercedes", "Aston Martin", "Haas", "Alpine", "Williams", "RB", "Stake"]

// acessando
equipes.count
equipes.isEmpty
equipes.append("Audi")
equipes += ["Andretti"]
let campea = equipes.first
equipes[11]

// removendo
equipes.removeLast()
equipes.remove(at: 9)


// iterando
for equipe in equipes {}
for (contador, equipe) in equipes.enumerated() {
    print("O carro da \(equipe) atingiu a linha de chegada em \(contador+1)º lugar!")
}

// Map
var numbers2 = [1, 2, 3]
var strings2 = numbers2.map { "\($0)" } // closure

// Filter
var numbers3 = [1, 2, 3, 4, 5, 6, 7, 8]
var evenNumbers = numbers3.filter { $0 % 2 == 0 } // [2, 4, 6, 8]

// Reduce
var numbers4 = [1, 2, 3, 4, 5]
var sum = numbers4.reduce(0) { $0 + $1 } // 15

// ### Dicionários ###

// declarando dicionario vazio
var dicionario = [Int: String]()

// adicionando algo
dicionario[1] = "Max Verstappen"

// zerando dicionario
dicionario = [:]

var aeroportos = ["MCZ" : "Aeroporto Internacional Zumbi dos Palmares", "GRU": "Aeroporto Internacional Rio-Galeão", "GUA" : "Guarulhos"]

aeroportos["NAP"] = "Aeroporto Internacional de Nápoles"
aeroportos["GUA"] = "Aeroporto Internacional de SP"
let oldValue = aeroportos.updateValue("Aeroporto Internacional de Guarulhos", forKey: "GUA")

// iterando dicionarios
print("\nAeroportos")
for (airportCode, airportName) in aeroportos {
    print("\(airportCode) - \(airportName)")
}
