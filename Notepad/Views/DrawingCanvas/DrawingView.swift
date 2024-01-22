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

                
                    DrawingHeader(selectedColor:$selectedColor,selectedLineWidth: $selectedLineWidth,selectedTool: $selectedTool,showingEraserSheet:$showingEraserSheet,selectedEraser: $selectedEraser,canvasView: $canvasView,saveDrawing: self.saveDrawing,
                                  fileName:subject.name)
                
                
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
