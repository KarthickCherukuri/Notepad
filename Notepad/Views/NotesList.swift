//
//  NotesList.swift
//  Notepad
//
//  Created by Karthick Cherukuri on 16/01/24.
//

import SwiftUI

struct NotesList: View {
    @Environment(ModelData.self) var modelData
    @State private var isShowingSheet:Bool=false
    @State private var newNoteName:String=""
    @State private var selectedNote: note?
    @State private var showingDeleteAlert=false
    @State private var editingNote:note?
    @State private var newEditedNoteName:String=""
    @State private var deletingNote:note?
    var subject:subject
    
    var body: some View {
        List{
            ForEach(subject.notes){note in
                if (editingNote == note){
                    TextField("Edit Subject Name", text: $newEditedNoteName)
                        .onSubmit {
                            editingNote=nil
                            
                            if let subjectIndex = modelData.subjectsList.firstIndex(where: {$0.id==subject.id}){
                                if let noteIndex=modelData.subjectsList[subjectIndex].notes.firstIndex(where: {$0.id==note.id})
                                {
                                    let fileManager=FileManagerStruct()
                                    fileManager.renameDrawing(newName: newEditedNoteName, oldName: note.name)
                                    modelData.subjectsList[subjectIndex].notes[noteIndex].name=newEditedNoteName
                                    modelData.saveData()
                                }
                                
                            }
                           
                        }
                }else{
                    NavigationLink(
                        destination: DrawingView(subject:subject).id(note.id), //shd change
                        tag: note,
                        selection: $selectedNote
                                        
                    ) {
                       
                            Text(note.name)
                        
                    }
                    .swipeActions{
                        Button{
                            showingDeleteAlert=true
                            deletingNote=note
                            
                        }label: {
                            Label("delete",systemImage: "trash")
                        }.tint(Color.red)
                        
                        Button{
                            newEditedNoteName=note.name
                            editingNote=note
                        }label:{
                            Label("edit",systemImage: "pencil")
                        }.tint(Color.yellow)
                            
                    }
                    .alert(isPresented: $showingDeleteAlert) {
                        
                        guard let unwrappedNoteSubject=deletingNote else{
                            print("delegin note is nil")
                            return Alert(title: Text("No note selected"))
                        }
                        
                        return Alert(title: Text("Are you sure you want to delete \(unwrappedNoteSubject.name)?"),
                              primaryButton: .destructive(Text("Delete")) {
                            print("deleting \(unwrappedNoteSubject.name)") // add functionality
                            let fileManager=FileManagerStruct()
                            fileManager.deleteDrawing(fileName: unwrappedNoteSubject.name)
                            if (selectedNote != deletingNote){
                                withAnimation{
                                    modelData.subjectsList.removeAll(where: {$0.id == unwrappedNoteSubject.id})
                                    modelData.saveData()
                                }
                            }
                            deletingNote=nil
                            
                        },
                              secondaryButton: .cancel())
                        
                    }
                }
                
            }
        }
    }
}

//#Preview {
//    NotesList()
//        .environment(ModelData())
//}
