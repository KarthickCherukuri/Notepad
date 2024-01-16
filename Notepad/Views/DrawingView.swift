//
//  DrawingView.swift
//  Notepad
//
//  Created by Karthick Cherukuri on 14/01/24.
//

import SwiftUI
import PencilKit

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

struct DrawingView: View {
    init(subject:subject){
        
        self.subject=subject


    }
     var subject:subject
    @Environment(\.scenePhase) private var scenePhase
    @State private var canvasView = PKCanvasView()
    @State private var selectedColor:Color = .red
    @State private var selectedLineWidth:CGFloat=1
    @State private var deletedLines=[PKDrawing]()
    @State private var showConfirmation:Bool=false
    @State private var selectionPath: UIBezierPath?
    @State private var showingEraserSheet = false
    @State private var selectedEraser: EraserType = .vector
    @State private var selectedTool: ToolType = .pen
    
    var body: some View {
        GeometryReader{geometry in
            VStack{
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
                        let fileManager=FileManagerStruct()
                        fileManager.saveDrawing(pencilKitCanvas: canvasView,filename: subject.name)
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
//                ScrollView(.vertical){
                    
                        PencilKitCanvas(canvasView: $canvasView,selectedEraser:$selectedEraser, selectedTool: $selectedTool, color: selectedColor, lineWidth: selectedLineWidth)
                            
                            .frame(height: geometry.size.height)
//                            .background(Color(.gray))
                    
                    
//                }
                        
                
                
            }
        }.onAppear{
            loadDrawing()
        }
        .onDisappear{
            saveDrawing()            
        }
        .onChange(of: scenePhase){newScenePhase in
            switch newScenePhase{
            case .background, .inactive:
                saveDrawing()
            default:
                loadDrawing()
            
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        
    }
}

extension DrawingView{
    private func loadDrawing() {
            let fileManager = FileManagerStruct()
        fileManager.loadDrawing(pencilKitCanvas: self.canvasView, fileName: self.subject.name)
        }

        private func saveDrawing() {
            let fileManager = FileManagerStruct()
            fileManager.saveDrawing(pencilKitCanvas: self.canvasView, filename: self.subject.name)
        }
}





#Preview {
    DrawingView(subject: ModelData().subjectsList[0])
}
