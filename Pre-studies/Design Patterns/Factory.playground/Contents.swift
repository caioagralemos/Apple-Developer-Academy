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

mainFactory()
