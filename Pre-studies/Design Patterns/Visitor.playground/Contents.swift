import Foundation

protocol Expression {
    func print(_ buffer: inout String)
    func accept(_ visitor: ExpressionVisitor)
}

class DoubleExpression: Expression {
    var value: Double
    
    init(_ value: Double) {
        self.value = value
    }
    
    func print(_ buffer: inout String) {
        buffer.append(String(value))
    }
    func accept(_ visitor: ExpressionVisitor) {
        visitor.visit(self)
    }
}

class AdditionExpression: Expression {
    var left, right: Expression
    
    init(_ left: Expression, _ right: Expression) {
        self.left = left
        self.right = right
    }
    
    func print(_ buffer: inout String) {
        buffer.append("(")
        left.print(&buffer)
        buffer.append("+")
        right.print(&buffer)
        buffer.append(")")
    }
    
    func accept(_ visitor: ExpressionVisitor) {
        visitor.visit(self)
    }
}

/// Dispatch
protocol Stuff {}

class Foo: Stuff {}
class Bar: Stuff {}

func f(_ foo: Foo) {}
func f(_ bar: Bar) {}

func mainDispatch() {
    let x: Stuff = Foo()
    //f(x) nao funciona
}

//mainDispatch()

protocol ExpressionVisitor {
    func visit(_ doubleExpression: DoubleExpression)
    func visit(_ additionExpression: AdditionExpression)
}

class ExpressionPrinter: ExpressionVisitor, CustomStringConvertible {
    private var buffer = ""
    
    func visit(_ doubleExpression: DoubleExpression) {
        doubleExpression.print(&buffer)
    }
    
    func visit(_ additionExpression: AdditionExpression) {
        additionExpression.print(&buffer)
    }
    
    var description: String {
        return buffer
    }
}

class ExpressionCalculator: ExpressionVisitor {
    var result = 0.0
    
    func visit(_ doubleExpression: DoubleExpression) {
        result = doubleExpression.value
    }
    
    func visit(_ additionExpression: AdditionExpression) {
        additionExpression.left.accept(self)
        let a = result
        additionExpression.right.accept(self)
        let b = result
        result = a+b
    }
}

func mainVisitor() {
    // 1 + (2+3)
    let e = AdditionExpression(
        DoubleExpression(1),
        AdditionExpression(
            DoubleExpression(2),
            DoubleExpression(3)
        )
    )
    
    var s = ""
//    e.print(&s)
//    print(s)
}

mainVisitor()
