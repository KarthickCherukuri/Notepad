//
//  ModelData.swift
//  Notepad
//
//  Created by Karthick Cherukuri on 15/01/24.
//

import Foundation

@Observable
class ModelData{
    var subjectsList:[subject]=[subject(name:"Vlsi"),
                                subject(name:"DSP"),
                                subject(name:"Control Systens")]
    
    init(){
        self.subjectsList=loadData()
    }
    func saveData() {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(subjectsList)
            let url = getDocumentsDirectory().appendingPathComponent("subjects.json")
            try data.write(to: url)
        } catch {
            print("Error saving data: \(error)")
        }
        
    }
    
    private func loadData() -> [subject] {
            let url = getDocumentsDirectory().appendingPathComponent("subjects.json")
            let decoder = JSONDecoder()
            do {
                let data = try Data(contentsOf: url)
                return try decoder.decode([subject].self, from: data)
            } catch {
                print("Error loading data: \(error)")
                return [subject(name: "Vlsi"), subject(name: "DSP"), subject(name: "Control Systems")]
            }
        }
    
    private func getDocumentsDirectory() -> URL {
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            return paths[0]
        }
    
    
}

struct subject:Identifiable,Hashable,Codable{
    var id:UUID
    var name:String
    var notes:[note]
    init(name:String){
        id=UUID()
        self.name=name
        self.notes=[note(name: "\(name) lecture 1")]
    }
}

struct note:Identifiable,Hashable,Codable{
    var id:UUID
    var name:String
    init(name:String){
        id=UUID()
        self.name=name
        
        
    }
}
