//
//  ReminderStruct.swift
//  Notepad
//
//  Created by Karthick Cherukuri on 22/01/24.
//

import Foundation
import UserNotifications


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
    

    
    private func scheduleNotification(completion: @escaping (String?) -> Void) {
        if let subjectIndex=ModelData().subjectsList.firstIndex(where: {$0.id == self.subjectId}){
            let subjectName=ModelData().subjectsList[subjectIndex].name
            NotificationManager.shared.notify(subjectName:subjectName,task: self.task, deadline: self.deadline!, completion: completion)
        }
        
    }
    
      func cancelNotification() {
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
