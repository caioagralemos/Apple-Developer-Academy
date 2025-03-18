import Foundation

/// Dynamic Strategy

enum OutputFormat {
    case markdown
    // * one
    // * two
    case html
    // <ul>
    //  <li>one</li>
    // </ul>
}

protocol ListStrategy {
    init()
    func start(_ buffer: inout String)
    func end(_ buffer: inout String)
    func addItem(_ buffer: inout String, item: String)
}

class MarkdownListStrategy: ListStrategy {
    required init() {}
    func start(_ buffer: inout String) {}
    func end(_ buffer: inout String) {}
    func addItem(_ buffer: inout String, item: String) {
        buffer.append(" * \(item)\n")
    }
}

class HtmlListStrategy: ListStrategy {
    required init() {}
    func start(_ buffer: inout String) {
        buffer.append("<ul>\n")
    }
    func end(_ buffer: inout String) {
        buffer.append("</ul>\n")
    }
    func addItem(_ buffer: inout String, item: String) {
        buffer.append(" <li>\(item)</li>\n")
    }
}

//class TextProcessor: CustomStringConvertible {
//    private var buffer = ""
//    private var listStrategy: ListStrategy
//    private var lastList = [String]()
//    
//    init(_ outputFormat: OutputFormat) {
//        switch outputFormat {
//        case .markdown: listStrategy = MarkdownListStrategy()
//        case .html: listStrategy = HtmlListStrategy()
//        }
//    }
//    
//    func setOutputFormat(_ outputFormat: OutputFormat) {
//        switch outputFormat {
//        case .markdown:
//            listStrategy = MarkdownListStrategy()
//            clear()
//            appendList(lastList)
//        case .html:
//            listStrategy = HtmlListStrategy()
//            clear()
//            appendList(lastList)
//        }
//    }
//    
//    func appendList(_ items: [String]) {
//        // &zinho do inout
//        listStrategy.start(&buffer)
//        for item in items {
//            listStrategy.addItem(&buffer, item: item)
//        }
//        listStrategy.end(&buffer)
//        
//        lastList = items
//    }
//    
//    func clear() {
//        buffer = ""
//    }
//    
//    var description: String {
//        buffer
//    }
//}


func mainStrategy() {
//    let tp = TextProcessor(.html)
//    tp.appendList(["Barcelona", "Atletico Madrid", "Real Madrid", "Girona"])
//    print(tp)
//    
//    tp.setOutputFormat(.markdown)
//    print(tp)
    
    let tp = TextProcessor<MarkdownListStrategy>() // constante (em compile-time)
    tp.appendList(["Barcelona", "Atletico Madrid", "Real Madrid", "Girona"])
    print(tp)
}

mainStrategy()

/// Static Pattern

class TextProcessor<LS>: CustomStringConvertible where LS: ListStrategy {
    private var buffer = ""
    private var listStrategy = LS()
    private var lastList = [String]()
    
    func appendList(_ items: [String]) {
        // &zinho do inout
        listStrategy.start(&buffer)
        for item in items {
            listStrategy.addItem(&buffer, item: item)
        }
        listStrategy.end(&buffer)
        
        lastList = items
    }
    
    func clear() {
        buffer = ""
    }
    
    var description: String {
        buffer
    }
}
