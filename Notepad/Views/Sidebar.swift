//
//  Sidebar.swift
//  Notepad
//
//  Created by Karthick Cherukuri on 21/01/24.
//

import SwiftUI



struct Sidebar: View {
    
    var body: some View {
        NavigationView{
            TabView{
                Reminders()
                    .tabItem { Text("Reminders") }
                    .tag(Tab.reminders)
                
                SubjectsList()
                    .tabItem { Text("subjects") }
                    .tag(Tab.subjects)
                
            }
        }
    }
}

#Preview {
    Sidebar()
}
