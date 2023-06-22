//
//  ExpenseService.swift
//  SmartMoney
//
//  Created by Shuyao Li on 16/6/23.
//

import Foundation

struct ExpenseController {
    var balanceController: BalanceController
    
    init() {
        self.balanceController = BalanceController()
    }
    
    func createExpense(_ payer: User, _ amount: Double, _ date: Date, _ splits: [Split], _ description: String, _ splitType: SplitType, _ category: Category) -> GroupExpense {
       
        var expenseSplit = SplitFactory.getSplitObject(splitType)
        expenseSplit.validateSplitRequest(splits, amount)
        
        let expense = GroupExpense(payer, amount, date, splits, description, splitType, category)
        balanceController.updateExpenses(payer, splits, amount)
        
        return expense
    }
}

