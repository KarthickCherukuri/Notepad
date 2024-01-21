//
//  NoteStruct.swift
//  Notepad
//
//  Created by Karthick Cherukuri on 22/01/24.
//

import Foundation

struct note:Identifiable,Hashable,Codable{
    var id:UUID
    var name:String
    
    init(name:String){
        id=UUID()
        self.name=name
    }
    
    
}
