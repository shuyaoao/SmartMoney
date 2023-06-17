//
//  GroupExpense.swift
//  SmartMoney
//
//  Created by Shuyao Li on 4/6/23.
//

import Foundation

class GroupExpense {
    
    let payer: User
    let amount: Double
    let date: Date
    var splits = [Split]()
    let description: String
    let splitType: SplitType
    let id : String
    
    
    init(_ payer: User, _ amount: Double, _ date: Date, _ splits: [Split], _ description: String, _ splitType: SplitType) {
        self.payer = payer
        self.amount = amount
        self.date = date
        self.splits.append(contentsOf: splits)
        self.description = description
        self.splitType = splitType
        self.id = UUID().uuidString
    }
    
    func validate() -> Bool {
        return true
    }
    
}
