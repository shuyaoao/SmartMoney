//
//  GroupExpense.swift
//  SmartMoney
//
//  Created by Shuyao Li on 4/6/23.
//

import Foundation

class GroupExpense: Comparable {
    static func < (lhs: GroupExpense, rhs: GroupExpense) -> Bool {
        return lhs.date >= rhs.date
    }
    
    static func == (lhs: GroupExpense, rhs: GroupExpense) -> Bool {
        return lhs.id == rhs.id
    }
    
    
    let payer: User
    let amount: Double
    let date: Date
    var splits = [Split]()
    let description: String
    let splitType: SplitType
    let id : String
    let isInvolved = false
    let owedAmount = 0
    var type = "Expense"
    
    
    init(_ payer: User, _ amount: Double, _ date: Date, _ splits: [Split], _ description: String, _ splitType: SplitType) {
        self.payer = payer
        self.amount = amount
        self.date = date
        self.splits.append(contentsOf: splits)
        self.description = description
        self.splitType = splitType
        self.id = UUID().uuidString
    }
    
    init(_ payer: User, _ amount: Double, _ date: Date, _ splits: [Split]) {
        self.payer = payer
        self.amount = amount
        self.date = date
        self.splits.append(contentsOf: splits)
        self.description = "Payment"
        self.splitType = SplitType(id: "Equally")
        self.id = UUID().uuidString
        self.type = "Payup"
    }
    
    func validate() -> Bool {
        return true
    }
    
}
