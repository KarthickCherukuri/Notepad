//
//  PencilKitCanvas.swift
//  Notepad
//
//  Created by Karthick Cherukuri on 15/01/24.
//

import SwiftUI
import PencilKit

struct PencilKitCanvas: UIViewRepresentable {
    @Binding var canvasView: PKCanvasView
    @Binding var selectedEraser:EraserType
    @Binding var selectedTool:ToolType
    var color: Color = .red
    var lineWidth: CGFloat = 1.0

    func makeUIView(context: Context) -> PKCanvasView {
        canvasView.drawingPolicy = .pencilOnly
        canvasView.tool = PKInkingTool(.pen, color: UIColor(color), width: lineWidth)
        

        return canvasView
    }

    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        
    switch selectedTool {
    case .pen:
        uiView.tool = PKInkingTool(.pen, color: UIColor(color), width: lineWidth)
        
    case .pencil:
        uiView.tool = PKInkingTool(.pencil, color: UIColor(color), width: lineWidth)
        
    case .marker:
        uiView.tool = PKInkingTool(.marker, color: UIColor(color), width: lineWidth)
        
    case .crayon:
        uiView.tool = PKInkingTool(.crayon, color: UIColor(color), width: lineWidth)
        
    case .eraser:
        switch selectedEraser {
        case .vector:
            uiView.tool = PKEraserTool(.vector)
        case .bitmap:
            uiView.tool = PKEraserTool(.bitmap)
            
        }
    case .lasso:
        uiView.tool=PKLassoTool()
        
        
    
    
        
        
    }
        
}
}


enum ToolType: String, CaseIterable {
    case pen = "Pen"
    case pencil = "Pencil"
    case marker = "Marker"
    case crayon = "Crayon"
    case eraser = "Eraser"
    case lasso = "lasso"
}

enum EraserType: String {
    case vector = "Vector"
    case bitmap = "Bitmap"
}
