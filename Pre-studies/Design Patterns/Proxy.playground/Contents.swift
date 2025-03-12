import Foundation

/// Protection Proxy

protocol Vehicle {
    func drive()
}

class Car: Vehicle {
    func drive() {
        print("Driving")
    }
}

class CarProxy: Vehicle {
    // um proxy que pega uma classe que não se importa e define uma interface pra ele
    private let car = Car()
    private let driver: Driver
    
    init(driver: Driver) {
        self.driver = driver
    }
    
    func drive() {
        if driver.age >= 18 {
            car.drive()
        } else {
            print("You are not old enough to drive!")
        }
    }
}

class Driver {
    var name: String
    var age: Int
    
    init(_ name: String, _ age: Int) {
        self.name = name
        self.age = age
    }
}

func mainProtectionProxy() {
    let car = CarProxy(driver: Driver("Caio", 17))
    car.drive()
}

mainProtectionProxy()

/// Property Proxy

class Property<T: Equatable> {
    private var _value: T
    
    public var value: T {
        get { return _value }
        set(value) {
            if value == _value {
                print("value already set!")
            } else {
                _value = value
            }
        }
    }
    
    init(_ value: T) {
        self._value = value
    }
}

extension Property: Equatable {}
func == <T>(lhs: Property<T>, rhs: Property<T>) -> Bool {
    lhs.value == rhs.value
}

class Creature {
    private let _agility = Property<Int>(100)
    var agility: Int {
        get { return _agility.value }
        set(value) { _agility.value = value }
    }
}

func propertyProxyMain() {
    let c = Creature()
    c.agility = 10
    print(c.agility)
}

propertyProxyMain()


/// Exercise

class Person
{
  var age: Int = 0

  func drink() -> String
  {
    return "drinking"
  }

  func drive() -> String
  {
    return "driving"
  }

  func drinkAndDrive() -> String
  {
    return "driving while drunk"
  }
}

class ResponsiblePerson {
    private let person: Person
    var age: Int {
        get {
            return person.age
        }
        set(value) {
            person.age = value
        }
    }

      init(person: Person) {
        self.person = person
      }

      func drink() -> String {
          if person.age > 17 {
              return person.drink()
          } else {
              return "too young"
          }
      }

      func drive() -> String {
          if person.age > 15 {
              return person.drive()
          } else {
              return "too young"
          }
      }

      func drinkAndDrive() -> String{
          return "dead"
      }
}
