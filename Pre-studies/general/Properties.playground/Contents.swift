// ### PROPRIEDADES ##
// Temos dois tipos de propriedades em Swift, são elas: Computed e Stored

struct S {
    // Stored Properties
    var name: String = "Caio"; // Stored, armazenado na memória
    
    lazy var nacionality: String = "Brasil" { // lazy: o valor só é atribuído quando é chamado pela primeira vez
        // Property Observers
        willSet {
            print("A nacionalidade de \(self.name) vai mudar pra \(newValue)")
        }
        didSet {
            print("A nacionalidade de \(self.name) mudou de \(oldValue) pra \(self.nacionality)")
        }
    }
    
    // Computed Properties
    var age: Int { // Computed, calculado ao ser chamado
        return 2024 - 2003
    }
    
    private var _stored = "stored"

    // Short hand - algo como um wrapper
    var shortHand: String {
        get {
            return _stored
        }
        set {
            _stored = newValue
        }
    }
    
}


var caio = S.init()
caio.nacionality = "Italia"

/*
  ___                       _            _                  _
 | _ \_ _ ___ _ __  ___ _ _| |_ _  _    /_\  _ _ __ __ _ __| |___
 |  _/ '_/ _ \ '_ \/ -_) '_|  _| || |  / _ \| '_/ _/ _` / _` / -_)
 |_| |_| \___/ .__/\___|_|  \__|\_, | /_/ \_\_| \__\__,_\__,_\___|
             |_|                |__/

 */

 import Foundation

/*
🕹 Dog years

   Create a struct called person, with a storied property of type Int called age, and then add a computed property called ageInDogYears of type Int that returns the age of the person in dog years (age * 7).
 */

struct Person {
    var age: Int
    var ageInDogYears: Int {
        return age * 7
    }
}


/*
🕹 isEquilateral

    Given the following Triangle stucture, write a computed property that determines whether the sides of the triangle are equilateral (all three sides are equal).

    var isEquilateral: Bool {
        return ?
    }

 */

struct Triangle {
    var s1: Double
    var s2: Double
    var s3: Double
    
    init(s1: Double, s2: Double, s3: Double) {
        self.s1 = s1
        self.s2 = s2
        self.s3 = s3
    }
    
    var isEquilateral: Bool {
        return self.s1 == self.s2 && self.s2 == self.s3
    }
}

var equilatero = Triangle(s1: 4.0, s2: 4.0, s3: 4.0)
if equilatero.isEquilateral {
    print("É equilátero")
}


/*
🕹 Title in the Post

 Add a property observer stored property title that trims white space and new lines when the title stored property is set.

 > struct Post
 > var title: String
 > title.trimmingCharacters(in: .whitespacesAndNewlines)

 */

struct Post {
    var title: String {
        didSet {
            title = title.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
}

var post = Post(title: "Oala ")
post.title = "Fui roubado na Gustavo Paiva   "


/*
🕹 Observe the radius

    Define a class of type Circle. Give it a stored property `radius` of type `Double`.
    And use the `didSet` property observer to ensure no negative values get assigned to radius.
    If negative number, assign radius value of 0.

 */

class Circle {
    var radius: Double {
        didSet {
            radius = max(radius, 0)
        }
    }
    
    init(radius: Double) {
        self.radius = max(radius, 0)
    }
    
    var area: Double {
        get {
            return radius * radius * Double.pi
        }
        set (newArea) {
            self.radius = sqrt(newArea/Double.pi)
        }
    }
}


var circulo = Circle(radius: -1)
circulo.radius = 12

/*
🕹 Compute the area

 Building on the previous example, calculate the circles area as a computed property.

 Hint: area = radius * radius * Double.pi

 */

print(circulo.area)


/*
🕹 Set the radius via the square root.

    Building on previous question, add a setter to the computed property area. When the area is set, have it set the stored property radius.
 */

circulo.area = 120

// Property Wrappers
// São uma camada extra de verificação entre armazenamento e processamento

@propertyWrapper
struct TwelveOrLess {
    private var number = 0 // private
    var wrappedValue: Int {
        get { return number }
        set { number = min(newValue, 12) }
    }
}

struct SmallRectangle {
    @TwelveOrLess var height: Int
    @TwelveOrLess var width: Int
}

var rectangle = SmallRectangle()
rectangle.height = 33 // seta a height como 12
rectangle.width = 10

