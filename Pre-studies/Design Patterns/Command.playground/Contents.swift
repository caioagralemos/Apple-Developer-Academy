import Foundation

class BankAccount: CustomStringConvertible {
    private var balance = 0
    private let overdraftLimit = -500
    
    func deposit(_ amount: Int) {
        balance += amount
        print("Deposited \(amount), balance is now \(balance)")
    }
    
    func withdraw(_ amount: Int) -> Bool {
        if balance - amount >= overdraftLimit {
            balance -= amount
            print("Withdrew \(amount), balance is now \(balance)")
            return true
        } else {
            print("Your limit won't afford this operation.")
            return false
        }
    }
    
    var description: String {
        return "Balance is now \(balance)"
    }
}

protocol Command {
    func call()
}

class BankAccountCommand: Command {
    private var account: BankAccount
    
    enum Action {
        case deposit, withdraw
    }
    
    private var action: Action
    private var amount: Int
    private var succeeded = false
    
    init(_ account: BankAccount, _ action: Action, _ amount: Int) {
        self.account = account
        self.action = action
        self.amount = amount
    }
    
    func call() {
        switch action {
        case .deposit:
            account.deposit(amount)
            succeeded = true
        case .withdraw:
            succeeded = account.withdraw(amount)
        }
    }
    
    func undo() {
        guard succeeded else { return }
        
        switch action {
        case .deposit:
            account.withdraw(amount)
        case .withdraw:
            account.deposit(amount)
        }
    }
}

func mainCommand() {
    let account = BankAccount()
    
    let commands = [
        BankAccountCommand(account, .deposit, 100),
        BankAccountCommand(account, .withdraw, 25)
    ]
    
    print(account)
    
    commands.forEach { $0.call() }
    
    print(account)
    
    commands.reversed().forEach { $0.undo() }
    
    print(account)
}

mainCommand()
