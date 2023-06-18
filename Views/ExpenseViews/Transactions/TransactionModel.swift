//
//  TransactionModel.swift
//  SmartMoney
//
//  Created by Dylan Lo on 9/6/23.
//

import Foundation

struct Transaction: Identifiable {
    let id: Int
    let name: String
    let date : String
    let category : Category
    let amount : Double
    let isExpense : Bool // if false, then income
    
    init(id: Int, name: String, date: String, category: Category, amount: Double, isExpense: Bool) {
        self.id = id
        self.name = name
        self.date = date
        self.category = category
        self.amount = amount
        self.isExpense = isExpense
    }
    
    
}

// This transaction class is used to monitor the pending transaction that is about to be added.
struct selectedTransaction {
    var id: Int?
    var name: String?
    var date : String?
    var category : Category?
    var amount : Double?
    var isExpense : Bool? // if false, then income
}
