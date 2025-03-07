import Foundation

protocol Renderer {
    func renderCircle(_ radius: Float)
}

class VectorRenderer: Renderer {
    func renderCircle(_ radius: Float) {
        print("Drawing a circle of radius \(radius)")
    }
}

class RasterRenderer: Renderer {
    func renderCircle(_ radius: Float) {
        print("Drawing pixels for circle of radius \(radius)")
    }
}

protocol Shape {
    func draw()
    func resize(_ factor: Float)
}

class Circle: Shape {
    var radius: Float
    var renderer: Renderer
    
    init(_ radius: Float, _ renderer: Renderer) {
        self.radius = radius
        self.renderer = renderer
    }
    
    func draw() {
        // renderer é uma bridge
        // circulo nao sabe nada sobre desenho, um renderer é uma bridge que faz isso
        renderer.renderCircle(radius)
    }
    
    func resize(_ factor: Float) {
        radius *= factor
    }
}

func mainBridge() {
    let raster = RasterRenderer()
    let vector = VectorRenderer()
    let circle = Circle(12, vector)
    circle.draw()
    circle.resize(2)
    circle.draw()
}

mainBridge()
