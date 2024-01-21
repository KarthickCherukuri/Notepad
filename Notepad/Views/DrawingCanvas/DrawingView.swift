//
//  DrawingView.swift
//  Notepad
//
//  Created by Karthick Cherukuri on 14/01/24.
//

import SwiftUI
import PencilKit



struct DrawingView: View {
    init(note:note){
        
        self.subject=note


    }
     var subject:note
    @Environment(\.scenePhase) private var scenePhase
    @State private var canvasView = PKCanvasView()
    @State private var selectedColor:Color = .red
    @State private var selectedLineWidth:CGFloat=1
    @State private var deletedLines=[PKDrawing]()
    @State private var showConfirmation:Bool=false
    @State private var selectionPath: UIBezierPath?
    @State private var showingEraserSheet = false
    @State private var selectedEraser: EraserType = .vector
    @State private var canvasHeight:CGFloat=1
    @State private var selectedTool: ToolType = .pen
    
    var body: some View {
        GeometryReader{geometry in
            VStack{
//                HStack{
//                    ColorPicker("Line Color",selection: $selectedColor)
//                        .labelsHidden()
//                    Slider(value:$selectedLineWidth,in:1...20,step: 0.1)
//                        .frame(maxWidth:200)
//                    Text(String(format: "%.1f", selectedLineWidth))
//                    
//                    Picker("Tool", selection: $selectedTool) {
//                        ForEach(ToolType.allCases, id: \.self) { tool in
//                            switch tool {
//                                    case .pen:
//                                        Image(systemName: "pencil").tag(tool)
//                                    case .pencil:
//                                        Image(systemName: "pencil.and.outline").tag(tool)
//                                    case .marker:
//                                        Image(systemName: "highlighter").tag(tool)
//                                    case .crayon:
//                                        Image(systemName: "paintbrush").tag(tool)
//                                    case .eraser:
//                                        Image(systemName: "eraser").tag(tool)
//                                    case .lasso:
//                                        Image(systemName: "lasso").tag(tool)
//                                    }
//                        }
//                    }
//                    
//                                .pickerStyle(SegmentedPickerStyle())
//                                .padding()
//                                .onChange(of: selectedTool){newValue in
//                                    if newValue == .eraser {
//                                        showingEraserSheet = true
//                                    }
//                                }
//                                            
//                                .actionSheet(isPresented: $showingEraserSheet) {
//                                                ActionSheet(title: Text("Select Eraser Type"), buttons: [
//                                                    .default(Text("Object Eraser"), action: {
//                                                        selectedEraser = .vector
//                                                    }),
//                                                    .default(Text("Pixel Eraser"), action: {
//                                                        selectedEraser = .bitmap
//                                                    }),
//                                                    .cancel()
//                                                ])
//                                            }
//
//                    Spacer()
//                    
//                    Button{
//                        saveDrawing() 
//                    }label: {
//                        Image(systemName: "cloud")
//                    }
//
//                    Button{
//                        if let undoManager = canvasView.undoManager, undoManager.canUndo {
//                            undoManager.undo()
//                        }
//                    }label: {
//                        Image(systemName: "arrow.uturn.backward.circle")
//                            .imageScale(.large)
//                    }.disabled((canvasView.undoManager?.canUndo ?? false))
//
//                    Button{
//                        if let undoManager = canvasView.undoManager, undoManager.canRedo {
//                            undoManager.redo()
//                        }
//                    }label: {
//                        Image(systemName: "arrow.uturn.forward.circle")
//                            .imageScale(.large)
//                    }.disabled((canvasView.undoManager?.canRedo ?? false))
//                    
//                    Button{
//                        increaseCanvasHeight()
//                        print(canvasHeight)
//                    }label: {
//                        Image(systemName: "plus")
//                    }
//                    
//                    Button{
//                        decreaseCanvasHeight()
//                    }label:{
//                        Image(systemName: "minus")
//                    }
//                }//hstack end
                if UIDevice.current.userInterfaceIdiom == .pad {
                    DrawingHeader(selectedColor:$selectedColor,selectedLineWidth: $selectedLineWidth,selectedTool: $selectedTool,showingEraserSheet:$showingEraserSheet,selectedEraser: $selectedEraser,canvasView: $canvasView,saveDrawing: self.saveDrawing)
                }
                
                ZStack(alignment: .bottomTrailing) {
                    ScrollView(.vertical){
                        
                        PencilKitCanvas(canvasView: $canvasView,selectedEraser:$selectedEraser, selectedTool: $selectedTool, color: selectedColor, lineWidth: selectedLineWidth)
                        
                            .frame(height: geometry.size.height*canvasHeight)
                        //                            .background(Color(.gray))
                        
                        
                    }
                    if UIDevice.current.userInterfaceIdiom == .pad {
                        VStack(spacing:10){
                            Button{
                                increaseCanvasHeight()
                            }label: {
                                Image(systemName: "plus")
                            }
                            Divider().background(Color.blue)
                            Button{
                                decreaseCanvasHeight()
                            }label: {
                                Image(systemName: "minus")
                            }
                                    
                        }
                        .frame(width:20)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color.blue, lineWidth: 1)
                        )
                    }
                    
                    
                    
                    
                    
                    
                    
                    
                }
                        
                
                
            }
        }//geo end
        .navigationTitle(subject.name)
        .onAppear{
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
    public func loadDrawing() {
            let fileManager = FileManagerStruct()
        fileManager.loadDrawingWithHeight(pencilKitCanvas: self.canvasView, drawingHeight: &self.canvasHeight,fileName: self.subject.name)
        } 

        
    public func saveDrawing() {
        let fileManager = FileManagerStruct()
        fileManager.saveDrawingWithHeight(pencilKitCanvas: self.canvasView, drawingHeight: self.canvasHeight,fileName: self.subject.name)
    }
    
    public func decreaseCanvasHeight(){
        withAnimation{
            canvasHeight=max(canvasHeight-1,1)
        }
         print("changed canvas heoght to \(canvasHeight)")
    }
    
    public func increaseCanvasHeight(){
        withAnimation{
            canvasHeight+=1
        }
        
    }
}





#Preview {
    DrawingView(note: ModelData().subjectsList[0].notes[0])
}
