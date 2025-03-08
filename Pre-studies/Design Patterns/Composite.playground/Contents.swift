import Foundation

class GraphicObject: CustomStringConvertible {
    var name = "Group"
    var color = ""
    
    var children = [GraphicObject]()
    
    init() {}
    init(name: String) { self.name = name }
    
    private func print(_ buffer: inout String, _ depth: Int) {
        buffer.append(String(repeating: "*", count: depth))
        buffer.append(color.isEmpty ? "" : "\(color) ")
        buffer.append("\(name)\n")
        
        for child in children {
            child.print(&buffer, depth+1)
        }
    }
    
    var description: String {
        var buffer = ""
        print(&buffer, 0)
        return buffer
    }
}

class Square: GraphicObject {
    init(_ color: String) {
        super.init(name: "Square")
        self.color = color
    }
}

class Circle: GraphicObject {
    init(_ color: String) {
        super.init(name: "Circle")
        self.color = color
    }
}

func mainComposite() {
    let drawing = GraphicObject(name: "My Drawing")
    drawing.children.append(Square("Red"))
    drawing.children.append(Circle("Yellow"))
    
    let group = GraphicObject()
    group.children.append(Circle("Blue"))
    group.children.append(Square("Blue"))
    
    drawing.children.append(group)
    
    print(drawing)
    // meu composite pode, alem de ter elementos, ter grupos de elementos
    // que por si só terão outros elementos dentro
    // entretanto, um composite consegue interpretar e tratar todos
}

//mainComposite()


class Neuron: Sequence {
    var inputs = [Neuron]()
    var outputs = [Neuron]()
    
    func makeIterator() -> IndexingIterator<Array<Neuron>> {
        // vamos transformar layers em neurons em sequencias
        return IndexingIterator(_elements: [self])
    }
    
    func connect(_ to: Neuron) {
        outputs.append(to)
        to.inputs.append(self)
    }
}

class NeuronLayer: Sequence {
    private var neurons: [Neuron]
    
    func makeIterator() -> IndexingIterator<Array<Neuron>> {
        // vamos transformar layers em neurons em sequencias
        return IndexingIterator(_elements: neurons)
    }
 
    init(_ count: Int) {
        neurons = [Neuron](repeating: Neuron(), count: count)
    }
}

// aqui precisamos de uma API pra conectar neurons com neuron layers

extension Sequence {
    // isso é um composite
    func connect<Seq: Sequence>(to other: Seq) where Seq.Iterator.Element == Neuron, Self.Iterator.Element == Neuron {
        for from in self {
            for t in other {
                from.outputs.append(t)
                t.outputs.append(from)
            }
        }
    }
}

func mainComposite2() {
    var neuron1 = Neuron()
    var neuron2 = Neuron()
    var layer1 = NeuronLayer(10)
    var layer2 = NeuronLayer(20)
    
    neuron1.connect(to: neuron2)
    neuron1.connect(to: layer1)
}

mainComposite2()
