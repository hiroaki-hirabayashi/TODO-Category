//
//  EditTODO.swift
//  TODO-Category
//
//  Created by Hiroaki-Hirabayashi on 2022/01/23.
//

import SwiftUI

/// TODO編集画面
struct EditTODO: View {
    
    //MARK: - Properties
    
    // DBの監視
    @ObservedObject var editTODO: TODOEntity
    // SwiftUI上でこの値を変更したらDBに反映される
    // actionsheetの表示を制御する
    @State var showingActionSheet = false
    
    @Environment(\.managedObjectContext) var viewContext
    // viewの表示制御オブジェクトを取得
    @Environment(\.presentationMode) var presentationMode
    
    var categoryArray: [TODOEntity.Category] = [
        .priority1st,
        .priority2nd,
        .priority3rd,
        .priority4th
    ]
    
    //MARK: - function
    
    /// データ保存のfunction 永続化
    private func save() {
        do {
            try self.viewContext.save()
        } catch {
            let error = error as NSError
            fatalError("エラー\(error), \(error.userInfo)")
        }
    }
    
    /// viewContext DB操作オブジェクトに対してdeleteメソッド
    private func delete() {
        viewContext.delete(editTODO)
        save()
    }
    
    var body: some View {
        NavigationView {
            Form {
                // TODO入力セクション
                Section(header: Text("TODO")) {
                    TextField("TODO(やる事)追加", text: Binding($editTODO.task, "New TODO"))
                }
                
                /*
                 日時入力セクション
                 Binding(isNotNil: $selectDateTime, defaultValue: Date())
                 selectDateTimeの値がnilかそうでないかをToggleと連動させる（ToggleがONで!=nil OFFでnilが$selectDateTimeに入る）
                 */
                Section(header: Toggle(isOn: Binding(isNotNil: $editTODO.time, defaultValue: Date()),
                                       label: { Text("日時") })) {
                    // selectDateTimeがnilでなかったら時間設定表示 nilなら表示しない
                    if editTODO.time != nil {
                        /*
                         selectionには渡すBindingを設定
                         $selectDateTimeだとoptionalのBindingを渡してしまうのでエラーになる（Date型のBindingを渡さなければならない）
                         Binding($selectDateTime, Date())としてoptionalをBindingする
                         */
                        DatePicker(selection: Binding($editTODO.time, Date()), label: { Text("日時") })
                    } else {
                        Text("未設定").foregroundColor(.secondary)
                    }
                    
                }
                
                // カテゴリーピッカー $categoryにtagの値が入る
                Picker(selection: $editTODO.category, label: Text("カテゴリー")) {
                    ForEach(categoryArray, id: \.self) { category in
                        HStack {
                            CategoryImage(category)
                            Text(category.iconString())
                        }.tag(category.rawValue)
                    }
                }
                
                // 削除セクション
                Section(header: Text("ToDo削除")) {
                    Button(action: {
                        self.showingActionSheet = true
                    }) {
                        HStack(alignment: .center) {
                            Image(systemName: "minus.circle.fill")
                            Text("削除")
                        }.foregroundColor(.red)
                    }
                }
            }.navigationBarTitle("ToDoの編集")
                .navigationBarItems(trailing: Button(action: {
                    self.save()
                    self.presentationMode.wrappedValue.dismiss()
                    
                }) {
                    Text("閉じる")
                })
                .actionSheet(isPresented: $showingActionSheet) { //showingActionSheetがtrueの時表示
                    ActionSheet(title: Text("TODOの削除"), message: Text("この項目を削除します。よろしいですか？"),
                                buttons: [
                                    // .destructive ボタンのデザイン
                                    .destructive(Text("削除する")) {
                                        self.delete()
                                        self.presentationMode.wrappedValue.dismiss()
                                    // cancel ボタンのデザイン
                                    },.cancel(Text("キャンセル"))
                                ])
                }
            
        }
    }
    
    struct EditTODO_Previews: PreviewProvider {
        static var context = (UIApplication.shared.delegate as! AppDelegate)
            .persistentContainer.viewContext // DB操作対応
        static var previews: some View {
            let edit = TODOEntity(context: context)
            return EditTODO(editTODO: edit)
                .environment(\.managedObjectContext, context)
                .environment(\.locale, Locale(identifier: "ja_JP"))
            
        }
    }
}
