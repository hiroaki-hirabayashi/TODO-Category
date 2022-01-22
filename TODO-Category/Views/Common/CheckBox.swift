//
//  CheckBox.swift
//  TODO-Category
//
//  Created by Hiroaki-Hirabayashi on 2022/01/23.
//

import SwiftUI

/// ToDoDetailRowで表示するためのチェックボックス
// 型パラメータ  // 型パラメータの条件
struct CheckBox<Label>: View where Label: View {
    
    // MARK: - Properties
    
    //Binding 他のViewと連携、共有出来るようにする
    @Binding var checked: Bool
    //クロージャー型
    private var label: () -> Label
    
    // @ViewBuilder Viewを改行、並べて列挙して複数のViewを渡す構文が使える
    public init(checked: Binding<Bool>,
                @ViewBuilder label: @escaping () -> Label) {
        self._checked = checked
        self.label = label
    }
    
    
    var body: some View {
        HStack {
            Image(systemName: checked ? "checkmark.circle.fill" : "circle") //trueならcheckmark.circle.fill falseならcircle
                .onTapGesture {
                    self.checked.toggle()
                }
            label()
        }
    }
}

struct CheckBox_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            // Bindingを受け取る時は.constant()を使う
            // CheckBox(checked: .constant(true))
            CheckBox(checked: .constant(false)) {
                Text("SwiftUI")
            }
        }
        .previewLayout(.fixed(width: 335, height: 48))
    }
}
