import Foundation

protocol Copying {
    // permite criar prototipos em classes, tipos de referencia
    init(copyFrom other: Self)
    func clone() -> Self
}

class Address: CustomStringConvertible, Copying {
    var streetAddress, city: String
    
    init(_ streetAddress: String, _ city: String) {
        self.streetAddress = streetAddress
        self.city = city
    }
    
    required init(copyFrom other: Address) {
        self.streetAddress = other.streetAddress
        self.city = other.city
    }
    
    var description: String {
        return "\(streetAddress), \(city)"
    }
    
    func clone() -> Self {
        return self
    }
}

class Employee: CustomStringConvertible, Copying {
    var name: String
    var address: Address
    
    init(_ name: String, _ address: Address) {
        self.name = name
        self.address = address
    }
    
    required init(copyFrom other: Employee) {
        self.name = other.name
        self.address = other.address
    }
    
    var description: String {
        return "My name is \(name) and I live in \(address)."
    }
    
    func clone() -> Self {
        return self
    }
}


func mainPrototype() {
    var john = Employee("John", Address("123 One World St", "New York City"))
    print(john)
    
    var chris = Employee(copyFrom: john) // criando um prototipo
    chris.name = "Chris"
    print(chris)
    
    var max = chris.clone()
    max.name = "Max"
    print(max)
}

mainPrototype()

class Point {
    var x = 0
    var y = 0

    init() {}

    init(x: Int, y: Int) {
        self.x = x
        self.y = y
  }
}

class Line {
    var start = Point()
    var end = Point()

    init(start: Point, end: Point) {
        self.start = start
        self.end = end
  }

    func deepCopy() -> Line {
        return Line(start: self.start, end: self.end)
  }
}

func prototypeExercise() {
    let lineA = Line(start: Point(x: 1, y: 4), end: Point(x: 5, y: 9))
    var lineB = lineA.deepCopy()
}

prototypeExercise()
