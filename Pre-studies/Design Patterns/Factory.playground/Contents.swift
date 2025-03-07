import Foundation

/// Factory

class Point: CustomStringConvertible {
    private var x, y: Double
    
    private init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
    
    private init(rho: Double, theta: Double) {
        x = rho * cos(theta)
        y = rho * sin(theta)
    }
    
//    static func createCartesian(x: Double, y: Double) -> Point {
//        // isso é um factory method
//        Point(x: x, y: y)
//    }
//    
//    static func createPolar(rho: Double, theta: Double) -> Point {
//        // isso também é um factory method
//        Point(rho: rho, theta: theta)
//    }
    
    var description: String {
        return "x = \(x), y =\(y)"
    }
    
    static let factory = PointInnerFactory.instance
    
    struct PointInnerFactory {
        // isso aqui é um inner factory
        // uma factory que funciona com encapsulamento
        private init() {}
        static let instance = PointInnerFactory()
        func createCartesian(x: Double, y: Double) -> Point {
            Point(x: x, y: y)
        }
        
        func createPolar(rho: Double, theta: Double) -> Point {
            Point(rho: rho, theta: theta)
        }
    }
}

class PointFactory {
    // isso aqui é um factory
    // organiza, mas tem o custo do encapsulamento
    func createCartesian(x: Double, y: Double) -> Point {
        Point.factory.createCartesian(x: x, y: y)
    }
    
    func createPolar(rho: Double, theta: Double) -> Point {
        Point.factory.createPolar(rho: rho, theta: theta)
    }
}

func mainFactory() {
    let f = PointFactory()
    let p = f.createCartesian(x: 12, y: 9)
    let p2 = f.createPolar(rho: 7, theta: 1)
}

// mainFactory()


/// Abstract Factory

protocol HotDrink {
    func consume()
}

class Tea: HotDrink {
    func consume() {
        print("It's four o'clock somewhere!")
    }
}

class Coffee: HotDrink {
    func consume() {
        print("At last, some caffeine!")
    }
}

protocol HotDrinkFactory {
    init()
    func prepare(amount:Int) -> HotDrink
}

class TeaFactory: HotDrinkFactory {
    required init() {}
    func prepare(amount: Int) -> HotDrink {
        print("Put in tea bag, boil water, pour \(amount)ml and enjoy!")
        return Tea()
    }
}

class CoffeeFactory: HotDrinkFactory {
    required init() {}
    func prepare(amount: Int) -> HotDrink {
        print("Grind some beans, boil water, pour \(amount)ml, add cream and enjoy!")
        return Coffee()
    }
}

class HotDrinkMachine {
    enum AvailableDrink: String { // quebra o OCP
        case coffee = "Coffee"
        case tea = "Tea"
        
        static let all = [coffee, tea]
    }
    
    internal var factories = [AvailableDrink: HotDrinkFactory]()
    
    internal var namedFactories = [(String, HotDrinkFactory)]()
    
    init() {
        for drink in AvailableDrink.all {
            let type: AnyClass? = NSClassFromString("Factory.\(drink.rawValue)Factory")
            let factory = (type as! HotDrinkFactory.Type).init()
            factories[drink] = factory
            namedFactories.append((drink.rawValue, factory))
        }
    }
    
    func makeDrink() -> HotDrink {
        print("Available drinks:")
        for i in 0..<namedFactories.count {
            print("\(i+1): \(namedFactories[i].0)")
        }
        let input = Int(readLine()!)!
        return namedFactories[input].1.prepare(amount: 250)
    }
}

func mainAbstractFactory() {
    let machine = HotDrinkMachine()
    print(machine.namedFactories.count)
    let drink = machine.makeDrink()
    drink.consume()
}
mainAbstractFactory()
