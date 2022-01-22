//
//  UserView.swift
//  TODO-Category
//
//  Created by Hiroaki-Hirabayashi on 2022/01/23.
//

import SwiftUI

/// ユーザー画面
struct UserView: View {
    
    //MARK: - Properties
    let image: Image
    let userName: String
    
    var body: some View {
        HStack {
            // 左寄せ
            VStack (alignment: .leading) {
                Text("TODO-Category")
                    .foregroundColor(Color.green)
                    .font(.footnote)
                Text("\(userName)")
                    .foregroundColor(Color.green)
                    .font(.title)
            }
            Spacer()
            
            image
                .resizable()
                .frame(width: 60, height: 60)
                .clipShape(Circle())
        }
        //HStackに余白を入れる
        .padding()
            .background(Color.gray)
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            UserView(image: Image("dog"), userName: "User Name")
            Circle()
        }
        .previewLayout(.fixed(width: 335, height: 70))
    }
}
