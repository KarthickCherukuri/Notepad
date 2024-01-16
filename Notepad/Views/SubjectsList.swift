//
//  SubjectsList.swift
//  Notepad
//
//  Created by Karthick Cherukuri on 15/01/24.
//

import SwiftUI

struct SubjectsList: View {
    @Environment(ModelData.self) var modelData:ModelData
    @State private var isShowingSheet:Bool=false
    @State private var newSubjectName:String=""
    @State private var selectedSubject: subject?
    @State private var showingDeleteAlert=false
    @State private var editingSubject:subject?
    @State private var newEditedSubjectName:String=""
    @State private var deletingSubject:subject?
    var body: some View {
        NavigationView{
            List{
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
                            destination: DrawingView(subject:subject).id(subject.id),
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
                                print("deleting \(unwrappedDeletingSubject.name)") // add functionality
                                let fileManager=FileManagerStruct()
                                fileManager.deleteDrawing(fileName: unwrappedDeletingSubject.name)
                                if (selectedSubject != deletingSubject){
                                    withAnimation{
                                        modelData.subjectsList.removeAll(where: {$0.id == unwrappedDeletingSubject.id})
                                        modelData.saveData() 
                                    }
                                }
                                deletingSubject=nil
                                
                            },
                                  secondaryButton: .cancel())
                            
                        }
                        
                    }//end
                    
                }
            }
            .onAppear{
                if(selectedSubject == nil)
                {
                    selectedSubject=modelData.subjectsList.first
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
                        Button("Submit") {
                            let newSubject=subject(name: newSubjectName)
                            withAnimation{
                                modelData.subjectsList.append(newSubject)
                            }
                            
                            newSubjectName = ""
                            isShowingSheet=false
                                                        
                            modelData.saveData()
                        }
                        .padding()
                    }
                    .padding()
                }
            }
        }
//        .listStyle(SidebarListStyle())
        
        .navigationTitle("Subjects")
        }
    }


#Preview {
    SubjectsList()
        .environment(ModelData())
}
