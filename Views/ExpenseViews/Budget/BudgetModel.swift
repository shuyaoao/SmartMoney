//
//  BudgetModel.swift
//  SmartMoney
//
//  Created by Dylan Lo on 22/6/23.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class BudgetModel : ObservableObject {
    @Published var budgetDataList: [Budget]
    
    init(budgetDataList: [Budget]) {
        self.budgetDataList = budgetDataList
    }
    
    func addBudget(budget : Budget) {
        // if budget is already in the list, do nothing
        if self.isInBudgetList(year: budget.year, month: budget.month) == false {
            self.budgetDataList = self.budgetDataList + [budget]
            
            // Update to database
            let uid = (Auth.auth().currentUser?.uid)!
            let databaseRef = Database.database().reference().child("users")
            let userRef = databaseRef.child(uid)
            
            // Navigate to budget branch
            let budgetRef = userRef.child("budget")
            
            let key = String(budget.year) + "-" + String(budget.month)
            budgetRef.child(key).setValue(budget.toDictionary())
        }
        
    }
    
    func editBudget(budget : Budget) {
        for (index, existingBudget) in budgetDataList.enumerated() {
            if existingBudget.year == budget.year && existingBudget.month == budget.month {
                // Modify the existing budget
                budgetDataList[index] = budget
                break
            }
        }
        
        // Update to database
        let uid = (Auth.auth().currentUser?.uid)!
        let databaseRef = Database.database().reference().child("users")
        let userRef = databaseRef.child(uid)
        
        // Navigate to budget branch
        let budgetRef = userRef.child("budget")
        
        let key = String(budget.year) + "-" + String(budget.month)
        budgetRef.child(key).setValue(budget.toDictionary())
        
    }
    
    func searchBudget(year : Int, month : Int) -> Budget {
        for (_, existingBudget) in budgetDataList.enumerated() {
            if existingBudget.year == year && existingBudget.month == month {
                // Return existingBudget
                return existingBudget
            }
        }
        // If budget not found, return a new budget
        let newBudget = Budget(budgetAmount: 200, year: year, month: month)
        // add new budget to the list and return it
        addBudget(budget: newBudget)
        return newBudget
    }
    
    func isInBudgetList(year : Int, month : Int) -> Bool {
        for (_, existingBudget) in budgetDataList.enumerated() {
            if existingBudget.year == year && existingBudget.month == month {
                // Return existingBudget
                return true
            }
        }
        return false
    }
}

class Budget {
    var budgetAmount : Int
    var year : Int
    var month : Int
    
    init(budgetAmount: Int, year: Int, month: Int) {
        self.budgetAmount = budgetAmount
        self.year = year
        self.month = month
    }
    
    func toDictionary() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        // dictionary["id"] = id excluded
        dictionary["budgetAmount"] = budgetAmount
        dictionary["year"] = year
        dictionary["month"] = month
        return dictionary
    }
}


var presetBudget = [Budget(budgetAmount: 200, year: 1990, month: 2)]

var budgetModel = BudgetModel(budgetDataList: presetBudget)


// MARK: Used for Budget Progress Bar Calculation
class BudgetProgress : ObservableObject {
    @Published var progress : Double
    
    init() {
        let searchedBudget = budgetModel.searchBudget(year: dateModel.pickedYear, month: dateModel.pickedMonth)
        self.progress = Double(transactionDataModel.totalExpenses) / Double(searchedBudget.budgetAmount)
    }
    
    func budgetProgressRefresh() {
        let searchedBudget = budgetModel.searchBudget(year: dateModel.pickedYear, month: dateModel.pickedMonth)
        var newProgress = Double(transactionDataModel.totalExpenses) / Double(searchedBudget.budgetAmount)
        print(newProgress)
        if newProgress >= 1.0 {
            newProgress = 1.0
        }
        self.progress = newProgress
    }
}

var budgetProgressModel = BudgetProgress()

