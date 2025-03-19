import Foundation

class Game {
    func run() {
        start()
        while !haveWinner {
            takeTurn()
        }
        print("Player \(winningPlayer) wins!")
    }
    
    internal func start() {
        // torna a funcao abstrata
        precondition(false, "this method needs to be overriden")
    }
    
    internal func takeTurn() {
        precondition(false, "this method needs to be overriden")
    }
    
    internal var winningPlayer: Int {
        get {
            precondition(false, "this method needs to be overriden")
            return 0
        }
    }
    internal var haveWinner = false
    internal var currentPlayer = 0
    internal let numberOfPlayers: Int
    
    init(_ numberOfPlayers: Int) {
        self.numberOfPlayers = numberOfPlayers
    }
}

class Chess: Game {
    private let maxTurns = 10
    private var turn = 0
    init() {
        super.init(2)
    }
    
    override func start() {
        print("Starting a chess game with \(numberOfPlayers) players.")
    }
    
    override func takeTurn() {
        if turn < maxTurns {
            print("Turn \(turn) taken by player \(currentPlayer).")
            currentPlayer = (currentPlayer + 1) % numberOfPlayers
            turn += 1
        } else if maxTurns == 10 {
            print("Turn \(turn) taken by player \(currentPlayer).")
            currentPlayer = (currentPlayer + 1) % numberOfPlayers
            haveWinner = true
        }
    }
    
    override var winningPlayer: Int {
        return currentPlayer
    }
}

func mainTemplate() {
    let chess = Chess()
    chess.run()
}

mainTemplate()
