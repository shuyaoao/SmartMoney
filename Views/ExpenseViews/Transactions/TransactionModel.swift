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
