import Foundation

protocol CustomLog {
    func info(_ msg: String)
    func warn(_ msg: String)
}

class ConsoleLog: CustomLog {
    func info(_ msg: String) {
        print("INFO: \(msg)")
    }
    
    func warn(_ msg: String) {
        print("WARNING: \(msg)")
    }
}

class BankAccount {
    var log: CustomLog
    var balance = 0
    
    init(_ log: CustomLog) {
        self.log = log
    }
    
    func deposit(_ amount: Int) {
        balance += amount
        log.info("Deposited \(amount), balance is now \(balance)")
    }
}

class NullLog: CustomLog {
    // NullObject
    func info(_ msg: String) {}
    func warn(_ msg: String) {}
}

func mainNullObject() {
    let log = NullLog()
    let account = BankAccount(log)
    account.deposit(100)
}
