//
//  ContentView.swift
//  Notepad
//
//  Created by Karthick Cherukuri on 14/01/24.
//

import SwiftUI



struct ContentView:View{
    
    var body: some View{
        
        SubjectsList()
            .environment(ModelData())
    }
}



#Preview {
    ContentView()
}
