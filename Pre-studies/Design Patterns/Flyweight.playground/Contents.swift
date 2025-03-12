import Foundation

class User {
    var fullName: String
    
    init(_ fullName: String) {
        self.fullName = fullName
    }
    
    var charCount: Int {
        return fullName.utf8.count
    }
}

class EfficientUser {
    nonisolated(unsafe) static var string = [String]()
    private var names = [Int]()
    
    init(_ fullName: String) {
        func getOrAdd(_ s: String) -> Int {
            if !Self.string.contains(s) {
                Self.string.append(s)
            }
            return Self.string.firstIndex(of: s)!
        }
        for word in fullName.components(separatedBy: .whitespacesAndNewlines) {
            getOrAdd(word)
        }
    }
    
    var fullName: String {
        var string = ""
        for index in names {
            string += Self.string[index]
        }
        return string
    }
    
    static var charCount: Int {
        return Self.string.map { $0.utf8.count }.reduce(0, +)
    }
}

func mainFlyweight() {
    var totalChars: Int = 0 {
        didSet {
            print("new number of chars: \(totalChars)")
        }
    }
    
    let u1 = User("John Smith")
    let u2 = User("Jane Smith")
    let u3 = User("Jane Doe")
    
    totalChars = u1.charCount + u2.charCount + u3.charCount
    
    let u4 = EfficientUser("John Smith")
    let u5 = EfficientUser("Jane Smith")
    let u6 = EfficientUser("Jane Doe")
    totalChars = EfficientUser.self.charCount
}

mainFlyweight()

extension String {
    func substring(_ location: Int, _ length: Int) -> String? {
        guard self.count >= location + length else { return nil }
        let start = index(startIndex, offsetBy: location)
        let end = index(startIndex, offsetBy: location + length)
        return String(self[start..<end])
    }
}

class FormattedText: CustomStringConvertible {
    private var text: String
    private var capitalize: [Bool]
    
    init(_ text: String) {
        self.text = text.lowercased()
        self.capitalize = [Bool](repeating: false, count: text.utf8.count)
    }
    
    func capitalize(_ start: Int, _ end: Int) {
        for i in start...end {
            capitalize[i] = true
        }
    }
    
    var description: String {
        var s = ""
        for i in 0..<text.utf8.count {
            let c = text.substring(i, 1)!
            s += capitalize[i] ? c.capitalized : c
        }
        return s
    }
}

class EfficientFormattedText: CustomStringConvertible {
    class TextRange {
        var start, end: Int
        var capitalize = false
        
        init(_ start: Int, _ end: Int) {
            self.start = start
            self.end = end
        }
        
        func covers(_ position: Int) -> Bool {
            return position >= start && position <= end
        }
    }
    
    private var text: String
    private var formatting = [TextRange]()
    
    init(_ text: String) {
        self.text = text.lowercased()
    }
    
    func getRange(_ start: Int, _ end: Int) -> TextRange {
        let range = TextRange(start, end)
        formatting.append(range)
        return range
    }
    
    var description: String {
        var s = ""
        for i in 0..<text.utf8.count {
            var c = text.substring(i, 1)!
            for range in formatting {
                if range.covers(i) && range.capitalize {
                    c = c.capitalized
                }
                s += c
            }
        }
        return s
    }
}

func mainFlyweight2() {
    let ft1 = FormattedText("Hello world!")
    ft1.capitalize(2, 4)
    print(ft1)
    
    let ft2 = EfficientFormattedText("Hello world!")
    ft2.getRange(2, 4).capitalize = true
    print(ft2)
}

mainFlyweight2()
