// ### JSON ###
// Como manipular (codificar e descodificar) um json em swift

import Foundation
let json = """
    {
        "time": "Inter Miami",
        "nome": "Lionel Messi",
        "posicao": "PD",
        "numero": 10
    }
"""

// de JSON pra Swift

struct Jogador: Codable { // tem que herdar o protocolo codable
    let time: String
    let nome: String
    let posicao: String
    let numero: Int
}

let jsonData = json.data(using: .utf8)!
let resultado = try! JSONDecoder().decode(Jogador.self, from: jsonData)
resultado


// de Swift pra JSON

var jogador = Jogador(time: "Fluminense", nome: "John Kennedy", posicao: "ATA", numero: 9)

let jsonData2 = try! JSONEncoder().encode(jogador)
let json2 = String(data: jsonData2, encoding: .utf8)!

// Se o nome das propriedades diferir entre os dois, utilizamos CodingKeys

struct Usuario: Codable { // O codable decripta automaticamente a maioria dos tipos
    var primeiroNome: String
    var segundoNome: String
    var pais: String
    
    enum CodingKeys: String, CodingKey {
        case primeiroNome = "primeiro_nome"
        case segundoNome = "segundo_nome"
        case pais
    }
}

let usuarioJson = """
{
    "primeiro_nome": "Caio",
    "segundo_nome": "Lemos",
    "pais": "Brasil"
}
"""

let usuarioJsonData = usuarioJson.data(using: .utf8)!
let usuario = try! JSONDecoder().decode(Usuario.self, from: usuarioJsonData)
usuario

// Trabalhando com Datas

// Se tiver em milissegundos, é o padrão do swift
let jsonMs = """
{
  "date" : 519751611.12542897
}
"""

struct DateRecord : Codable {
    let date: Date
}

let msData = jsonMs.data(using: .utf8)!
let msResult = try! JSONDecoder().decode(DateRecord.self, from: msData)
msResult.date

// Se tiver em iso8601 use dateEncodingStrategy.

let jsonIso = """
{
  "date" : "2017-06-21T15:29:32Z"
}
"""

let isoData = jsonIso.data(using: .utf8)!
let isoDecoder = JSONDecoder()
isoDecoder.dateDecodingStrategy = .iso8601
let isoResult = try! isoDecoder.decode(DateRecord.self, from: isoData)
isoResult.date

// Se for sem padrão use `DateFormatter` pra criar seu próprio formato.

let jsonNS = """
{
  "date" : "2020-03-19"
}
"""

// criando formato proprio
extension DateFormatter {
  static let yyyyMMdd: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    formatter.calendar = Calendar(identifier: .iso8601)
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    return formatter
  }()
}

let nsData = jsonNS.data(using: .utf8)!
let nsDecoder = JSONDecoder()
nsDecoder.dateDecodingStrategy = .formatted(DateFormatter.yyyyMMdd)
let nsResult = try! nsDecoder.decode(DateRecord.self, from: nsData)
nsResult.date

// tipo Result<Success, Failure>

/*
let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!

struct Post: Decodable {
    let title: String
    let body: String
}

enum NetworkError: Error {
    case domainError
    case decodingError
}

func fetchPosts(url: URL, completion: @escaping (Result<[Post],NetworkError>) -> Void) {

    URLSession.shared.dataTask(with: url) { data, response, error in

        guard let data = data, error == nil else {
            if let error = error as NSError?, error.domain == NSURLErrorDomain {
                    completion(.failure(.domainError))
            }
            return
        }

        do {
            let posts = try JSONDecoder().decode([Post].self, from: data)
            completion(.success(posts))
        } catch {
            completion(.failure(.decodingError))
        }

    }.resume()

}

fetchPosts(url: url) { result in
    switch result {
    case .success(let posts):
        print(posts)
    case .failure(let error):
        print(error.localizedDescription)
    }
}
*/

/*
     _ ___  ___  _  _     _                  _
  _ | / __|/ _ \| \| |   /_\  _ _ __ __ _ __| |___
 | || \__ \ (_) | .` |  / _ \| '_/ _/ _` / _` / -_)
  \__/|___/\___/|_|\_| /_/ \_\_| \__\__,_\__,_\___|

 */

/*
🕹 Find the base.
 
 Create a Swift struct called `Coordinate` capable of decoding the incoming JSON message.

 */

let json1 = """
{
    "latitude": 44.4,
    "longitude": 55.5,
}
"""

struct Coordinate: Codable {
    let latitude: Double
    let longitude: Double
}

let json1data = json1.data(using: .utf8)!
let coordinate = try! JSONDecoder().decode(Coordinate.self, from: json1data)


/*
🕹 Associate it with a Planet.
 
 Create a Swift struct called `Planet` to include the following coordinate.

 */

let json3 = """
 {
     "name": "Tatooine",
     "foundingYear": 1977,
     "location": {
         "latitude": 44.4,
         "longitude": 55.5,
     },
 }
"""

struct Planet: Codable {
    let name: String
    let foundingYear: Int
    let location: Coordinate
}

let json3data = json3.data(using: .utf8)!
let tatooine = try! JSONDecoder().decode(Planet.self, from: json3data)


/*
🕹 Use the force.
 
 Alter the `Planet` struct we just created so it can handle
 
 case name = "planet_name"
 case foundingYear = "founding_year"
 
 */

let json4 = """
 {
     "planet_name": "Tatooine",
     "founding_year": 1977,
     "location": {
         "latitude": 44.4,
         "longitude": 55.5,
     },
 }
"""

struct OtherPlanet: Codable {
    let name: String
    let foundingYear: Int
    let location: Coordinate
    
    enum CodingKeys: String, CodingKey {
        case name = "planet_name"
        case foundingYear = "founding_year"
        case location
    }
}

let json4data = json4.data(using: .utf8)!
let tatooine2 = try! JSONDecoder().decode(OtherPlanet.self, from: json4data)
