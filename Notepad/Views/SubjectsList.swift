//
//  SubjectsList.swift
//  Notepad
//
//  Created by Karthick Cherukuri on 15/01/24.
//

import SwiftUI

enum Tab{
    case subjects,reminders
}


struct SubjectsList: View {
    
    @Environment(ModelData.self) var modelData:ModelData
    @State private var isShowingSheet:Bool=false
    @State private var newSubjectName:String=""
    @State private var selectedSubject: subject? 
    @State private var showingDeleteAlert=false
    @State private var editingSubject:subject?
    @State private var newEditedSubjectName:String=""
    @State private var deletingSubject:subject?
    @State private var  selectedTab:Tab = .subjects

    var body: some View {
        NavigationView{
                        
            List{
                Section{
                    NavigationLink{
                        Reminders()
                    }label: {
                        Text("All Reminders")
                       
                    }
                    
                }
                
                if(!modelData.subjectsList.isEmpty){
                    
                    
                    ForEach(modelData.subjectsList){subject in
                        if (editingSubject == subject){
                            TextField("Edit Subject Name", text: $newEditedSubjectName)
                                .onSubmit {
                                    editingSubject=nil
                                    
                                    if let index = modelData.subjectsList.firstIndex(where: {$0.id==subject.id}){
                                        let fileManager=FileManagerStruct()
                                        fileManager.renameDrawing(newName: newEditedSubjectName, oldName: subject.name)
                                        modelData.subjectsList[index].name=newEditedSubjectName
                                        modelData.saveData()
                                        
                                    }
                                    
                                }
                        }else{
                            NavigationLink(
                                
                                destination:NotesList(subject: subject,subjectIndex:modelData.subjectsList.firstIndex(where: {$0.id==subject.id}) ?? -1),
                                tag: subject,
                                selection: $selectedSubject
                                
                            ) {
                                
                                Text(subject.name)
                                
                            }
                            .swipeActions{
                                Button{
                                    showingDeleteAlert=true
                                    deletingSubject=subject
                                    
                                }label: {
                                    Label("delete",systemImage: "trash")
                                }.tint(Color.red)
                                
                                Button{
                                    newEditedSubjectName=subject.name
                                    editingSubject=subject
                                }label:{
                                    Label("edit",systemImage: "pencil")
                                }.tint(Color.yellow)
                                
                            }
                            .alert(isPresented: $showingDeleteAlert) {
                                
                                guard let unwrappedDeletingSubject=deletingSubject else{
                                    print("delegin subject is nil")
                                    return Alert(title: Text("No subject selected"))
                                }
                                
                                return Alert(title: Text("Are you sure you want to delete \(unwrappedDeletingSubject.name)?"),
                                             primaryButton: .destructive(Text("Delete")) {
                                    print("deleting \(unwrappedDeletingSubject.name)")
                                    unwrappedDeletingSubject.deleteALLNotes()
                                    let fileManager=FileManagerStruct()
//                                    fileManager.deleteDrawing(fileName: unwrappedDeletingSubject.name)
                                    if (selectedSubject == deletingSubject){
                                        selectedSubject = nil
                                        
                                    }
                                    withAnimation{
                                        modelData.subjectsList.removeAll(where: {$0.id == unwrappedDeletingSubject.id})
                                        modelData.saveData() 
                                    }
                                    deletingSubject=nil
                                    
                                },
                                             secondaryButton: .cancel())
                                
                            }
                            
                        }//end
                        
                    }
                }
            }
           
            .navigationTitle("Subjects")
            .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("NotificationClicked"))) { notification in
            if let subjectName = notification.userInfo?["subjectName"] as? String {
                
                selectedSubject = modelData.subjectsList.first(where: { $0.name == subjectName })
            }
        

        }
            

            .onAppear{
                
                if(selectedSubject == nil && !modelData.subjectsList.isEmpty)
                {
                    selectedSubject=modelData.subjectsList.first
                }
                else{
                    print("empty")
                }
            }
            
            .toolbar{
                Button{
                    isShowingSheet.toggle()
                }label: {
                    Label("User Icon",systemImage: "plus")
                }
                .popover(isPresented: $isShowingSheet) {
                    VStack {
                        TextField("Enter something...", text: $newSubjectName)
                            .padding()
                        Button("Add") {
                            if(newSubjectName != ""){
                                
                                
                                let newSubject=subject(name: newSubjectName)
                                withAnimation{
                                    modelData.subjectsList.append(newSubject)
                                }
                                
                                newSubjectName = ""
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
        
        }
    


#Preview {
    
    SubjectsList()
        .environment(ModelData())
}
