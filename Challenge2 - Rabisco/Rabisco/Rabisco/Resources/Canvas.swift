//
//  Canvas.swift
//  Rabisco
//
//  Created by Caio on 13/11/25.
//

import SwiftUI
import PencilKit

struct Canvas: UIViewRepresentable {
    typealias UIViewType = PKCanvasView
    @Binding var zoomScale: CGFloat
    @Binding var drawing: PKDrawing
    @Binding var isUserDrawing: Bool
    
    let phase: ExperiencePhase
    let backgroundImage: UIImage?
    private let toolPicker: PKToolPicker
    
    init(
        zoomScale: Binding<CGFloat>,
        drawing: Binding<PKDrawing>,
        phase: ExperiencePhase,
        backgroundImage: UIImage? = nil,
        isUserDrawing: Binding<Bool> = .constant(false)
    ) {
        self._zoomScale = zoomScale
        self._drawing = drawing
        self._isUserDrawing = isUserDrawing
        self.phase = phase
        self.backgroundImage = backgroundImage
        
        switch phase {
        case .Sketch:
            self.toolPicker = PKToolPicker(toolItems: [
                PKToolPickerInkingItem(type: .pencil, color: .black, width: 2.0),
                PKToolPickerEraserItem(type: .bitmap)
            ])
            
        case .Detail:
            self.toolPicker = PKToolPicker(toolItems: [
                PKToolPickerInkingItem(type: .pen, color: .black, width: 3.0),
                PKToolPickerInkingItem(type: .pencil, color: .black, width: 1.5),
                PKToolPickerEraserItem(type: .bitmap)
            ])
            
        case .Color:
            self.toolPicker = PKToolPicker(toolItems: [
                PKToolPickerInkingItem(type: .marker, width: 8.0),
                PKToolPickerInkingItem(type: .watercolor, width: 8.0),
                PKToolPickerInkingItem(type: .crayon, width: 8.0),
                PKToolPickerEraserItem(type: .bitmap)
            ])
            
        case .Reveal:
            self.toolPicker = PKToolPicker(toolItems: [])
        }
    }


    func makeUIView(context: Context) -> UIViewType {
        // MARK: Setting up Canvas View
        let canvasView = PKCanvasView()
        //canvasView.drawingPolicy = .anyInput
        canvasView.minimumZoomScale = 1
        canvasView.zoomScale = zoomScale
        canvasView.maximumZoomScale = 1
        canvasView.tool = PKInkingTool(.pencil, color: .black)
        canvasView.contentSize = CGSize(width: 630, height: 750)
        
        // MARK: Setting previous drawings as background
        DispatchQueue.main.async {
            if let drawingSurface = canvasView.drawingGestureRecognizer.view?.superview {
                let bgView = UIImageView(image: backgroundImage)
                bgView.frame = drawingSurface.bounds
                bgView.contentMode = .scaleAspectFit
                bgView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

                drawingSurface.insertSubview(bgView, at: 0)
                context.coordinator.bgView = bgView
            }
        }
        
        // MARK: Setting up a regular Tool Picker
        toolPicker.setVisible(true, forFirstResponder: canvasView)
        toolPicker.addObserver(canvasView)
        canvasView.becomeFirstResponder()
        
        // MARK: Setting the drawing storage basic
        canvasView.drawing = drawing
        canvasView.delegate = context.coordinator

        return canvasView
    }
    
    func updateUIView(_ canvasView: PKCanvasView, context: Context) {
        canvasView.zoomScale = zoomScale
        if drawing != canvasView.drawing {
            canvasView.drawing = drawing
        }
        
        if let img = backgroundImage {
            context.coordinator.bgView?.image = img
        }
    }
}

extension Canvas {
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    
    class Coordinator: NSObject, PKCanvasViewDelegate {
        var parent: Canvas
        weak var bgView: UIImageView?
        
        init(_ parent: Canvas) {
            self.parent = parent
        }
        
        // MARK: UIScrollViewDelegate
        func scrollViewDidZoom(_ scrollView: UIScrollView) {
            DispatchQueue.main.async {
                self.parent.zoomScale = scrollView.zoomScale
            }
        }
        
        // MARK: PKCanvasViewDelegate
        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            DispatchQueue.main.async {
                self.parent.drawing = canvasView.drawing
            }
        }
        
        func canvasViewDidBeginUsingTool(_ canvasView: PKCanvasView) {
            DispatchQueue.main.async {
                self.parent.isUserDrawing = true
            }
        }
        
        func canvasViewDidEndUsingTool(_ canvasView: PKCanvasView) {
            DispatchQueue.main.async {
                self.parent.isUserDrawing = false
            }
        }
    }
}
