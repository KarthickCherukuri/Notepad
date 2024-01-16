//
//  NotepadApp.swift
//  Notepad
//
//  Created by Karthick Cherukuri on 14/01/24.
//

import SwiftUI

@main
struct NotepadApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(ModelData())
        }
    }
}
