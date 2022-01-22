//
//  TODOList.swift
//  TODO-Category
//
//  Created by Hiroaki-Hirabayashi on 2022/01/23.
//

import SwiftUI
import CoreData

/// TODO一覧表示
struct TODOList: View {
    
    //MARK: - Properties
    
    // DBテーブルからデータを取得するアノテーション
    @FetchRequest(
        // 取得したデータの並べ替えの条件 この場合はToDoEntityを実施する時間順
        sortDescriptors: [NSSortDescriptor(keyPath: \ TODOEntity.time,
                                           ascending: true)],
        animation: .default)
    // DB操作オブジェクト
    @Environment(\.managedObjectContext) var viewContext
   
    // @Published var keyboardHeightに変更があれば反映する
    @ObservedObject var keyboardObserver = KeyboardObserver()
    
    // DBテーブルの全データが入る
    var todoListEntity: FetchedResults<TODOEntity>
    var todoCategory: TODOEntity.Category

    // IndexSet どのデータを削除するかが入る forで回して対象のentityを取得して削除を繰り返す
    private func swipeDeleteToDo(at offsets: IndexSet) {
        for index in offsets {
            let entity = todoListEntity[index]
            viewContext.delete(entity)
        }
        do {
            try viewContext.save() // 削除した事をセーブする
        } catch {
            print("削除エラー\(offsets)")
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(todoListEntity) { todoList in
                        // ToDoEntityのcategory
                        if todoList.category == self.todoCategory.rawValue {
                            // 画面遷移で開きたいviewを指定
                            NavigationLink(destination: EditTODO(editTODO: todoList)) {
                                // ToDoDetileRowが表示されセルをタップするとEditToDoの遷移する
                                TODODetailRow(observedTODO: todoList, hideIcon: true)
                            }
                        }
                    }.onDelete(perform: swipeDeleteToDo(at:))
                }
                QuickNewTask(category: todoCategory)
                    .padding()
            }.navigationBarTitle(todoCategory.iconString())
            // 編集ボタン追加

            .navigationBarItems(trailing: EditButton())
            // viewが表示される時
        }.onAppear() {
            self.keyboardObserver.startObserve()
            //キーボードをしまう
            UIApplication.shared.closeKeyboard()
        }
        // viewが閉じる時
        .onDisappear() {
            self.keyboardObserver.stopObserve()
            UIApplication.shared.closeKeyboard()
        }
        // キーボード高さに合わせてpaddingを取る（全体が上に上がる）
        .padding(.bottom, keyboardObserver.keyboardHeight)
        
    }
}

struct TODOList_Previews: PreviewProvider {
    /*
     DBのデータをリスト表示
     CoreDateを操作するためのContextを設定する。しないとDBが動作しない
     AppDelegateのインスタンス取得
     Contextの指定にはenviroment Modifierで設定する
     設定先はmanagedObjectContextと設定したcontext
     */
    static let container = (UIApplication.shared.delegate as! AppDelegate)
        .persistentContainer
    static let context = container.viewContext

    static var previews: some View {
//        ToDoList(category: .Priority1st)
//            .environment(\.managedObjectContext, context)

        // テストデータの全削除
        let request = NSBatchDeleteRequest(
            fetchRequest: NSFetchRequest(entityName: "ToDoEntity"))
        try! container.persistentStoreCoordinator.execute(request,
                                                          with: context)

        // データを追加 ToDoEntityに追加したcreateメソッド
        TODOEntity.create(in: context, category: .priority1st, task: "優先度1")
        TODOEntity.create(in: context, category: .priority2nd, task: "優先度2")
        TODOEntity.create(in: context, category: .priority3rd, task: "優先度3")
        TODOEntity.create(in: context, category: .priority4th, task: "優先度4")

//        return TODOList(todoCategory: .priority1st)
//            .environment(\.managedObjectContext, context)



    }


}
