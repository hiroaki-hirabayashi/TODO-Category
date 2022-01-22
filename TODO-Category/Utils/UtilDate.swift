//
//  UtilDate.swift
//  TODO-Category
//
//  Created by Hiroaki-Hirabayashi on 2022/01/22.
//
import Foundation

extension Date {
    //「時分秒」なしの今日の日付を作成
    static var todayDate : Date {
        let calendar = Calendar(identifier: .gregorian)
        let time = Date()
        let today = calendar.startOfDay(for: time)
        return today
    }
    //「時分秒」なしの明日の日付を作成
    static var tomorrowDate : Date {
        let calendar = Calendar(identifier: .gregorian)
        let tomorrow = calendar.date(byAdding: DateComponents(day: 1), to: Date.todayDate)!
        return tomorrow
    }
}
