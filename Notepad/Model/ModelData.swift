//
//  ModelData.swift
//  Notepad
//
//  Created by Karthick Cherukuri on 15/01/24.
//

import Foundation
import UserNotifications

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
    var reminders:[Reminder]
    
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

struct note:Identifiable,Hashable,Codable{
    var id:UUID
    var name:String
    
    init(name:String){
        id=UUID()
        self.name=name
    }
    
    
}

class Reminder:Identifiable,Codable,Hashable{
    var id:UUID
    var task:String
    var deadline:Date?
    var notificationId: String?
    var subjectId:UUID
    init(task:String,subjectId:UUID,_ deadline:Date? = nil){
        self.id=UUID()
        self.task=task
        self.deadline=deadline
        self.subjectId=subjectId
        if(deadline != nil){
            scheduleNotification { newNotificationId in
                DispatchQueue.main.async {
                    
                    self.notificationId = newNotificationId
                    print("scheduled notification to \(self.deadline ?? Date(timeIntervalSince1970: 1) )")
                }
            }
        }
    }
    
    func changeNotificationId(notificationID:String?){
        self.notificationId=notificationID
    }
    
    func change(task: String, deadline: Date?) {
            self.task = task
            if deadline != self.deadline {
                self.cancelNotification()
                self.deadline = deadline
                scheduleNotification { newNotificationId in
                    DispatchQueue.main.async {
                        self.notificationId = newNotificationId
                        print("scheduled notification to \(self.deadline ?? Date(timeIntervalSince1970: 1) )")
                    }
                }
            }
        }
    
//    private  func scheduleNotification(completion: @escaping (String?) -> Void) {
//        guard let deadline = deadline else { return }
//        
//        let content = UNMutableNotificationContent()
//        content.title = "Reminder"
//        content.body = task
//        content.sound = UNNotificationSound.default
//        
//        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: deadline)
//        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
//        
//        let request = UNNotificationRequest(identifier: id.uuidString, content: content, trigger: trigger)
//        
//        UNUserNotificationCenter.current().add(request) { (error) in
//            if let error = error {
//                print("Error scheduling notification: \(error)")
//                completion(nil)
//            } else {
//                completion(request.identifier)
//            }
//        }
//    }
    
    private func scheduleNotification(completion: @escaping (String?) -> Void) {
        if let subjectIndex=ModelData().subjectsList.firstIndex(where: {$0.id == self.subjectId}){
            let subjectName=ModelData().subjectsList[subjectIndex].name
            NotificationManager.shared.notify(subjectName:subjectName,task: self.task, deadline: self.deadline!, completion: completion)
        }
        
    }
    
    private  func cancelNotification() {
        guard let notificationId = notificationId else { return }
        
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notificationId])
        
        self.notificationId = nil
    }

    static func == (lhs: Reminder, rhs: Reminder) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}

