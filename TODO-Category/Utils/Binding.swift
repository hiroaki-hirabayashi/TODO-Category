//
//  Binding.swift
//  TODO-Category
//
//  Created by Hiroaki-Hirabayashi on 2022/01/22.
//

import SwiftUI

extension Binding {
    
    /*
     DateのToggleのON OFFで入力未入力を切り替えたい
     オプショナルのDate型をBoolに変換
     任意のBindingを取得しnilかそうでないかによってtrue,falseを返す
     **/
    init<T>(isNotNil source: Binding<T?>, defaultValue: T) where Value == Bool {
        // オプショナルのDate型が入る nilでないならtrue nilならfalse
        self.init(get: { source.wrappedValue != nil },
                  // setにToggle結果が入る trueならdefaultValue、falseならnilがwrappedValueに格納される
                  set: { source.wrappedValue = $0 ? defaultValue : nil })
    }
    
    // DatePickerに渡す$selectDateTimeがoptional型
    init(_ source: Binding<Value?>, _ defaultValue: Value) {
        
        self.init(get:{
            /*
             wrappedValueはoptional型なのでnilになる時がある
             wrappedValueがnilならdefaultValueを格納してnilじゃない状態にする
             */
            if source.wrappedValue == nil {
                source.wrappedValue = defaultValue
            }
            return source.wrappedValue ?? defaultValue
            
        }, set: {
            source.wrappedValue = $0
        })
    }
    
}
