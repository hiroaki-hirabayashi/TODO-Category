//
//  ContentView.swift
//  TODO-Category
//
//  Created by Hiroaki-Hirabayashi on 2022/01/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    var body: some View {
        VStack(spacing: 0) {
            //.edgesIgnoringSafeArea(.all)にするとアイコンとLabelがSafeAreaを超える為、
            Color.gray
                .edgesIgnoringSafeArea(.top)
                .frame(height: 0)
            
            UserView(image: Image("Catalina"), userName: "User Name")
            
            VStack(spacing: 0) { //viewの間隔
                HStack(spacing: 0) {
                    CategoryView(viewCategory: .priority1st)
                    Spacer() //中心の余白
                    CategoryView(viewCategory: .priority2nd)
                }
                HStack(spacing: 0) {
                    CategoryView(viewCategory: .priority3rd)
                    Spacer() //中心の余白
                    CategoryView(viewCategory: .priority4th)
                }
            }.padding() // 余白
            
            TodayTODO()
        }
        .background(Color.gray) // 背景色
            .edgesIgnoringSafeArea(.bottom) // SafeAreaを超える
    }
}

struct ContentView_Previews: PreviewProvider {
    static var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, context)
        
    }
}
