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
mainOCP()
