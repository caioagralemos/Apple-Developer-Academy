import Foundation

class SingletonDatabase {
    private var capitals = [String: Int]()
    nonisolated(unsafe) static var instanceCount = 0
    
    // isso aqui é um singleton
    nonisolated(unsafe) static let instance = SingletonDatabase()
    
    private init() {
        Self.instanceCount += 1
        print("initializing db")
        
        let str = """
        Tokyo
        33200000
        New York
        17800000
        Sao Paulo
        17700000
        Seoul
        17500000
        Mexico City
        17400000
        Osaka
        16425000
        Manila
        14750000
        Mumbai
        14350000
        """
        
        let string = str.components(separatedBy: .newlines)
            .filter {!$0.isEmpty}
            .map { $0.trimmingCharacters(in: .whitespaces) }
        
        for i in 0..<(string.count/2) {
            capitals[string[i*2]] = Int(string[i*2+1])!
        }
    }
    
    func getPopulation(_ name: String) -> Int {
        return capitals[name]!
    }
}

class SingletonRecordFinder {
    func totalPopulation(_ names: [String]) -> Int {
        var result = 0
        for name in names {
            result += SingletonDatabase.instance.getPopulation(name)
        }
        return result
    }
}


func mainSingleton() {
    let db = SingletonDatabase.instance
    var city = "Tokyo"
    print("\(city) has population of \(db.getPopulation(city))")
    
    let db2 = SingletonDatabase.instance
    city = "Manila"
    print("\(city) has population of \(db2.getPopulation(city))")
    print(SingletonDatabase.instanceCount)
}

mainSingleton()

/// Monostate - not a good idea
class CEO: CustomStringConvertible {
    nonisolated(unsafe) private static var _name  = ""
    nonisolated(unsafe) private static var _age = 0
    
    var name: String {
        get { return Self._name }
        set(value) { Self._name = value }
    }
    
    var age: Int {
        get { return Self._age }
        set(value) { Self._age = value }
    }
    
    var description: String {
        return "Our CEO is \(Self._name), \(Self._age) years old."
    }
}

func mainMonostate() {
    var ceo = CEO()
    ceo.name = "Adam Smith"
    ceo.age = 55
    
    var ceo2 = CEO()
    ceo2.age = 64
    
    print(ceo)
}

mainMonostate()

/// Exercise
class SingletonTester
{
  static func isSingleton(factory: () -> AnyObject) -> Bool
  {
    let object = factory()
    let object2 = factory()
    return object === object2
  }
}
