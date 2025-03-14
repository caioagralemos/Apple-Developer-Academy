import Foundation

class Node<T> {
    var value: T
    var parent: Node<T>? = nil
    var left: Node<T>? = nil {
        didSet {
            oldValue?.parent = nil
            left?.parent = self
        }
    }
    var right: Node<T>? = nil {
        didSet {
            oldValue?.parent = nil
            right?.parent = self
        }
    }
    
    init(value: T, left: Node<T>? = nil, right: Node<T>? = nil) {
        self.value = value
        self.left = left
        self.right = right
        
        left?.parent = self
        right?.parent = self
    }
}

class InOrderIterator<T>: IteratorProtocol {
    var current: Node<T>?
    var root: Node<T>
    var yieldedStart = false
    
    func next() -> Node<T>? {
        if !yieldedStart {
            yieldedStart = true
            return current
        }
        
        if current!.right != nil {
            current = current!.right
            while current!.left != nil {
                current = current!.left
            }
            return current
        } else {
            var p = current!.parent
            while p != nil && current === p!.right {
                current = p
                p = p!.parent
            }
            current = p
            return current
        }
    }
    
    func reset() {
        current = root
        yieldedStart = false
    }
    
    init(root: Node<T>) {
        self.root = root
        self.current = root
        while current?.left != nil {
            current = current!.left
        }
    }
}

class BinaryTree<T>: Sequence {
    private let root: Node<T>
    init(root: Node<T>) {
        self.root = root
    }
    
    func makeIterator() -> InOrderIterator<T> {
        return InOrderIterator<T>(root: root)
    }
}

func mainIterator() {
    var root = Node<Int>(value: 1, left: Node<Int>(value: 2), right: Node<Int>(value: 3))
    let it = InOrderIterator(root: root)
    while let element = it.next() {
        print(element.value, terminator: " ")
    }
    
    let nodes = AnySequence{ InOrderIterator(root: root) }
    print(nodes.map { $0.value })
}

mainIterator()


class Creature: Sequence {
    var stats = [Int](repeating: 0, count: 3)
    
    private let _strength = 0
    private let _agility = 1
    private let _intelligence = 2
    
    var strength: Int {
        get { return stats[_strength] }
        set(value) { stats[_strength] = value }
    }
    var agility: Int {
        get { return stats[_agility] }
        set(value) { stats[_agility] = value }
    }
    var intelligence: Int {
        get { return stats[_intelligence] }
        set(value) { stats[_intelligence] = value }
    }
    
    var averageStat: Float {
        return Float(stats.reduce(0, +)) / Float(stats.count)
    }
    
    func makeIterator() -> IndexingIterator<Array<Int>> {
        return IndexingIterator(_elements: stats)
    }
    
    init(strength: Int = 0, agility: Int = 0, intelligence: Int = 0) {
        self.strength = strength
        self.agility = agility
        self.intelligence = intelligence
    }
}

func mainIterator2() {
    var creature = Creature(strength: 10, agility: 15, intelligence: 11)
    
    print(creature.averageStat)
    
    for stat in creature {
        print(stat)
    }
}

mainIterator2()
