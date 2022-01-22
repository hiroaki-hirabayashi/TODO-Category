//
//  TODODetailRow.swift
//  TODO-Category
//
//  Created by Hiroaki-Hirabayashi on 2022/01/23.
//

import SwiftUI

struct TODODetailRow: View {
    /*
     @ObservedObject 変数が持つメンバーに変更があれば画面に反映
     @State
     */
    @ObservedObject var observedTODO: TODOEntity
    var hideIcon = false
    
    var body: some View {
        HStack {
            if !hideIcon {
                // DBからintgerを取得してrawValueでenumに変換
                CategoryImage(TODOEntity.Category(rawValue: observedTODO.category))
            }
            
            // ToDoEntityのstate（状態）がintなのでBoolに変換する
            CheckBox(checked: Binding(get: {
                // stateがdoneであればtrue
                self.observedTODO.state == TODOEntity.State.doneState.rawValue
            }, set: {
                // CheckBoxからの値（$0）を受け取って0か1に設定する
                self.observedTODO.state = $0 ? TODOEntity.State.doneState.rawValue : TODOEntity.State.todoState.rawValue
            })) {
                // stateの状態が完了であればstrikethrough（取り消し線）を表示し、未完了であればそのまま表示
                if self.observedTODO.state == TODOEntity.State.doneState.rawValue {
                    Text(self.observedTODO.task ?? "no title").strikethrough()
                } else {
                    Text(self.observedTODO.task ?? "no title")
                }
            }
            // stateが完了であれば文字色をグレー 未完了なら黒
            .foregroundColor(self.observedTODO.state == TODOEntity.State.doneState.rawValue ? .secondary : .primary)
        }
        // ジェスチャー ドラッグした場合、座標情報がvalueに入る
        .gesture(DragGesture().onChanged({ value in
            // 指の位置が横方向（左）に200以上移動したら処理を始める
            if value.predictedEndTranslation.width > 200 {
                // observedTODO.stateの状態が完了でなければ完了にする
                if self.observedTODO.state != TODOEntity.State.doneState.rawValue {
                    self.observedTODO.state = TODOEntity.State.doneState.rawValue
                }
            } else if value.predictedEndTranslation.width < -200 {
                // observedTODO.stateの状態が未完了でなければ未完了にする
                if self.observedTODO.state != TODOEntity.State.todoState.rawValue {
                    self.observedTODO.state = TODOEntity.State.todoState.rawValue
                }
            }
        }))
    }
}



struct TodoDetailRow_Previews: PreviewProvider {
    static var previews: some View {
        // DB操作のためのcontext取得
        let context = (UIApplication.shared.delegate as! AppDelegate)
            .persistentContainer.viewContext
        
        // contextをToDoEntityのイニシャライザに渡してインスタンス化
        let newTODO0 = TODOEntity(context: context)
        newTODO0.task = "優先度1"
        newTODO0.state = TODOEntity.State.todoState.rawValue
        newTODO0.category = 0
        
        let newTODO1 = TODOEntity(context: context)
        newTODO1.task = "優先度2"
        newTODO1.state = TODOEntity.State.todoState.rawValue
        newTODO1.category = 1
        
        let newTODO2 = TODOEntity(context: context)
        newTODO2.task = "優先度3"
        newTODO2.state = TODOEntity.State.todoState.rawValue
        newTODO2.category = 2
        
        let newTODO3 = TODOEntity(context: context)
        newTODO3.task = "優先度4"
        newTODO3.state = TODOEntity.State.todoState.rawValue
        newTODO3.category = 3
        
        
        
        return VStack(alignment: .leading) {
            VStack {
                TODODetailRow(observedTODO: newTODO0)
                TODODetailRow(observedTODO: newTODO0, hideIcon: true)
                TODODetailRow(observedTODO: newTODO1)
                TODODetailRow(observedTODO: newTODO2)
                TODODetailRow(observedTODO: newTODO3)
            }.environment(\.managedObjectContext, context)
        }
    }
}
