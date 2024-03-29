//
//  MonthYear.swift
//  SmartMoney
//
//  Created by Shuyao Li on 19/5/23.
//
import Foundation

class MonthYear {
    var month: Int
    var year: Int
    
    init() {
        let calendar = Calendar.current
        let date = Date()
        month = calendar.component(.month, from: date)
        year = calendar.component(.year, from: date)
    }
    
    init(month: Int, year: Int) {
        self.month = month
        self.year = year
    }
}

extension MonthYear {
    func compare(other: MonthYear) -> Bool {
        return self.year > other.year || self.year == other.year && self.month >= other.month
    }
}
