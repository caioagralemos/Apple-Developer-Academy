import Foundation

class Point: CustomStringConvertible, Hashable {
    var x, y: Int
    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }
    
    var description: String {
        return "(\(x), \(y))"
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }
    
    static func == (lhs: Point, rhs: Point) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
}

class Line {
    var start, end: Point
    
    init(_ start: Point, _ end: Point) {
        self.start = start
        self.end = end
    }
}

class VectorObject: Sequence {
    var lines = [Line]()
    
    func makeIterator() -> IndexingIterator<Array<Line>> {
        return IndexingIterator(_elements: lines)
    }
}

class VectorRectangle: VectorObject {
    init(_ x: Int, _ y: Int, _ width: Int, _ height: Int) {
        super.init()
        lines.append(Line(Point(x, y), Point(x+width, y)))
        lines.append(Line(Point(x+width, y), Point(x+width, y+height)))
        lines.append(Line(Point(x, y), Point(x, y+height)))
        lines.append(Line(Point(x, y+height), Point(x+width, y+height)))
    }
}

func drawPoint(_ p: Point) {
    print(".", terminator: "")
}

// a func so imprime pontos, e não objetos vetoriais
// precisamos de um adaptador!

class LineToPointAdapter: Sequence {
    nonisolated(unsafe) private static var count = 0
    var points = [Point]()
    
    init(_ line: Line) {
        Self.count += 1
        print("\(Self.count): generating points for line ", "[\(line.start.x), \(line.start.y)]-[\(line.end.x), \(line.end.y)]")
        let left = Swift.min(line.start.x, line.end.x)
        let right = Swift.max(line.start.x, line.end.x)
        let top = Swift.min(line.start.y, line.end.y)
        let bottom = Swift.max(line.start.y, line.end.y)
        let dx = right - left
        let dy = line.end.y - line.start.y
        
        if dx == 0 {
            for y in top...bottom {
                points.append(Point(left, y))
            }
        } else if dy == 0 {
            for x in left...right {
                points.append(Point(x, top))
            }
        }
    }
    
    func makeIterator() -> IndexingIterator<Array<Point>> {
        return IndexingIterator(_elements: points)
    }
}

func draw(_ vectorObjects: [VectorRectangle]) {
    for vo in vectorObjects {
        for line in vo {
            let adapter = LineToPointAdapter(line)
            adapter.forEach { drawPoint($0) }
        }
    }
}

func mainAdapter() {
    let vectorObjects = [
        VectorRectangle(1,1,10,10),
        VectorRectangle(3,3,6,6)
    ]
    draw(vectorObjects)
    draw(vectorObjects)
}

mainAdapter()

/// Exercise

class Square
{
  var side = 0

  init(side: Int)
  {
    self.side = side
  }
}

protocol Rectangle
{
  var width: Int { get }
  var height: Int { get }
}

extension Rectangle
{
  var area: Int
  {
    return self.width * self.height
  }
}

class SquareToRectangleAdapter : Rectangle
{
  init(_ square: Square)
  {
    self.width = square.side
    self.height = square.side
  }
  var width: Int
  var height: Int
}
