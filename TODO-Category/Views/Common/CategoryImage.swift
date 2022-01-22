//
//  CategoryImage.swift
//  TODO-Category
//
//  Created by Hiroaki-Hirabayashi on 2022/01/23.
//

import SwiftUI

// ToDoDetailRowに表示するためのアイコン画像
struct CategoryImage: View {
    /// TODOEntityのenum
    var categoryImage: TODOEntity.Category
    
    init(_ category: TODOEntity.Category?) {
        self.categoryImage = category ?? .priority1st
    }
    
    var body: some View {
//        Image(systemName: "tortoise.fill")
        Image(systemName: categoryImage.iconImage())
            .resizable()
            .scaledToFit()
            .foregroundColor(.white)
            // アイコンの余白
            .padding(2.0)
            .frame(width: 30, height: 30)
//            .background(Color(.systemBlue)) //背景色
            //背景色
            .background(categoryImage.iconColor())
            //アイコンの角を丸く
            .cornerRadius(6.0)
    }
}

struct CategoryImage_Previews: PreviewProvider {
    static var previews: some View {
        CategoryImage(TODOEntity.Category.priority1st)
            .previewLayout(.fixed(width: 335, height: 48))

    }
}
