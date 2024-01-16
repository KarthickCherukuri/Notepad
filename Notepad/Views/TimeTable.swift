//
//  TimeTable.swift
//  Notepad
//
//  Created by Karthick Cherukuri on 14/01/24.
//

import SwiftUI

struct TimeTable: View {
    let days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
    let periods = ["9:00 - 10:00", "10:00 - 11:00", "11:00 - 12:00", "12:00 - 1:00", "1:00 - 2:00"]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: periods.count + 1)) {
                Text("Days/Time")
                
                ForEach(periods, id: \.self) { period in
                    Text(period)
                }
                
                ForEach(days, id: \.self) { day in
                    Text(day)
                    ForEach(periods, id: \.self) { _ in
                        Text("Subject")
                            .frame(height: 50)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(5)
                            .padding(2)
                    }
                }
            }
            .padding()
        }
    }
}


#Preview {
    TimeTable()
}
