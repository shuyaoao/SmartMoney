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
    var totalExpenses : Double
    var totalIncome : Double
    
    // Referencing to dateModel's pickedYear and pickedMonth
    // for filtering of transaction data
    var pickedYear = dateModel.pickedYear
    var pickedMonth = dateModel.pickedMonth
    
    @Published var transactionDataList: [Transaction] {
        willSet {
            objectWillChange.send()
        }
    }
    
    init(transactionDataList : [Transaction]) {
        self.transactionDataList = transactionDataList
        self.totalExpenses = 0.00
        self.totalIncome = 0.00
    }
    
    func updateTransactionDataList(newTransaction : Transaction) {
        transactionDataList = transactionDataList + [newTransaction]
    }
    
    func updateTotalExpenses() {
        let expenseList = transactionDataList.filter {
            $0.isExpense == true}
            .map {$0.amount}
        
        totalExpenses = expenseList.reduce(0.0, {
            (partialresult, element) in
            return partialresult + element
        })
    }
    
    func updateTotalIncome() {
        let incomeList = transactionDataList.filter {
            $0.isExpense == false}
            .map {$0.amount}
        
        totalIncome = incomeList.reduce(0.0, {
            (partialresult, element) in
            return partialresult + element
        })
    }
}


var transactionPreviewDataList = [
    Transaction(id: 0, name: "Apple", date: "01 Jun 2023", category: utilitiesCategory, amount: 30.00, isExpense: true),
    Transaction(id: 1, name: "Banana", date: "02 Jun 2023", category: groceriesCategory, amount: 15.00, isExpense: true),
    Transaction(id: 2, name: "Orange", date: "03 Jun 2023", category: groceriesCategory, amount: 10.00, isExpense: true)
]

// MARK: The main DataModel used for holding transactions
var transactionDataModel = TransactionDataModel(transactionDataList : transactionPreviewDataList)





// Extract Year and Month from Date Strings like 03 Jun 2023
func extractYearAndMonth(from dateString: String) -> (year: Int, month: Int)? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd MMM yyyy"
    
    if let date = dateFormatter.date(from: dateString) {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        return (year, month)
    } else {
        return nil
    }
}
