//
//  CategoryView.swift
//  TODO-Category
//
//  Created by Hiroaki-Hirabayashi on 2022/01/23.
//

import SwiftUI

/// ToDoを優先度でカテゴリー分けする
struct CategoryView: View {
    
    //MARK: - Properties
    
    // extensionで作成したToDoEntity内のCategory
    var viewCategory: TODOEntity.Category
    //カテゴリー内のTODO数表示
    @State var numberOfTasks = 0
    @State var showList = false
    @State var addNewTaskView = false
    @Environment(\.managedObjectContext) var viewContext
    
    fileprivate func todoNumberCountUpdate() {
        // カテゴリー内のToDo数を更新する
        self.numberOfTasks = TODOEntity.todoNumberCount(in: self.viewContext, category: self.viewCategory)
    }
    
    var body: some View {
        
        let gradient = Gradient(colors: [viewCategory.iconColor(), viewCategory.iconColor().opacity(0.5)])
        let linerGradient = LinearGradient(gradient: gradient, startPoint: .top, endPoint: .bottom)
        
        VStack {
            VStack(alignment: .leading) {
                // extensionで作成したToDoEntity内のCategoryのimage
//                Image(viewCategory.iconImage())
//                    .font(.largeTitle)
                Image(systemName: viewCategory.iconImage())
                    .sheet(isPresented: $showList, onDismiss: { self.todoNumberCountUpdate()}) {
                        /* isPresentedがtrueの時、シート表示 $showListはonTapGestureで制御
                         sheetModifire でシートの中身（content）を指定する
                         */
                        // これを記入しないとDBが動作しない。ToDoList_Previewsに詳細有り
//                        TODOList(todoCategory: self.viewCategory)
//                            .environment(\.managedObjectContext, self.viewContext)
                    }
                Text(viewCategory.iconString())
                Text("・\(numberOfTasks)タスク")
            }
            // ボタンタップでtrueに
            Button(action: {
                self.addNewTaskView = true
            }) {
                Image(systemName: "plus")
                    .foregroundColor(.black)
            }
            // trueでNewTaskをポップアップ
            .sheet(isPresented: $addNewTaskView, onDismiss: {self.todoNumberCountUpdate()}) {
                NewTask(newTsskCategory: self.viewCategory.rawValue)
                    .environment(\.managedObjectContext, self.viewContext)
                // Pickerを日本語化（Previews内のみ）
                    .environment( \.locale, Locale(identifier: "ja_JP"))
            }
            
            Spacer()
        }
        .padding() // 余白
        .frame(maxWidth: .infinity, minHeight: 150) // 横幅最大, 高さの最小固定
        .foregroundColor(.white) // 前景色
        //            .background(categoryViewCategory.iconColor()) // 背景色
        .background(linerGradient)
        .cornerRadius(20) // 角丸に
        .onTapGesture {
            self.showList = true
        }.onAppear() { // view（VStack）が開かれた時に実行される
            self.todoNumberCountUpdate()
        }
    }
}

struct CategoryView_Previews: PreviewProvider {
    static let context = (UIApplication.shared.delegate as! AppDelegate)
        .persistentContainer.viewContext
    
    static var previews: some View {
        Group {
            CategoryView(viewCategory: .priority1st)
            CategoryView(viewCategory: .priority2nd)
            CategoryView(viewCategory: .priority3rd)
            CategoryView(viewCategory: .priority4th)
        }
        .previewLayout(.fixed(width: 200.0, height: 200.0))
        .environment(\.managedObjectContext, context)
    }
    
    /*
     そのままプレビュー表示だとiPhoneサイズのレイアウトにCategoryViewが詰めこられたものになり実際に使うときの表示の参考にならない。
     Groupに格納、previewLayoutでレイアウトサイズを指定すると、実際の表示に近いプレビューになる
     */
}
