//
//  TodayTODO.swift
//  TODO-Category
//
//  Created by Hiroaki-Hirabayashi on 2022/01/23.
//

import SwiftUI

/// メイン画面に表示させる一覧リスト
struct TodayTODO: View {
    // DBテーブルからデータを取得するアノテーション
    @FetchRequest(
        // 取得したデータの並べ替えの条件 この場合はToDoEntityの日時
        sortDescriptors: [NSSortDescriptor(keyPath: \TODOEntity.time,
                                           ascending: true)],
        // 今日の0時から明日の0時までの1日分のデータ
        predicate: NSPredicate(format:"time BETWEEN {%@ , %@}", Date.todayDate as NSDate, Date.tomorrowDate as NSDate),
        animation: .default)
    
    var todayTODO: FetchedResults<TODOEntity>
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("本日のToDo")
                .font(.footnote).bold().padding()
            List(todayTODO) { todo in
                TODODetailRow(observedTODO: todo)
            }
        }.background(Color(UIColor.systemBackground))
        .clipShape(CornerRadius(topRight: 40, topLelt: 40, bottomRight: 0, bottomLeft: 0))
        // viewをclipShapeで切り抜く
        
    }
}

struct TodayTODO_Previews: PreviewProvider {
    static var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    static var previews: some View {
        TodayTODO()
            .environment(\.managedObjectContext, context)
        
    }
}
