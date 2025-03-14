import Foundation

class Person {
    var id: UUID = UUID()
    var name: String
    var room: Chatroom? = nil
    private var chatLog = [String]()
    
    init(_ name: String) {
        self.name = name
    }
    
    func receive(sender: String, message: String) {
        let s = "\(sender): '\(message)'"
        print("[\(name)'s chat session] \(s)")
    }
    
    func say(_ message: String) {
        room?.broadcast(sender: self.name, message: message)
    }
    
    func pm(to destination: String, message: String) {
        room?.message(sender: self.name, destination: destination, message: message)
    }
}

class Chatroom {
    private var people = [Person]()
    
    func broadcast(sender: String, message: String) {
        for p in people {
            if p.name != sender {
                p.receive(sender: sender, message: message)
            }
        }
    }
    
    func join(_ p: Person) -> Self {
        let joinMsg = "\(p.name) has joined the chat!"
        broadcast(sender: "room", message: joinMsg)
        p.room = self
        people.append(p)
        return self
    }
    
    func leave(_ p: Person) -> Self {
        let leaveMsg = "\(p.name) has left the chat!"
        broadcast(sender: "room", message: leaveMsg)
        p.room = nil
        people.remove(at: people.firstIndex(where: { $0.id == p.id })!)
        return self
    }
    
    func message(sender: String, destination: String, message: String) -> Self {
        people.first { $0.name == destination }?.receive(sender: sender, message: message)
        return self
    }
}

func mainMediator() {
    let room = Chatroom()
    
    let john = Person("John")
    let jane = Person("Jane")
    
    room
        .join(john)
        .join(jane)
    
    john.say("Hello!")
    jane.say("Hi John!")
    
    let simon = Person("Simon")
    
    room.join(simon)
    
    simon.say("Hello everyone!")
    
    jane.pm(to: "Simon", message: "Glad you can join!")
}

mainMediator()
