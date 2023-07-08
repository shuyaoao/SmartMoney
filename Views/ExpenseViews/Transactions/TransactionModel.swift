//
//  TransactionModel.swift
//  SmartMoney
//
//  Created by Dylan Lo on 9/6/23.
//

import Foundation

struct Transaction: Identifiable {
    var id: Int
    var name: String
    var date : String
    var category : Category
    var amount : Double
    var isExpense : Bool // if false, then income
    
    init(id: Int, name: String, date: String, category: Category, amount: Double, isExpense: Bool) {
        self.id = id
        self.name = name
        self.date = date
        self.category = category
        self.amount = amount
        self.isExpense = isExpense
    }
    
    func toDictionary() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        // dictionary["id"] = id excluded
        dictionary["name"] = name
        dictionary["date"] = date
        dictionary["category"] = category.category
        dictionary["amount"] = amount
        dictionary["isExpense"] = isExpense
        
        return dictionary
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
