//
//  Group.swift
//  SmartMoney
//
//  Created by Shuyao Li on 4/6/23.
//

import Foundation

class Group: Comparable {
    var groupMembers : [User]
    var owedAmount : Double
    var groupName : String
    var expenseList: [GroupExpense]
    var expenseController: ExpenseController
    let id: String
    let simplifier = GroupDebtSimplifier()
    var dateCreated: Date
    
    static func < (lhs: Group, rhs: Group) -> Bool {
        return lhs.dateCreated <= rhs.dateCreated
    }
    
    static func == (lhs: Group, rhs: Group) -> Bool {
        return lhs.id == rhs.id
    }
    
    init(_ groupName: String) {
        self.groupMembers = [User]()
        self.owedAmount = 0.00
        self.groupName = groupName
        self.expenseList = [GroupExpense]()
        self.expenseController = ExpenseController()
        self.id = UUID().uuidString
        self.dateCreated = Date()
    }
    
//    init(_ owedAmount: Double, _ name: String) {
//        //this constructor will be removed after database has been implemented
//        self.groupMembers = [User]()
//        self.owedAmount = owedAmount
//        self.groupName = name
//        self.expenseList = [GroupExpense]()
//        self.expenseController = ExpenseController()
//        self.id = UUID().uuidString
//    }
//
//    init(_ owedAmount: Double, _ name: String, _ groupMembers: [User]) {
//        //this constructor will be removed after database has been implemented
//        self.groupMembers = groupMembers
//        self.owedAmount = owedAmount
//        self.groupName = name
//        self.expenseList = [GroupExpense]()
//        self.expenseController = ExpenseController()
//        self.id = UUID().uuidString
//    }
    
    init(_ owedAmount: Double, _ name: String, _ groupMembers: [User], _ expenseList: [GroupExpense], _ id: String, _ dateCreated: Date) {
        self.groupMembers = groupMembers
        self.owedAmount = owedAmount
        self.groupName = name
        self.expenseList = expenseList
        self.expenseController = ExpenseController()
        self.id = id
        for user in self.groupMembers {
            self.simplifier.userController.addUser(user)
        }
        self.dateCreated = dateCreated
    }
    
    func addMember(_ member: User) {
        self.groupMembers.append(member)
    }
    
    func createExpense(_ payer: User, _ amount: Double, _ date: Date, _ splits: [Split], _ description: String, _ splitType: SplitType, _ category: Category) -> GroupExpense {
        let expense = expenseController.createExpense(payer, amount, date, splits, description, splitType, category)
        expenseList.append(expense)
        expenseList.sort()
        return expense
    }
    
    func createExpense(_ payer: User, _ amount: Double, _ date: Date, _ splits: [Split]) -> GroupExpense {
        let expense = expenseController.createExpense(payer, amount, date, splits, "Payup", SplitType(id: "Equally"), othersCategory)
        expenseList.append(expense)
        expenseList.sort { expense1, expense2 in
            expense1.date > expense2.date
        }
        return expense
    }
    
    func updateTotalBalance() {
        self.owedAmount = self.simplifier.getBalances(self.expenseList)[myself] ?? 0
    }
    
    func toDictionary() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        dictionary["id"] = id
        dictionary["groupName"] = groupName
        dictionary["owedAmount"] = owedAmount
        var membersDict: [String: Any] = [:]
        for member in groupMembers {
            membersDict[member.id] = member.name
        }
        dictionary["groupMembers"] = membersDict
        var expenseDict: [String: Any] = [:]
        for expense in expenseList {
            expenseDict[expense.id] = expense.toDictionary()
        }
        dictionary["expenseList"] = expenseDict
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YY, MMM d, HH:mm:ss"
        dictionary["dateCreated"] = dateFormatter.string(from: dateCreated)
        return dictionary
    }
}
