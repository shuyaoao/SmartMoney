//
//  ExpenseData.swift
//  SmartMoney
//
//  Created by Shuyao Li on 16/6/23.
//

import Foundation

struct ExpenseData {
    var name: String
    
    init(name: String) {
        self.name = name
    }
    
    mutating func setName(_ name: String) {
        self.name = name
    }
}
