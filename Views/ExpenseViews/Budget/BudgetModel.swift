//
//  BudgetModel.swift
//  SmartMoney
//
//  Created by Dylan Lo on 22/6/23.
//

import Foundation

class BudgetModel : ObservableObject {
    @Published var budgetDataList: [Budget]
    
    init(budgetDataList: [Budget]) {
        self.budgetDataList = budgetDataList
    }
    
    func addBudget(budget : Budget) {
        // if budget is already in the list, do nothing
        if self.isInBudgetList(year: budget.year, month: budget.month) == false {
            self.budgetDataList = self.budgetDataList + [budget]
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
    }
    
    func searchBudget(year : Int, month : Int) -> Budget {
        for (_, existingBudget) in budgetDataList.enumerated() {
            if existingBudget.year == year && existingBudget.month == month {
                // Return existingBudget
                return existingBudget
            }
        }
        // If budget not found, return a new budget
        let newBudget = Budget(budgetAmount: 0, year: year, month: month)
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
}

let presetBudget = Budget(budgetAmount: 200, year: thisYear
                          , month: thisMonth)

var budgetModel = BudgetModel(budgetDataList: [presetBudget])


// MARK: Used for Budget Progress Bar Calculation
class BudgetProgress : ObservableObject {
    @Published var progress : Double
    
    init() {
        let searchedBudget = budgetModel.searchBudget(year: dateModel.pickedYear, month: dateModel.pickedMonth)
        self.progress = Double(transactionDataModel.totalExpenses) / Double(searchedBudget.budgetAmount)
    }
    
    func budgetProgressRefresh() {
        let searchedBudget = budgetModel.searchBudget(year: dateModel.pickedYear, month: dateModel.pickedMonth)
        self.progress = Double(transactionDataModel.totalExpenses) / Double(searchedBudget.budgetAmount)
    }
}

var budgetProgressModel = BudgetProgress()

