//
//  Group.swift
//  SmartMoney
//
//  Created by Shuyao Li on 4/6/23.
//

import Foundation

class Group {
    var groupMembers : [User]
    var owedAmount : Double
    var groupName : String
    var expenseList: [GroupExpense]
    var expenseController: ExpenseController
    let id: String
    let simplifier = GroupDebtSimplifier()
    
    init(_ groupName: String) {
        self.groupMembers = [User]()
        self.owedAmount = 0.00
        self.groupName = groupName
        self.expenseList = [GroupExpense]()
        self.expenseController = ExpenseController()
        self.id = UUID().uuidString
    }
    
    init(_ owedAmount: Double, _ name: String) {
        //this constructor will be removed after database has been implemented
        self.groupMembers = [User]()
        self.owedAmount = owedAmount
        self.groupName = name
        self.expenseList = [GroupExpense]()
        self.expenseController = ExpenseController()
        self.id = UUID().uuidString
    }
    
    init(_ owedAmount: Double, _ name: String, _ groupMembers: [User]) {
        //this constructor will be removed after database has been implemented
        self.groupMembers = groupMembers
        self.owedAmount = owedAmount
        self.groupName = name
        self.expenseList = [GroupExpense]()
        self.expenseController = ExpenseController()
        self.id = UUID().uuidString
    }
    
    func addMember(_ member: User) {
        self.groupMembers.append(member)
    }
    
    func createExpense(_ payer: User, _ amount: Double, _ date: Date, _ splits: [Split], _ description: String, _ splitType: SplitType) -> GroupExpense {
        let expense = expenseController.createExpense(payer, amount, date, splits, description, splitType)
        expenseList.append(expense)
        expenseList.sort()
        return expense
    }
    
    func createExpense(_ payer: User, _ amount: Double, _ date: Date, _ splits: [Split]) -> GroupExpense {
        let expense = expenseController.createExpense(payer, amount, date, splits, "Payup", SplitType(id: "Equally"))
        expenseList.append(expense)
        expenseList.sort { expense1, expense2 in
            expense1.date > expense2.date
        }
        return expense
    }
    
    func updateTotalBalance() {
        self.owedAmount = self.simplifier.getBalances(self.expenseList)[myself] ?? 0
    }
}
