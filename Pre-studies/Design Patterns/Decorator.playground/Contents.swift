import Foundation

class CodeBuilder: CustomStringConvertible {
    private var buffer = ""
    
    init() {}
    init(_ buffer: String) {
        self.buffer = buffer
    }
    
    func append(_ s: String) -> CodeBuilder {
        buffer.append(s)
        return self
    }
    
    func appendLine(_ s: String) -> CodeBuilder {
        buffer.append("\(s)\n")
        return self
    }
    
    static func +=(cb: inout CodeBuilder, s: String) {
        cb.buffer.append(s)
    }
    
    var description: String {
        return buffer
    }
}

func mainDecorator() {
    var cb = CodeBuilder()
    
    cb.appendLine("Class Foo {")
    cb += " // testing!\n"
    cb.appendLine("}")
    
    print(cb)
}

mainDecorator()

/// Multiple Inheritance

//class Bird {
//    func fly() {}
//}
//
//class Lizard {
//    func crawl() {}
//}
//
//class Dragon {
//    // swift nao suporta multipla heranca, precisamos fazer isso
//    private let bird = Bird()
//    private let lizard = Lizard()
//    
//    func fly() {
//        bird.fly() // delegation
//    }
//    
//    func crawl() {
//        lizard.crawl()
//    }
//}

/// Dynamic Decorator

protocol Shape: CustomStringConvertible {
    var description: String { get }
    init()
}

class Circle: Shape {
    private var radius: Float = 0
    
    init(_ radius: Float) {
        self.radius = radius
    }
    required init() {}
    
    func resize(_ factor: Float) {
        radius *= factor
    }
    
    var description: String {
        return "A circle of radius \(radius)"
    }
}

class Square: Shape {
    private var side: Float = 0
    
    init(_ side: Float) {
        self.side = side
    }
    required init() {}
    
    var description: String {
        return "A square of side \(side)"
    }
}

class ColoredShape<T>: Shape where T: Shape {
    // 2. faco isso
    private var shape: T = T()
    private var color: String = "black"
    
    init(_ color: String) {
        self.color = color
    }
    
    required init() {}
    
    var description: String {
        return "\(shape) has color \(color)"
    }
    // isso aqui é um decorator
}

class TransparentShape<T>: Shape where T: Shape {
    private var shape: T = T()
    private var transparency: Float = 1
    
    init(_ transparency: Float) {
        self.transparency = transparency
    }
    
    required init() {}
    
    var description: String {
        return "\(shape) has \(transparency*100)% transparency"
    }
}

func dynamicDecoratorMain() {
    let square = Square(1.23)
    print(square)
    // 1. quero adicionar uma cor no quadrado, como faço?
}

dynamicDecoratorMain()

func staticDecoratorMain() {
    let blueCircle = ColoredShape<Circle>("blue")
    print(blueCircle)
    
    let blackHalfSquare = TransparentShape<ColoredShape<Square>>(0.4) // limitacao, nao podemos especificar a cor
    print(blackHalfSquare)
}

staticDecoratorMain()

/// Exercise

class Bird
{
  var age = 0

  func fly() -> String
  {
    return (age < 10) ? "flying" : "too old"
  }
}

class Lizard
{
  var age = 0

  func crawl() -> String
  {
    return (age > 1) ? "crawling" : "too young"
  }
}

class Dragon
{
  private var bird = Bird()
  private var lizard = Lizard()

  var age: Int {
    get {
        return bird.age
    }
    set(value) {
        bird.age = value
        lizard.age = value
    }
  }
  func fly() -> String { return bird.fly() }
  func crawl() -> String { return lizard.crawl() }
}
