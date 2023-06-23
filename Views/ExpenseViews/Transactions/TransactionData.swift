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
    @Published var totalExpenses : Double {
        didSet {
            objectWillChange.send()
        }
    }
    @Published var totalIncome : Double {
        didSet {
            objectWillChange.send()
        }
    }
    
    @Published var transactionDataList: [Transaction] {
        didSet {
            updateFilteredList()
            objectWillChange.send()
        }
    }
    
    @Published var filteredTransactionDataList: [Transaction] = []
    
    init(transactionDataList : [Transaction]) {
        self.transactionDataList = transactionDataList
        self.totalExpenses = 0.00
        self.totalIncome = 0.00
    }
    
    func updateTransactionDataList(newTransaction : Transaction) {
        transactionDataList = transactionDataList + [newTransaction]
    }
    
    func updateTotalExpenses() {
        let expenseList = filteredTransactionDataList.filter {
            $0.isExpense == true}
            .map {$0.amount}
        
        totalExpenses = expenseList.reduce(0.0, {
            (partialresult, element) in
            return partialresult + element
        })
    }
    
    func updateTotalIncome() {
        let incomeList = filteredTransactionDataList.filter {
            $0.isExpense == false}
            .map {$0.amount}
        
        totalIncome = incomeList.reduce(0.0, {
            (partialresult, element) in
            return partialresult + element
        })
    }
    
    // Call this function to update Filtered Transaction List
    // This will refer to the main dateModel's picked Year and Month
    // and filter accordingly
    func updateFilteredList() {
        filteredTransactionDataList = filterTransactionsByYearAndMonth(year: dateModel.pickedYear, month: dateModel.pickedMonth)
    }
    
    // Function to filter transactions by year and month
    func filterTransactionsByYearAndMonth(year: Int, month: Int) -> [Transaction] {
        let calendar = Calendar.current
        
        let filteredTransactions = self.transactionDataList.filter { transaction in
            // Convert the date string to a Date object
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM yyyy"
            if let transactionDate = dateFormatter.date(from: transaction.date) {
                // Get the year and month components of the transaction date
                let components = calendar.dateComponents([.year, .month], from: transactionDate)
                
                // Compare the year and month components with the provided values
                return components.year == year && components.month == month
            }
            
            return false
        }
        
        // Sort from more recent to latest (Descending Order)
        let sortedTransactions = filteredTransactions.sorted { transaction1, transaction2 in
            // Sort transactions by date in ascending order
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM yyyy"
            
            if let date1 = dateFormatter.date(from: transaction1.date),
               let date2 = dateFormatter.date(from: transaction2.date) {
                return date1 > date2
            }
            
            return false
        }
            
        return sortedTransactions
    }
}

var transactionPreviewDataList = [
    Transaction(id: 0, name: "Apple", date: "01 Jun 2023", category: utilitiesCategory, amount: 30.00, isExpense: true),
    Transaction(id: 1, name: "Banana", date: "02 Jun 2023", category: groceriesCategory, amount: 15.00, isExpense: true),
    Transaction(id: 2, name: "Orange", date: "03 Jun 2023", category: groceriesCategory, amount: 10.00, isExpense: true)
]

// MARK: The main DataModel used for holding transactions
var transactionDataModel = TransactionDataModel(transactionDataList : transactionPreviewDataList)






