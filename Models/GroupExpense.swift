//
//  GroupExpense.swift
//  SmartMoney
//
//  Created by Shuyao Li on 4/6/23.
//

import Foundation

class GroupExpense {
    
    let payer: String
    let amount: Double
    let date: Date
    
    
    init(_ payer: String, _ amount: Double, _ date: Date) {
        self.payer = payer
        self.amount = amount
        self.date = date
    }
    
}
