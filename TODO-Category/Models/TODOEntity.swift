//
//  TODOEntity.swift
//  TODO-Category
//
//  Created by Hiroaki-Hirabayashi on 2022/01/22.
//

import CoreData
import SwiftUI

extension TODOEntity {
    
    /// CoreDateの処理 テストデータ                 //CoreDateのDB操作の為のインスタンス
    static func create(in managedObjectContext: NSManagedObjectContext,
                       category: Category,
                       task: String,
                       time: Date? = Date()){
        let todo = self.init(context: managedObjectContext)
        print(task)
        todo.time = time
        todo.category = category.rawValue
        todo.task = task
        todo.state = State.todoState.rawValue
        todo.id = UUID().uuidString
        
        do {
            try  managedObjectContext.save() // DBに保存
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    enum Category: Int16 {
        // Important & Urgent (第1領域）
        case priority1st
        // Important & Not Urgent (第2領域）
        case priority2nd
        // Not Important & Urgent（第3領域）
        case priority3rd
        // Not Important & Not Urgent（第4領域）
        case priority4th
        
        /// タイトル文字
        func iconString() -> String {
            switch self {
                case .priority1st:
                    return "優先度1（重要かつ緊急）"
                case .priority2nd:
                    return "優先度2（重要だが緊急ではない）"
                case .priority3rd:
                    return "優先度3（重要でないが緊急）"
                case .priority4th:
                    return "優先度4（重要でも緊急でもない）"
            }
        }
        
        /// TODOカテゴリー画像
        func iconImage() -> String {
            switch self {
                case .priority1st:
                    return "flame"
                case .priority2nd:
                    return "tortoise.fill"
                case .priority3rd:
                    return "alarm"
                case .priority4th:
                    return "tv.music.note"
            }
        }
        
        /// カテゴリーアイコン色
        func iconColor() -> Color {
            switch self {
                case .priority1st:
                    return .red
                case .priority2nd:
                    return .blue
                case .priority3rd:
                    return .green
                case .priority4th:
                    return .yellow
            }
        }
    }
    
    enum State: Int16 {
        case todoState
        case doneState
    }
    
    
    //
    static func todoNumberCount(in managedObjectContext: NSManagedObjectContext,
                                category: Category) -> Int {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TODOEntity")
        // 検索 categoryに一致するものを取得する
        fetchRequest.predicate = NSPredicate(format: "category == \(category.rawValue)")
        
        // DB管理オブジェクト（managedObjectContext）のcountメソッドで検索条件に当てはまるデータの件数を取得する
        do {
            let count = try managedObjectContext.count(for: fetchRequest)
            return count
        } catch  {
            print("Error: \(error.localizedDescription)")
            return 0
        }
    }
}
