//
//  QuickNewTask.swift
//  TODO-Category
//
//  Created by Hiroaki-Hirabayashi on 2022/01/23.
//

import SwiftUI

// TODO入力
struct QuickNewTask: View {

    //MARK: - Properties
    
    let category: TODOEntity.Category
    var isEnabled = false
    // 入力されたタスクを保持
    @State var newTask = ""
    @Environment(\.managedObjectContext) var ViewContext // DB操作のためのContext
    
    private func addNewTask() {
        TODOEntity.create(in: self.ViewContext, category: self.category, task: self.newTask)
        newTask = ""
    }
    
    private func cancellTask() {
        newTask = ""
    }
    
    var body: some View {
        HStack {
            // onCommit Enterを押した時にもaddNewTaskが呼ばれる
            TextField("新しいToDoを追加", text: $newTask, onCommit: {
                self.addNewTask()
            })
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button(action: {
                self.addNewTask()
            }) {
                Text("追加")
            }
            Button(action: {
                self.cancellTask()
            }) {
                Text("キャンセル")
                    .foregroundColor(.red)
            }
        }
    }
}

struct QuickNewTask_Previews: PreviewProvider {
    static var context = (UIApplication.shared.delegate as! AppDelegate)
        .persistentContainer.viewContext
    
    static var previews: some View {
        QuickNewTask(category: .priority1st)
            // DB操作オブジェクト
            .environment(\.managedObjectContext, context)
    }
}
