import Foundation

class HtmlBuilder: CustomStringConvertible {
    private let rootName: String
    var root = HtmlElement()
    
    init(rootName: String) {
        self.rootName = rootName
        root.name = rootName
    }
    
    func addChild(name: String, text: String) -> HtmlBuilder {
        // fluent function (consegue aninhar chamadas)
        let e = HtmlElement(name: name, text: text)
        root.elements.append(e)
        return self
    }
    
    var description: String {
        root.description
    }
    
    func clear() {
        root = HtmlElement(name: rootName, text: "")
    }
}

class HtmlElement: CustomStringConvertible {
    var name = ""
    var text = ""
    var elements = [HtmlElement]()
    private let indentSize = 2
    
    init() {}
    init(name: String, text: String) {
        self.name = name
        self.text = text
    }
    
    private func description(_ indent: Int) -> String {
        var result = ""
        let i = String(repeating: " ", count: indent)
        result += "\(i)<\(name)>\n"
        
        if !text.isEmpty {
            result += String(repeating: " ", count: (indent+1))
            result += text
            result += "\n"
        }
        
        for e in elements {
            result += e.description(indent+1)
        }
        
        result += "\(i)</\(name)>\n"
        return result
    }
    
    public var description: String {
        return description(0)
    }
}

func mainBuilder() {
    let hello = "hello"
    var result = "<p>\(hello)</p>"
    print(result)
    
    let words = ["hello", "world"]
    result = "<ul>\n"
    for word in words {
        result.append("<li>\(word)</li>\n")
    }
    result.append("</ul>")
    print(result)
    
    print("\naqui vai o builder:")
    let builder = HtmlBuilder(rootName: "ul")
    builder.addChild(name: "li", text: "hello")
        .addChild(name: "li", text: "world")
    print(builder)
}

mainBuilder()

/// Faceted Builder
class Person: CustomStringConvertible {
    // address
    var streetAddress = "", postcode = "", city = ""
    
    // employment
    var companyName = "", position = ""
    var annualIncome = 0
    
    var description: String {
        return "I live at \(streetAddress), \(postcode), \(city). " + "I work at \(companyName) as a \(position), earning \(annualIncome)."
    }
}

class PersonBuilder {
    var person = Person()
    var lives: PersonAddressBuilder {
        return PersonAddressBuilder(person)
    }
    var works: PersonJobBuilder {
        return PersonJobBuilder(person)
    }
    
    func build() -> Person {
        return person
    }
}

class PersonAddressBuilder: PersonBuilder {
    internal init(_ person: Person) {
        super.init()
        self.person = person
    }
    
    func at(_ streetAddress: String) -> PersonAddressBuilder {
        person.streetAddress = streetAddress
        return self
    }
    
    func withPostcode(_ postcode: String) -> PersonAddressBuilder {
        person.postcode = postcode
        return self
    }
    
    func inCity(_ city: String) -> PersonAddressBuilder {
        person.city = city
        return self
    }
}

class PersonJobBuilder: PersonBuilder {
    internal init(_ person: Person) {
        super.init()
        self.person = person
    }
    
    func at(_ companyName: String) -> PersonJobBuilder {
        person.companyName = companyName
        return self
    }
    
    func asA(_ position: String) -> PersonJobBuilder {
        person.position = position
        return self
    }
    
    func earning(_ annualIncome: Int) -> PersonJobBuilder {
        person.annualIncome = annualIncome
        return self
    }
}

let personBuilder = PersonBuilder()
let person = personBuilder.lives
    .at("Av Abdon Arroxelas")
    .withPostcode("57035000")
    .inCity("Maceio")
    .works
    .asA("Developer")
    .at("Apple")
    .earning(200000)
    .build()


// Exercise

class CodeBuilder : CustomStringConvertible {
    let rootName: String
    var fields = [(String, String)]()
    init(_ rootName: String) {
        self.rootName = rootName
    }

    func AddField(_ name: String, _ type: String) -> CodeBuilder {
        fields.append((name, type))
        return self
    }

    public var description: String {
        var result = "class \(rootName)\n{\n"
        for field in fields {
            result += " var \(field.0): \(field.1)\n"
        }
        result += "}"
        return result
    }
}

var cb = CodeBuilder("Person").AddField("name", "String").AddField("age", "Int")
print(cb.description)
