//
//  DrawingHeader.swift
//  Notepad
//
//  Created by Karthick Cherukuri on 18/01/24.
//

import SwiftUI
import PencilKit

struct DrawingHeader: View {
   public init(selectedColor: Binding<Color>,
         selectedLineWidth: Binding<CGFloat>,
         selectedTool: Binding<ToolType>,
         showingEraserSheet: Binding<Bool>,
         selectedEraser: Binding<EraserType>,
         canvasView: Binding<PKCanvasView>,
         saveDrawing: @escaping () -> Void) {
        self._selectedColor = selectedColor
        self._selectedLineWidth = selectedLineWidth
        self._selectedTool = selectedTool
        self._showingEraserSheet = showingEraserSheet
        self._selectedEraser = selectedEraser
        self._canvasView = canvasView
        self.saveDrawing = saveDrawing
    
    }
    
    @Binding private var selectedColor:Color
    @Binding private var selectedLineWidth:CGFloat
    @Binding private var selectedTool:ToolType
    @Binding private var showingEraserSheet:Bool
    @Binding private var selectedEraser:EraserType
    @Binding private var canvasView: PKCanvasView
    var saveDrawing:()->Void
    var body: some View {
        HStack{
            ColorPicker("Line Color",selection: $selectedColor)
                .labelsHidden()
            Slider(value:$selectedLineWidth,in:1...20,step: 0.1)
                .frame(maxWidth:200)
            Text(String(format: "%.1f", selectedLineWidth))
            
            Picker("Tool", selection: $selectedTool) {
                ForEach(ToolType.allCases, id: \.self) { tool in
                    switch tool {
                            case .pen:
                                Image(systemName: "pencil").tag(tool)
                            case .pencil:
                                Image(systemName: "pencil.and.outline").tag(tool)
                            case .marker:
                                Image(systemName: "highlighter").tag(tool)
                            case .crayon:
                                Image(systemName: "paintbrush").tag(tool)
                            case .eraser:
                                Image(systemName: "eraser").tag(tool)
                            case .lasso:
                                Image(systemName: "lasso").tag(tool)
                            }
                }
            }
            
                        .pickerStyle(SegmentedPickerStyle())
                        .padding()
                        .onChange(of: selectedTool){newValue in
                            if newValue == .eraser {
                                showingEraserSheet = true
                            }
                        }
                                    
                        .actionSheet(isPresented: $showingEraserSheet) {
                                        ActionSheet(title: Text("Select Eraser Type"), buttons: [
                                            .default(Text("Object Eraser"), action: {
                                                selectedEraser = .vector
                                            }),
                                            .default(Text("Pixel Eraser"), action: {
                                                selectedEraser = .bitmap
                                            }),
                                            .cancel()
                                        ])
                                    }

            Spacer()
            
            Button{
                saveDrawing()
            }label: {
                Image(systemName: "cloud")
            }

            Button{
                if let undoManager = canvasView.undoManager, undoManager.canUndo {
                    undoManager.undo()
                }
            }label: {
                Image(systemName: "arrow.uturn.backward.circle")
                    .imageScale(.large)
            }.disabled((canvasView.undoManager?.canUndo ?? false))

            Button{
                if let undoManager = canvasView.undoManager, undoManager.canRedo {
                    undoManager.redo()
                }
            }label: {
                Image(systemName: "arrow.uturn.forward.circle")
                    .imageScale(.large)
            }.disabled((canvasView.undoManager?.canRedo ?? false))
            
           
        }
    }
}



//#Preview {
//    DrawingHeader()
//}
