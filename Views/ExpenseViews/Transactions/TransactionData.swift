//
//  TransactionPreviewData.swift
//  SmartMoney
//
//  Created by Dylan Lo on 9/6/23.
//

import Foundation
import SwiftUI
import Combine
import FirebaseDatabase
import FirebaseAuth

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
    
    // Delete Transactions according to its unique id
    func removeTransaction(id : Int) {
        // Remove for UI purposes
        self.transactionDataList.removeAll { $0.id == id }
        
        // Remove from database
        let user = Auth.auth().currentUser
        let databaseRef = Database.database().reference().child("users")
        let userRef = databaseRef.child(user!.uid)
        let transactionsRef = userRef.child("transactions")
        
        transactionsRef.child(String(id)).removeValue { error, _ in
            if let error = error {
                print("Error removing value: \(error.localizedDescription)")
            } else {
                print("Value removed successfully.")
            }
        }
        // reset id into incrementing order
        
        print("Before")
        print(transactionDataList)
        resetTransactionIndexes()
        print("After")
        print(transactionDataList)
    }
    
    // Append new Transaction to existing transaction data list
    func updateTransactionDataList(newTransaction : Transaction) {
        // Add internally
        transactionDataList = transactionDataList + [newTransaction]
        
        // Add to database
        let user = Auth.auth().currentUser
        let databaseRef = Database.database().reference().child("users")
        let userRef = databaseRef.child(user!.uid)
        let transactionsRef = userRef.child("transactions")
        
        // Add new transaction with id = length of datalist
        transactionsRef.child(String(newTransaction.id)).setValue(newTransaction.toDictionary())
        print("Added Transactions to Database")
    }
    
    // Reset Index of all Transactions in transaction datalist
    func resetTransactionIndexes() {
        // Reset index in database
        let user = Auth.auth().currentUser
        let databaseRef = Database.database().reference().child("users")
        let userRef = databaseRef.child(user!.uid)
        let transactionsRef = userRef.child("transactions")
        
        for (index, _) in transactionDataList.enumerated() {
            if index == transactionDataList.count - 1 {
                transactionsRef.child(String(index + 1)).removeValue()
            }
            transactionDataList[index].id = index
            transactionsRef.child(String(index)).setValue(transactionDataList[index].toDictionary())
        }
        
    }
    
    // Reduce function to cumulate totalExpenses
    func updateTotalExpenses() {
        let expenseList = filteredTransactionDataList.filter {
            $0.isExpense == true}
            .map {$0.amount}
        
        totalExpenses = expenseList.reduce(0.0, {
            (partialresult, element) in
            return partialresult + element
        })
    }
    
    // Reduce function to cumulate totalIncome
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
    
    func getPastSixMonthsExpenses() -> [(String, Int)] {
        var monthYearList = getPastMonthYearList()
        var expenseList : [Double] = []
        
        for monthYear in monthYearList {
            var transactionsMonthYear = filterTransactionsByYearAndMonth(year: monthYear.year, month: monthYear.month)
            // Filter Expenses only and Sum all Amount up
            let monthExpenses = transactionsMonthYear.filter {
                $0.isExpense == true}
                .map {$0.amount}
                .reduce(0.0, {
                    (partialresult, element) in
                    return partialresult + element
                })
            expenseList.append(monthExpenses)
        }
        
        var result : [(String, Int)] = []
        
        for i in 0..<6 {
            let monthYear = monthYearList[i]
            let year = monthYear.year
            let month = monthYear.month
            
            let expense = expenseList[i]
            let yearMonthLabel = String(year) + "-" + String(month)
            result.append((yearMonthLabel, Int(expense)))
        }
        
        return result
    }
}

// MARK: Pull Data from Database
var transactionPreviewDataList = [Transaction(id: 0, name: "Sample", date: "01 July 1990", category: utilitiesCategory, amount: 10.00, isExpense: true)]

// MARK: The main DataModel used for holding transactions
var transactionDataModel = TransactionDataModel(transactionDataList : transactionPreviewDataList)


func getPastMonthYearList() -> [(month: Int, year: Int)] {
    let calendar = Calendar.current
    let endDate = Date()
    let startDate = calendar.date(byAdding: .month, value: -5, to: endDate)!
    
    var currentDate = startDate
    var monthYearList: [(month: Int, year: Int)] = []
    
    while currentDate <= endDate {
        let month = calendar.component(.month, from: currentDate)
        let year = calendar.component(.year, from: currentDate)
        let monthYear = (month, year)
        
        monthYearList.append(monthYear)
        
        if let nextDate = calendar.date(byAdding: .month, value: 1, to: currentDate) {
            currentDate = nextDate
        } else {
            break
        }
    }
    
    return monthYearList
}
