//
//  FileManger.swift
//  Notepad
//
//  Created by Karthick Cherukuri on 14/01/24.
//

import Foundation
import PencilKit

struct FileManagerStruct{
   
    func saveDrawingWithHeight(pencilKitCanvas: PKCanvasView, drawingHeight: CGFloat, fileName: String = "drawing") {
        let drawing = pencilKitCanvas.drawing
        let drawingData = drawing.dataRepresentation()
        
        let drawingInfo: [String: Any] = [
            "drawingData": drawingData,
            "drawingHeight": drawingHeight
        ]
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent("\(fileName).data")
        
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: drawingInfo, requiringSecureCoding: false)
            try data.write(to: fileURL)
            print("Saved \(fileName) with height:\(drawingHeight) successfully")
        } catch {
            print("Error saving drawing: \(error)")
        }
        
    }
    
    func loadDrawingWithHeight(pencilKitCanvas: PKCanvasView, drawingHeight: inout CGFloat, fileName: String = "drawing")  {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent("\(fileName).data")

        if FileManager.default.fileExists(atPath: fileURL.path) {
            if let data = try? Data(contentsOf: fileURL),
               let drawingInfo = try? NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSDictionary.self, NSData.self, NSNumber.self], from: data) as? [String: Any],
               let drawingData = drawingInfo["drawingData"] as? Data,
               let drawing = try? PKDrawing(data: drawingData),
               let drawingHeightUnwrapped = drawingInfo["drawingHeight"] as? CGFloat {
                pencilKitCanvas.drawing = drawing
                drawingHeight = drawingHeightUnwrapped
                print("loaded \(fileName) with height: \(drawingHeight) successfully")
            }
        } else {
            print("No saved drawing file found.")
        }
    }
    
    
    func saveDrawing(pencilKitCanvas: PKCanvasView,filename:String="drawing") {
        let drawing = pencilKitCanvas.drawing
         let data = drawing.dataRepresentation()
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURL = documentsDirectory.appendingPathComponent("\(filename).data")
            
            do {
                try data.write(to: fileURL,options: .atomicWrite)
//                print("saved \(filename) successfully")
            } catch {
                print("Error saving drawing: \(error)")
            }
        
    }
    
    func loadDrawing(pencilKitCanvas:PKCanvasView,fileName:String="drawing")  {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent("\(fileName).data")
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            if let data = try? Data(contentsOf: fileURL),
               let drawing = try? PKDrawing(data: data) {
                pencilKitCanvas.drawing = drawing
                //            print("loaded \(fileName) successfully")
            }
        } else {
            print("No saved drawing file found.")
        }
    }
    
    func deleteDrawing(fileName: String = "drawing") {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent("\(fileName).data")

        do {
            try FileManager.default.removeItem(at: fileURL)
            print("Deleted \(fileName) successfully")
        } catch {
            print("Error deleting file: \(error)")
        }
    }
    
    func renameDrawing(newName: String, oldName: String) {
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let oldFileURL = documentsDirectory.appendingPathComponent("\(oldName).data")
        let newFileURL = documentsDirectory.appendingPathComponent("\(newName).data")

        do {
            try FileManager.default.moveItem(at: oldFileURL, to: newFileURL)
            print("Renamed \(oldName) to \(newName) successfully")
        } catch {
            print("Error renaming file: \(error)")
        }
    }
}
