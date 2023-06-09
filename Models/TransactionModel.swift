//
//  TransactionModel.swift
//  SmartMoney
//
//  Created by Dylan Lo on 9/6/23.
//

import Foundation

struct Transaction: Identifiable {
    let id: Int
    let date : String
    let category : String
    let amount : Double
    let isExpense : Bool // if false, then income
}
