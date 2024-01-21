//
//  ModelData.swift
//  Notepad
//
//  Created by Karthick Cherukuri on 15/01/24.
//

import Foundation
import UserNotifications
import Combine

@Observable
class ModelData{
    
    var subjectsList:[subject]
    
     var remindersChanged = PassthroughSubject<Void, Never>()
    
    init(){
        self.subjectsList=[]
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
    
     var allReminders: [Reminder] {
            var allReminders: [Reminder] = []
            for subject in subjectsList {
                allReminders.append(contentsOf: subject.reminders)
            }
            allReminders.sort { (reminder1, reminder2) -> Bool in
                let date1 = reminder1.deadline ?? Date.distantFuture
                let date2 = reminder2.deadline ?? Date.distantFuture
                return date1 > date2
            }
            return allReminders
        }

    func deleteReminder(from subjectIndex: Int,reminderID:UUID) {
        
        self.subjectsList[subjectIndex].deleteReminder(reminderId: reminderID)
        self.saveData()
        remindersChanged.send()
        
    }
    
    
}






