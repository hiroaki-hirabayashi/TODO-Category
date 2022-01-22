//
//  NewTask.swift
//  TODO-Category
//
//  Created by Hiroaki-Hirabayashi on 2022/01/23.
//

import SwiftUI

struct NewTask: View {
    
    //MARK: - Properties
    
    // ToDo内容を保持
    @State var newTask = ""
    // 日時 nilを持ちたい（optional型）にしたいのでDate?としてます
    @State var selectDateTime: Date? = Date()
    // カテゴリーピッカーの内容を保持
    @State var newTsskCategory = TODOEntity.Category.priority1st.rawValue
    var categoryArray: [TODOEntity.Category] = [
        .priority1st,
        .priority2nd,
        .priority3rd,
        .priority4th
    ]
    
    @Environment(\.managedObjectContext) var viewContext
    // viewの表示制御オブジェクトを取得(dismiss)
    @Environment(\.presentationMode) var presentationMode
    
    
    //MARK: - function
    
    /// データ保存のfunction
    private func save() {
        do {
            try self.viewContext.save()
        } catch {
            let error = error as NSError
            fatalError("エラー\(error), \(error.userInfo)")
        }
    }
    
    
    var body: some View {
        NavigationView {
            Form {
                // TODO入力セクション
                Section(header: Text("ToDo")) {
                    TextField("TODO(やる事)追加", text: $newTask)
                }
                
                /*
                 日時入力セクション
                 Binding(isNotNil: $selectDateTime, defaultValue: Date())
                 selectDateTimeの値がnilかそうでないかをToggleと連動させる（ToggleがONで!=nil OFFでnilが$selectDateTimeに入る）
                 */
                Section(header: Toggle(isOn: Binding(isNotNil: $selectDateTime, defaultValue: Date()), label: { Text("日時") } )) {
                    if selectDateTime != nil {
                        // selectDateTimeがnilでなかったら時間設定表示 nilなら表示しない
                        /*
                         selectionには渡すBindingを設定
                         $selectDateTimeだとoptionalのBindingを渡してしまうのでエラーになる（Date型のBindingを渡さなければならない）
                         Binding($selectDateTime, Date())としてoptionalをBindingする
                         */
                        DatePicker(selection: Binding($selectDateTime, Date()), label: { Text("日時") })
                    } else {
                        Text("未設定").foregroundColor(.secondary)
                    }
                    
                }
                
                // カテゴリーピッカー $categoryにtagの値が入る
                Picker(selection: $newTsskCategory, label: Text("カテゴリー")) {
                    ForEach(categoryArray, id: \.self) { category in
                        HStack {
                            CategoryImage(category)
                            Text(category.iconString())
                        }
                        .tag(category.rawValue)
                    }
                }
                
                // キャンセルセクション
                Section(header: Text("取り消し")) {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack(alignment: .center) {
                            Image(systemName: "minus.circle.fill")
                            Text("キャンセル")
                        }
                        .foregroundColor(.red)
                    }
                }
            }
            .navigationBarTitle("ToDo追加")
                .navigationBarItems(trailing: Button(action: {
                    TODOEntity.create(in: self.viewContext, category: TODOEntity.Category(rawValue: self.newTsskCategory) ?? .priority1st, task: self.newTask, time: self.selectDateTime)
                    self.save()
                    self.presentationMode.wrappedValue.dismiss()
                    
                }) {
                    Text("保存")
                })
        }
    }
}

struct NewTask_Previews: PreviewProvider {
    static var context = (UIApplication.shared.delegate as! AppDelegate)
        .persistentContainer.viewContext // DB操作対応
    static var previews: some View {
        NewTask()
            .environment(\.managedObjectContext, context)
            .environment(\.locale, Locale(identifier: "ja_JP"))
        
        
    }
}
