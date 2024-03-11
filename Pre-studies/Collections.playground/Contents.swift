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

// map, filter e reduce (voltar quando aprender closures)

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
