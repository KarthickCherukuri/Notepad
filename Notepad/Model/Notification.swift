//
//  Notification.swift
//  Notepad
//
//  Created by Karthick Cherukuri on 19/01/24.
//

import UserNotifications

class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationManager()

    private override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }

    func notify(subjectName:String,task:String,deadline:Date,completion: @escaping (String?) -> Void) {
        let content = UNMutableNotificationContent()
        if #available(iOS 15.0, *) {
                content.interruptionLevel = .timeSensitive
            print("time sensitive")
            }
        content.title = subjectName
        content.body = task
        content.userInfo = ["subjectName": subjectName]
        print("notification:\(subjectName)")
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: deadline)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        
        
        
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)

        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                notificationCenter.add(request) { error in
                    if let error = error {
                        print("Failed to schedule notification: \(error)")
                        completion(nil)
                    }
                }
            } else if let error = error {
                print("Failed to request notification authorization: \(error)")
                completion(request.identifier)
            }
        }
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if let subjectName = response.notification.request.content.userInfo["subjectName"] as? String {
            // Use the subjectName to determine which view to navigate to
            NotificationCenter.default.post(name: NSNotification.Name("NotificationClicked"), object: nil, userInfo: ["subjectName": subjectName])
        }
        completionHandler()
    }
}

