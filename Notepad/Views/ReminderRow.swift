//
//  ReminderRow.swift
//  Notepad
//
//  Created by Karthick Cherukuri on 18/01/24.
//

import SwiftUI

struct ReminderRow: View {
    @Environment(\.calendar) var calendar
    @Environment(ModelData.self) var modelData
    init(reminder:Reminder,subject:subject){
        self.reminder=reminder
        self.subject=subject
        self.settedName=reminder.task
        self.settedDate=reminder.deadline
    }
    var reminder: Reminder
    var subject : subject
    @State private var shoingPopup:Bool=false
    @State private var newEditedReminderName:String=""
    @State private var dateRequired:Bool = false
    @State private var reminderDate:Date=Date(timeIntervalSinceNow: 3600)
    @State private var settedName:String=""
    @State private var settedDate:Date?
    var body: some View {
        
            HStack{
                VStack(alignment: .leading) {
                    Text(settedName)
                    if let deadline = settedDate {
                        Text(getDateString(from: deadline))
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                Spacer()
                Button{
                    shoingPopup.toggle()
                }label: {
                    Image(systemName: "info.circle")
                }
                .popover(isPresented: $shoingPopup) {
                    VStack{
                        TextField("Enter Task Name" ,text: $newEditedReminderName)
                        Toggle("Date", isOn: $dateRequired)
                        if(dateRequired){
                            DatePicker("Date", selection: $reminderDate)
                        }
                        Button{
                            if let subjectIndex=modelData.subjectsList.firstIndex(where:{$0.id == subject.id}){
                                if let reminderIndex=modelData.subjectsList[subjectIndex].reminders.firstIndex(where:{$0.id == reminder.id}){
                                    modelData.subjectsList[subjectIndex].reminders[reminderIndex].change(task: newEditedReminderName, deadline: dateRequired ? reminderDate : nil)
                                    self.shoingPopup=false
                                    self.settedDate=dateRequired ? reminderDate : nil
                                    self.settedName=newEditedReminderName
                                    modelData.saveData()
                                }
                            }
                        }label: {
                            Text("Change")
                        }
                    }
                    .padding()
                    
                }
            }
            
            .swipeActions{
                Button{
                    if let subjectIndex=modelData.subjectsList.firstIndex(where: {$0.id == subject.id}){
                        withAnimation{
                            modelData.subjectsList[subjectIndex].reminders.removeAll(where: {$0.id==reminder.id})
                        }
                        
                    }
                }label:{
                    Image(systemName: "trash")
                }.tint(Color.red)
                
                
                
            }.onAppear{
                self.newEditedReminderName=reminder.task
                self.dateRequired = reminder.deadline != nil
                self.settedName=reminder.task
                if(reminder.deadline != nil){
                    self.reminderDate=reminder.deadline!
                    self.dateRequired=true
                    self.settedDate=reminder.deadline!
                }
                else{
                    self.dateRequired=false
                }
                print(self.dateRequired)
            }
        
    }
    
    func getDateString(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        if calendar.isDateInToday(date) {
            return "Today at \(dateFormatter.string(from: date))"
        } else if calendar.isDateInTomorrow(date) {
            return "Tomorrow at \(dateFormatter.string(from: date))"
        } else {
            dateFormatter.dateStyle = .short
            return dateFormatter.string(from: date)
        }
    }
}

#Preview {
    let modelData=ModelData()
    
    return ReminderRow(reminder: Reminder(task:"submit dsp",subjectId: modelData.subjectsList[0].id, Date(timeIntervalSince1970: 2)),subject: modelData.subjectsList[0])
        .environment(modelData)
}
