//
//  Reminders.swift
//  Notepad
//
//  Created by Karthick Cherukuri on 21/01/24.
//

import SwiftUI

struct Reminders: View {
    @Environment(ModelData.self) var modelData
    @State private var AllReminders:[Reminder]=[]
    var body: some View {
        VStack{
            if(!AllReminders.isEmpty){
                List{
                    
                    
                    ForEach(AllReminders){reminder in
                        ReminderRow(reminder: reminder, subjectId: reminder.subjectId)
                        
                    }
                }
                
            }
            else{
                Text("No reminders")
            }
            
        }.onAppear{
            self.AllReminders=modelData.allReminders
        }
        .onReceive(modelData.remindersChanged, perform: { _ in
            self.AllReminders=modelData.allReminders
        })
    }
        
}

#Preview {
    Reminders()
        .environment(ModelData())
}
