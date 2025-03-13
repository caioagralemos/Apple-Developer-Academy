import Foundation

/// Method Chain

class Creature: CustomStringConvertible {
    var name: String
    var attack: Int
    var defense: Int
    
    init(_ name: String, _ attack: Int, _ defense: Int) {
        self.name = name
        self.attack = attack
        self.defense = defense
    }
    
    var description: String {
        return "A creature called \(self.name) with \(attack) attack and \(defense) defense."
    }
}

class CreatureModifier {
    let creature: Creature
    var next: CreatureModifier?
    
    init(_ creature: Creature) {
        self.creature = creature
    }
    
    func add(_ cm: CreatureModifier) {
        // criando uma cadeia
        if cm is NoBonusesModifier {
            let temp = next!
            next = cm
            next!.add(temp)
        } else {
            if next != nil {
                next!.add(cm)
            } else {
                next = cm
            }
        }
    }
    
    func handle() {
        self.next?.handle() // cadeia
    }
}

class DoubleAttackModifier: CreatureModifier {
    override func handle() {
        print("Doubling \(creature.name)'s attack.")
        creature.attack *= 2
        super.handle()
    }
}

class IncreaseDefenseModifier: CreatureModifier {
    override func handle() {
        print("Increasing \(creature.name)'s defense.")
        creature.defense += 3
        super.handle()
    }
}

class NoBonusesModifier: CreatureModifier {
    override func handle() {
        // nao faz nada, nem propaga
    }
}

func mainMethodChain() {
    let goblin = Creature("Goblin", 2, 2)
    print(goblin)
    
    let root = CreatureModifier(goblin)

    print("Let's double the goblin's attack")
    root.add(DoubleAttackModifier(goblin))
    
    print("Let's increase goblin's defense")
    root.add(IncreaseDefenseModifier(goblin))
    
    root.handle()
    print(goblin)
    
    print("The goblin was bewitched! He won't be able to get new effects")
    root.add(NoBonusesModifier(goblin))
    
    root.handle()
    print(goblin)

}

mainMethodChain()

/// Broker Chain

protocol Invocable: AnyObject
{
  func invoke(_ data: Any)
}

public protocol Disposable
{
  func dispose()
}

public class Event<T>
{
  public typealias EventHandler = (T) -> ()

  var eventHandlers = [Invocable]()

  public func raise(_ data: T)
  {
    for handler in self.eventHandlers
    {
      handler.invoke(data)
    }
  }

  public func addHandler<U: AnyObject>
    (target: U, handler: @escaping (U) -> EventHandler) -> Disposable
  {
    let subscription = Subscription(target: target, handler: handler, event: self)
    eventHandlers.append(subscription)
    return subscription
  }
}

class Subscription<T: AnyObject, U> : Invocable, Disposable
{
  weak var target: T?
  let handler: (T) -> (U) -> ()
  let event: Event<U>

  init(target: T?, handler: @escaping (T) -> (U) -> (), event: Event<U>)
  {
    self.target = target
    self.handler = handler
    self.event = event
  }

  func invoke(_ data: Any) {
    if let t = target {
      handler(t)(data as! U)
    }
  }

  func dispose()
  {
    event.eventHandlers = event.eventHandlers.filter { $0 as AnyObject? !== self }
  }
}

/// CQS - Command Query Separator

class Query {
    var creatureName: String
    enum Argument {
        case attack, defense
    }
    var whatToQuery: Argument
    var value: Int
    
    init(_ creatureName: String, _ whatToQuery: Argument, _ value: Int) {
        self.creatureName = creatureName
        self.whatToQuery = whatToQuery
        self.value = value
    }
}

class Game {
    let queries = Event<Query>()
    
    func performQuery(_ q: Query) {
        queries.raise(q)
    }
}

class GameCreature: CustomStringConvertible {
    var name: String
    private let _attack, _defense: Int
    private let game: Game
    
    init(_ name: String, _ attack: Int, _ defense: Int, _ game: Game) {
        self.name = name
        self._attack = attack
        self._defense = defense
        self.game = game
    }
    
    var attack: Int {
        let q = Query(self.name, .attack, _attack)
        game.performQuery(q)
        return q.value
    }
    
    var defense: Int {
        let q = Query(self.name, .defense, _defense)
        game.performQuery(q)
        return q.value
    }
    
    var description: String {
        return "A creature called \(self.name) with \(_attack) attack and \(_defense) defense."
    }
}

class GameCreatureModifier: Disposable {
    let game: Game
    let creature: GameCreature
    var event: Disposable? = nil
    
    init(_ game: Game, _ creature: GameCreature) {
        self.game = game
        self.creature = creature
        event = self.game.queries.addHandler(
            target: self,
            handler: GameCreatureModifier.handle
        )
    }
    
    func handle(_ q: Query) {
        
    }
    
    func dispose() {
        event?.dispose()
    }
}

class GameDoubleAttackModifier: GameCreatureModifier {
    override func handle(_ q: Query) {
        if q.creatureName == creature.name && q.whatToQuery == .attack {
            q.value *= 2
        }
    }
}

class GameIncreaseDefenseModifier: GameCreatureModifier {
    override func handle(_ q: Query) {
        if q.creatureName == creature.name && q.whatToQuery == .defense {
            q.value += 3
        }
    }
}

func mainBrokerChain() {
    let game = Game()
    let goblin = GameCreature("Goblin", 3, 3, game)
    print("Baseline: \(goblin)")
    
    let dam = GameDoubleAttackModifier(game, goblin)
    print("Goblin with 2x attack: \(goblin)")
    
    dam.dispose()
    print("Goblin disposed: \(goblin)")
}

mainBrokerChain()
