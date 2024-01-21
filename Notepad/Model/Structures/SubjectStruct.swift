//
//  SubjectStruct.swift
//  Notepad
//
//  Created by Karthick Cherukuri on 22/01/24.
//

import Foundation

struct subject:Identifiable,Hashable,Codable{
    var id:UUID
    var name:String
    var notes:[note]
    var reminders:[Reminder]
    
    mutating func deleteReminder(reminderId:UUID){
        if let reminderIndex=reminders.firstIndex(where: {$0.id == reminderId}){
            reminders[reminderIndex].cancelNotification()
            reminders.remove(at: reminderIndex)
        }
        
    }
    
    func deleteALLNotes(){
        let fileManager=FileManagerStruct()
        if(!self.notes.isEmpty){
            for note in self.notes{
                fileManager.deleteDrawing(fileName: note.name)
                print("deleted \(note.name)")
            }
        }
        
        
    }
    
    init(name:String){
        id=UUID()
        self.name=name
        self.reminders=[]
        self.notes=[note(name: "\(name) lecture 1")]
    }
}
