import Foundation

extension String {
    subscript(i: Int) -> Character {
        return self[index(self.startIndex, offsetBy: i)]
    }
    
    var isNumber: Bool {
        get {
            return !self.isEmpty && self.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
        }
    }
}

struct Token: CustomStringConvertible {
    enum TokenType {
        case integer, plus, minus, lparen, rparen
    }
    
    var tokenType: TokenType
    var text: String
    
    init(_ tokenType: TokenType, _ text: String) {
        self.tokenType = tokenType
        self.text = text
    }
    
    var description: String {
        return text
    }
}

func lex(_ input: String) -> [Token] {
    var result = [Token]()
    var i = 0
    while i < input.count {
        switch input[i] {
        case " ":
            i += 1
        case "+":
            result.append(Token(.plus, "+"))
            i += 1
        case "-":
            result.append(Token(.minus, "-"))
            i += 1
        case "(":
            result.append(Token(.lparen, "("))
            i += 1
        case ")":
            result.append(Token(.rparen, ")"))
            i += 1
        default:
            var s = String(input[i])
            for j in i+1..<input.count {
                if input[j].isNumber {
                    s.append(input[j])
                } else {
                    result.append(Token(.integer, s))
                    break
                }
            }
            i += s.count
        }
    }
    return result
}

protocol Element {
    var value: Int {
        get
    }
}

class Integer: Element {
    let value: Int
    
    init(_ value: Int) {
        self.value = value
    }
}

class BinaryOperation: Element {
    enum OpType {
        case addition, subtraction
    }
    
    var opType: OpType = .addition
    var left = Integer(0)
    var right = Integer(0)
    
    var value: Int {
        switch opType {
        case .addition:
            return left.value + right.value
        case .subtraction:
            return left.value - right.value
        }
    }
}

func parse(_ tokens: [Token]) -> BinaryOperation {
    let result = BinaryOperation()
    var haveLHS = false
    
    var i = 0
    while i < tokens.count {
        let token = tokens[i]
        switch token.tokenType {
        case .integer:
            let integer = Integer(Int(token.text)!)
            if !haveLHS {
                result.left = integer
                haveLHS = true
            } else {
                result.right = integer
            }
        case .plus:
            result.opType = .addition
        case .minus:
            result.opType = .subtraction
        case .lparen:
            var j = i
            while j < tokens.count {
                if tokens[j].tokenType == .rparen {
                    break
                }
                j += 1
            }
            
            let subexpression = tokens[(i+i)..<j]
            let element = parse(Array(subexpression))
            if !haveLHS {
                result.left = Integer(element.value)
                haveLHS = true
            } else {
                result.right = Integer(element.value)
            }
            i += 1
        case .rparen:
            continue
        }
    }
    
    return result
}

func mainInterpreter() {
    let input = "(13 + 4)-(12 - 1)"
    let tokens = lex(input)
    //print(tokens)
    
    let parsed = parse(tokens)
    print("\(input) = \(parsed.value)")
}

mainInterpreter()
