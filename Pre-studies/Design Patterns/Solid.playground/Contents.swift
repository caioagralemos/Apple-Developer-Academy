import Foundation

/// Single Responsability Principle
class Journal: CustomStringConvertible {
    var entries: [String] = []
    var count: Int {
        entries.count
    }
    
    func addEntry(_ text: String) -> Int {
        entries.append(text)
        return count-1
    }
    
    func removeEntry(_ index: Int) {
        entries.remove(at: index)
    }
    
    var description: String {
        entries.joined(separator: "\n")
    }
    
    // ao inves de colocar funcoes de persistencia aqui
    // criar uma classe unica so pra trabalhar isso
    // assim, mantendo a classe com uma unica responsabilidade
}

class Persistance {
    func save(_ journal: Journal, _ fileName: String) {}
    func load(_ filename: String) -> Journal { return Journal() }
}

func mainSRP() {
    let j = Journal()
    j.addEntry("Eu chorei de rir hoje")
    let bug = j.addEntry("Eu comi um besouro hoje")
    print(j)

    j.removeEntry(bug)
    print(j)
}
// mainSRP()

/// Open Closed Principle
enum Color {
    case red, green, blue
}

enum Size {
    case small, medium, large, yuge
}

class Product: CustomStringConvertible {
    var name: String
    var color: Color
    var size: Size
    
    init(_ name: String, _ color: Color, _ size: Size) {
        self.name = name
        self.color = color
        self.size = size
    }
    
    var description: String {
        "\(self.size) \(self.color) \(self.name)"
    }
}

class ProductFilter {
    func filterByColor(_ products: [Product], _ color: Color) -> [Product] {
        return products.filter({$0.color == color})
    }
}

protocol Specification {
    associatedtype T
    func isSatisfied(_ item: T) -> Bool
}

protocol Filter {
    associatedtype T
    func filter<Spec: Specification>(_ itens: [T], _ spec: Spec) -> [T]
        where Spec.T == T;
}

class ColorSpecification: Specification {
    func isSatisfied(_ item: Product) -> Bool {
        item.color == self.color
    }
    
    typealias T = Product
    let color: Color
    init(color: Color) {
        self.color = color
    }
}

class SizeSpecification: Specification {
    func isSatisfied(_ item: Product) -> Bool {
        item.size == self.size
    }
    
    typealias T = Product
    let size: Size
    init(size: Size) {
        self.size = size
    }
}

class AndSpecification<T, SpecA: Specification, SpecB: Specification>: Specification where SpecA.T == SpecB.T, SpecA.T == T, SpecB.T == T {
    let first: SpecA
    let second: SpecB
    
    init(_ first: SpecA, _ second: SpecB) {
        self.first = first
        self.second = second
    }
    
    func isSatisfied(_ item: T) -> Bool {
        first.isSatisfied(item) && second.isSatisfied(item)
    }
}

class BetterFilter: Filter {
    typealias T = Product
    
    func filter<Spec: Specification>(_ itens: [Product], _ spec: Spec) -> [T] where Spec.T == T {
        return itens.filter({spec.isSatisfied($0)})
    }
}

func mainOCP() {
    let apple = Product("Apple", .green, .small)
    let tree = Product("Tree", .green, .large)
    let house = Product("House", .blue, .yuge)
    
    let products = [apple, tree, house]
    
    print(BetterFilter().filter(products, ColorSpecification(color: .green)))
    print(BetterFilter().filter(products, AndSpecification(ColorSpecification(color: .blue), SizeSpecification(size: .yuge))))
}
//mainOCP()

/// Liskov Substitution Principle
class Rectangle: CustomStringConvertible {
    fileprivate var _width = 0
    fileprivate var _height = 0
    
    var width: Int {
        get { return _width }
        set(value) { _width = value }
    }
    
    var height: Int {
        get { return _height }
        set(value) { _height = value }
    }
    
    var description: String {
        "\(width)x\(height) sized rectangle."
    }
    
    init() {}
    init(_ width: Int, _ height: Int) {
        self._width = width
        self._height = height
    }
    
    var area: Int {
        width*height
    }
}

class Square: Rectangle {
    override var width: Int {
        get { return self._width }
        set(value) {
            self._width = value
            self._height = value
        }
    }
    
    override var height: Int {
        get { return self._height }
        set(value) {
            self._height = value
            self._width = value
        }
    }
}

func setAndMeasure(_ rc: Rectangle) {
    rc.width = 3
    rc.height = 4
    // o Liskov Substitution diz que uma superclasse deve sempre
    // poder ser substituida por uma subclasse
    print("Expected area to be 12 but got \(rc.area)")
}

func mainLSP() {
    let r = Rectangle()
    setAndMeasure(r)
    
    let s = Square()
    setAndMeasure(s)
}
//mainLSP()

/// Interface Segregation Principle
class Document {
    
}

// consiste em separar protocolos grandes em protocolos menores
//protocol Machine {
//    func print(d: Document)
//    func scan(d: Document)
//    func fax(d: Document)
//}

protocol Printer {
    func print(d: Document)
}

protocol Scanner {
    func scan(d: Document)
}

protocol Fax {
    func fax(d: Document)
}

//enum NoRequiredFunctionality: Error {
//    case doesNotFax, doesNotScan, doesNotPrint
//}

protocol MultiFunctionDevice: Printer, Scanner, Fax {
    // unindo os protocolos menores em um protocolo só
}

// class MFP: Machine { // Multi-function Printer
class MFP: MultiFunctionDevice {
    func print(d: Document) {
        
    }
    
    func scan(d: Document) {
        
    }
    
    func fax(d: Document) {
        
    }
}

class OldFashionedPrinter: Printer {
    func print(d: Document) {
        
    }
}

class Photocopier: Printer, Scanner {
    func print(d: Document) {
        
    }
    
    func scan(d: Document) {
        
    }
}

/// Dependency Inversion Principle
enum Relationship {
    case parent, child, sibling
}

class Person {
    var name = ""
    init(_ name: String) {
        self.name = name
    }
}

protocol RelationshipBrowser {
    func findAllChildrenOf(_ name: String) -> [Person]
}

class Relationships: RelationshipBrowser { // low-level
    var relations = [(Person, Relationship, Person)]()
    
    func addParentAndChild(_ parent: Person, _ child: Person) {
        relations.append((parent, .child, child))
        relations.append((child, .parent, parent))
    }
    
    func findAllChildrenOf(_ name: String) -> [Person] {
        relations.filter({
            $0.name == name && $1 == .parent && $2.name == $2.name
        }).map({$2})
    }
}

class Research { // high-level
    init(_ browser: RelationshipBrowser) {
        for p in browser.findAllChildrenOf("John") {
            print(p.name)
        }
    }
}

func mainDIP() {
    let parent = Person("John")
    let child1 = Person("Brad")
    let child2 = Person("Nala")
    
    let relationships = Relationships()
    relationships.addParentAndChild(parent, child1)
    relationships.addParentAndChild(parent, child2)
    
    let _ = Research(relationships)
}
mainDIP()
