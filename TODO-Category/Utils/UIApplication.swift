//
//  UIApplication.swift
//  TODO-Category
//
//  Created by Hiroaki-Hirabayashi on 2022/01/22.
//

import SwiftUI

extension UIApplication {
    /// キーボードを閉じる
    func closeKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder),
                   to: nil,
                   from: nil,
                   for: nil)
    }
}

