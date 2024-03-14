// ### GENERICS ###

import Foundation

// um genérico <T> é um placeholder pra qualquer tipo

func somaInt(a: Int, b: Int) -> Int {
    return a + b
}
var resultInt = somaInt(a: 42, b: 99)

func somaFloat(a: Float, b: Float) -> Float {
    return a + b
}
var resultFloat = somaFloat(a: 1.1, b: 2.2)

// nesses casos, usamos genéricos. você escreve um método que recebe algum tipo generico T e ele roda de acordo
func soma<T: Numeric> (a: T, b: T) -> T {
    return a+b
}

resultInt = soma(a: 42, b: 99)
resultFloat = soma(a: 1.1, b: 2.2)


// Um genérico tem duas partes - o tipo e a constraint

func findIndex<T: Equatable>(of foundItem: T, in items: [T]) -> Int? {
    // essa func se lê: recebe qualquer tipo T onde T conforma ao protocolo Equatable e retorna uma Int
    for (index, item) in items.enumerated()
    {
        if item == foundItem {
            return index
        }
    }

    return nil
}

// Associated Types
// Associated Types são os genéricos dos Protocolos

struct Book {
    let titulo: String
    let autor: String
}

// protocol Storage {
//    func store(item: Book)
//    func retrieve(index: Int) -> Book
// }

// Vamos supor que a gente quer que Storage seja um armazenamento de qualquer coisa, não só livros

protocol Storage {
    associatedtype Item
    func store(item: Item)
    func retrieve(index: Int) -> Item
}

// Agora você pode guardar qualquer coisa

class Armario<Item>: Storage {
    var items: [Item] = [Item]()
    
    func store(item: Item) {
        items.append(item)
    }
    
    func retrieve(index: Int) -> Item {
        return items[index]
    }
}

let armariodeLivros = Armario<Book>()
armariodeLivros.store(item: Book(titulo: "Diario de um Banana", autor: "Jeff Kinney"))

struct Console {
    let name: String
    let company: String
}

let armarioVideogame = Armario<Console>()
armarioVideogame.store(item: Console(name: "Xbox One", company: "Microsoft"))

/*
   ___                  _        _                  _
  / __|___ _ _  ___ _ _(_)__    /_\  _ _ __ __ _ __| |___
 | (_ / -_) ' \/ -_) '_| / _|  / _ \| '_/ _/ _` / _` / -_)
  \___\___|_||_\___|_| |_\__| /_/ \_\_| \__\__,_\__,_\___|

 */

import Foundation

/*
🕹 There can only be one.

 Write a single function called `printAnyArray` that prints out values of both Ints and Strings

 */

let intArray = [1,2,3,4,5]
let stringArray = ["abhi", "iOS"]

func printIntArray(_ array:[Int]) {
    array.map { print($0) } // loop through the array and print all values
}
func printStringArray(_ array:[String]) {
    array.map { print($0) } // loop through the array and print all values
}

// your new generic method here...
func printArray<T>(_ array:[T]) {
    array.map { print($0) }
}


/*
🕹 Middle child.

 Write a function that returns the Optional middle value for any element in an array.

 Hint: Sort the array first. Then return the middle element.

 */

func middle<T: Comparable>(_ array:[T]) -> T {
    var a2 = array.sorted()
    return a2[Int(a2.count/2)]
}

print(middle(intArray))

/*
🕹 Stack anything.

Convert the following IntStack into a struct called `Stack` that takes any generic `Element` type and supports push and pop.
 
 */

struct IntStack {
    var items = [Int]()
    mutating func push(_ item: Int) {
        items.append(item)
    }
    mutating func pop() -> Int {
        return items.removeLast()
    }
}

var intOnlyStack = IntStack()
intOnlyStack.push(1)
intOnlyStack.push(2)
intOnlyStack.push(3)

// your generic Stack here...

protocol Stack {
    associatedtype Item
    mutating func push(_ item: Item)
    mutating func pop() -> Item
}

struct Stck<Item>: Stack {
    var items: [Item] = [Item]()
    mutating func push(_ item: Item) {
        items.append(item)
    }
    
    mutating func pop() -> Item {
       return items.removeFirst()
    }
}

var allStack = Stck<String>()
allStack.push("Olá")
allStack.push("Golaço filhao")
print(allStack.pop())
print(allStack)
