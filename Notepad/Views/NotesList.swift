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
    var subjectIndex:Int
    
    
    var body: some View {
        
        List{
            Section("Notes"){
                
                
                ForEach(modelData.subjectsList[subjectIndex].notes ){note in
                    if (editingNote == note){
                        TextField("Edit Subject Name", text: $newEditedNoteName)
                            .onSubmit {
                                
                                
                                if let subjectIndex = modelData.subjectsList.firstIndex(where: {$0.id==subject.id}){
                                    if let noteIndex=modelData.subjectsList[subjectIndex].notes.firstIndex(where: {$0.id==note.id})
                                    {   print("adding note to \(modelData.subjectsList[subjectIndex].name)")
                                        let fileManager=FileManagerStruct()
                                        fileManager.renameDrawing(newName: newEditedNoteName, oldName: note.name)
                                        modelData.subjectsList[subjectIndex].notes[noteIndex].name=newEditedNoteName
                                        modelData.saveData()
                                    }
                                    
                                }
                                editingNote=nil
                                
                            }
                    }else{
                        NavigationLink(
                            destination: DrawingView(note: note).id(note.id), //shd change
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
                            
                            guard let unwrappedDeletingNote=deletingNote else{
                                print("delegin note is nil")
                                return Alert(title: Text("No note selected"))
                            }
                            
                            return Alert(title: Text("Are you sure you want to delete \(unwrappedDeletingNote.name)?"),
                                         primaryButton: .destructive(Text("Delete")) {
                                print("deleting \(unwrappedDeletingNote.name)") // add functionality
                                let fileManager=FileManagerStruct()
                                fileManager.deleteDrawing(fileName: unwrappedDeletingNote.name)
                                if (selectedNote != deletingNote){
                                    withAnimation{
                                        if let subjectIndex = modelData.subjectsList.firstIndex(where: {$0.id==subject.id}){
                                            print("found the subject:\(modelData.subjectsList[subjectIndex].name)")
                                            modelData.subjectsList[subjectIndex].notes.removeAll(where: {$0.id == unwrappedDeletingNote.id})
                                            modelData.saveData()
                                        }
                                        
                                    }
                                }
                                deletingNote=nil
                                
                            },
                                         secondaryButton: .cancel())
                            
                        }
                    }
                    
                }
            }
        }//list end
//        .listStyle(SidebarListStyle()) 
        .navigationTitle(subject.name)
        .toolbar{
            Button{
                isShowingSheet.toggle()
            }label: {
                Label("User Icon",systemImage: "plus")
            }
            .popover(isPresented: $isShowingSheet) {
                VStack {
                    TextField("Enter something...", text: $newNoteName)
                        .padding()
                    Button("Add") {
                        if(newNoteName != ""){
                            let newNote=note(name: newNoteName)
                            withAnimation{
                                if let subjectIndex = modelData.subjectsList.firstIndex(where: {$0.id==subject.id}){
                                    modelData.subjectsList[subjectIndex].notes.append(newNote)
                                }
                                
                            }
                            
                            newNoteName = ""
                            isShowingSheet=false
                            
                            modelData.saveData()
                        }
                    }
                    .padding()
                }
                .padding()
            }
        }
    }
}

//#Preview {
//    NotesList()
//        .environment(ModelData())
//}
