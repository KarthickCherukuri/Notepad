//
//  DrawingHeader.swift
//  Notepad
//
//  Created by Karthick Cherukuri on 18/01/24.
//

import SwiftUI
import PencilKit

struct ActivityViewController: UIViewControllerRepresentable {
    var drawing: PKDrawing
    var applicationActivities: [UIActivity]? = nil
    var fileName: String

    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityViewController>) -> UIActivityViewController {
        let tempDirectory = FileManager.default.temporaryDirectory
        let pdfURL = tempDirectory.appendingPathComponent("\(fileName).pdf")

        let pdfData = drawing.pdfData()
        do {
            try pdfData.write(to: pdfURL)
        } catch {
            print("Failed to write PDF data to file: \(error)")
        }

        let controller = UIActivityViewController(activityItems: [pdfURL], applicationActivities: applicationActivities)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            controller.popoverPresentationController?.sourceView = rootViewController.view
            controller.popoverPresentationController?.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2, width: 0, height: 0)
        }
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityViewController>) {
    }
}

struct DrawingHeader: View {
   public init(selectedColor: Binding<Color>,
         selectedLineWidth: Binding<CGFloat>,
         selectedTool: Binding<ToolType>,
         showingEraserSheet: Binding<Bool>,
         selectedEraser: Binding<EraserType>,
         canvasView: Binding<PKCanvasView>,
         saveDrawing: @escaping () -> Void,
               fileName:String
               ) {
        self._selectedColor = selectedColor
        self._selectedLineWidth = selectedLineWidth
        self._selectedTool = selectedTool
        self._showingEraserSheet = showingEraserSheet
        self._selectedEraser = selectedEraser
        self._canvasView = canvasView
        self.saveDrawing = saveDrawing
//       self.height = height
       self.fileName=fileName
       
    
    }
    
    @Binding private var selectedColor:Color
    @Binding private var selectedLineWidth:CGFloat
    @Binding private var selectedTool:ToolType
    @Binding private var showingEraserSheet:Bool
    @Binding private var selectedEraser:EraserType
    @Binding private var canvasView: PKCanvasView
//    @Binding private var height:Binding<CGFloat>
    @State private var isSharing=false
    
    var saveDrawing:()->Void
    var fileName:String
    
    
    
    var body: some View {
        HStack{
            if UIDevice.current.userInterfaceIdiom == .pad {
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
            
        }
            
            Button(action:{isSharing=true}){
                Image(systemName: "square.and.arrow.up")
                    .imageScale(.large)
                    
            }.popover(isPresented: $isSharing) {
                ActivityViewController(drawing: canvasView.drawing, applicationActivities: nil,fileName: fileName)
            }
            if UIDevice.current.userInterfaceIdiom == .pad {
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
}


extension PKDrawing {
    func pdfData() -> Data {
        let image = self.image(from: self.bounds, scale: UIScreen.main.scale)
        let pdfData = image.pdfData()
        return pdfData
    }
}
extension UIImage {
    func pdfData() -> Data {
        let pdfRenderer = UIGraphicsPDFRenderer(bounds: CGRect(origin: .zero, size: self.size))
        return pdfRenderer.pdfData { context in
            context.beginPage()
            self.draw(in: CGRect(origin: .zero, size: self.size))
        }
    }
}

