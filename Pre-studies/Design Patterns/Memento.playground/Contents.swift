import Foundation

class Memento {
    // Mementos são classes imutáveis
    let balance: Int
    
    init(_ balance: Int) {
        self.balance = balance
    }
}

class BankAccount: CustomStringConvertible {
    private var balance: Int = 0
    private var changes = [Memento]()
    private var current = 0
    
    init(_ balance: Int) {
        self.balance = balance
        changes.append(Memento(balance))
    }
    
    var description: String {
        return "Balance: $\(balance)"
    }
    
    func deposit(_ amount: Int) -> Memento {
        balance += amount
        let m = Memento(balance)
        self.changes.append(m)
        self.current += 1
        return m
    }
    
    func restore(_ m: Memento?) {
        if let memento = m {
            balance = memento.balance
            changes.append(memento)
            current = changes.count - 1
        }
    }
    
    func undo() -> Memento? {
        if current > 0 {
            current -= 1
            let m = changes[current]
            balance = m.balance
            return m
        }
        return nil
    }
    
    func redo() -> Memento? {
        if current+1 < changes.count {
            current += 1
            let m = changes[current]
            balance = m.balance
            return m
        }
        return nil
    }
}


func mainMemento() {
    var ba = BankAccount(7)
    let m1 = ba.deposit(100)
    let m2 = ba.deposit(25)
    print(ba)
    
    ba.undo()
    print(ba)
}

mainMemento()
