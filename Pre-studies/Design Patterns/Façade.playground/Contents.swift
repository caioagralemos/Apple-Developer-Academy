import Foundation

class Buffer {
    var width, height: Int
    var buffer: [Character]
    
    init(_ width: Int, _ height: Int) {
        self.width = width
        self.height = height
        self.buffer = [Character](repeating: " ", count: width*height)
    }
    
    subscript(_ index: Int) -> Character {
        return buffer[index]
    }
}

class Viewport {
    var buffer: Buffer
    var offset = 0
    init(_ buffer: Buffer) {
        self.buffer = buffer
    }
    
    func getCharacterAt(_ index: Int) -> Character {
        return buffer[offset+index]
    }
}

class Console {
    // o cara que mexe com isso não precisa mexer com buffers ou viewports, ele pega um buffer e um viewport padrao e segue com isso
    var buffers = [Buffer]()
    var viewports = [Viewport]()
    var offset = 0
    
    init() {
        let b = Buffer(30, 20)
        let v = Viewport(b)
        buffers.append(b)
        viewports.append(v)
    }
    
    func getCharacterAt(_ index: Int) -> Character {
        return viewports[0].getCharacterAt(index)
    }
}

func mainFacade() {
    let c = Console()
    let u = c.getCharacterAt(1)
}

mainFacade()
