//
//  TransactionPreviewData.swift
//  SmartMoney
//
//  Created by Dylan Lo on 9/6/23.
//

import Foundation
import SwiftUI
import Combine

class TransactionDataModel: ObservableObject {
    @Published var transactionDataList: [Transaction] {
        willSet {
            objectWillChange.send()
        }
    }
    
    init(transactionDataList : [Transaction]) {
        self.transactionDataList = transactionDataList
    }
    
    func updateTransactionDataList(with newData: [Transaction]) {
        transactionDataList = newData
    }
}


var transactionPreviewDataList = [
    Transaction(id: 0, name: "Apple", date: "01 Jun 2023", category: utilitiesCategory, amount: 30.00, isExpense: true),
    Transaction(id: 1, name: "Banana", date: "02 Jun 2023", category: groceriesCategory, amount: 15.00, isExpense: true),
    Transaction(id: 2, name: "Orange", date: "03 Jun 2023", category: groceriesCategory, amount: 10.00, isExpense: true)
]

// MARK: The main DataModel used for holding transactions
var transactionDataModel = TransactionDataModel(transactionDataList : transactionPreviewDataList)


