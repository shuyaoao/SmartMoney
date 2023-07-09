//
//  GroupExpense.swift
//  SmartMoney
//
//  Created by Shuyao Li on 4/6/23.
//

import Foundation

class GroupExpense: Comparable {
    static func < (lhs: GroupExpense, rhs: GroupExpense) -> Bool {
        return lhs.date >= rhs.date
    }
    
    static func == (lhs: GroupExpense, rhs: GroupExpense) -> Bool {
        return lhs.id == rhs.id
    }
    
    
    let payer: User
    let amount: Double
    let date: Date
    var splits = [Split]()
    let description: String
    let splitType: SplitType
    let id : String
    let isInvolved = false
    let owedAmount = 0
    var type = "Expense"
    let category: Category
    
    
    init(_ payer: User, _ amount: Double, _ date: Date, _ splits: [Split], _ description: String, _ splitType: SplitType, _ category: Category) {
        self.payer = payer
        self.amount = amount
        self.date = date
        self.splits.append(contentsOf: splits)
        self.description = description
        self.splitType = splitType
        self.id = UUID().uuidString
        self.category = category
    }
    
    init(_ payer: User, _ amount: Double, _ date: Date, _ splits: [Split], _ description: String, _ splitType: SplitType, _ category: Category, _ id: String) {
        self.payer = payer
        self.amount = amount
        self.date = date
        self.splits.append(contentsOf: splits)
        self.description = description
        self.splitType = splitType
        self.id = id
        self.category = category
    }
    
    init(_ payer: User, _ amount: Double, _ date: Date, _ splits: [Split], _ description: String, _ splitType: SplitType) {
        self.payer = payer
        self.amount = amount
        self.date = date
        self.splits.append(contentsOf: splits)
        self.description = description
        self.splitType = splitType
        self.id = UUID().uuidString
        self.category = foodCategory
    }
    
    init(_ payer: User, _ amount: Double, _ date: Date, _ splits: [Split]) {
        self.payer = payer
        self.amount = amount
        self.date = date
        self.splits.append(contentsOf: splits)
        self.description = "Payment"
        self.splitType = SplitType(id: "Equally")
        self.id = UUID().uuidString
        self.type = "Payup"
        self.category = othersCategory
    }
    
    func validate() -> Bool {
        return true
    }
    
    func toDictionary() -> [String: Any] {
        var dictionary: [String: Any] = [:]

        dictionary["description"] = description
        dictionary["payer"] = payer.toDictionary()
        dictionary["category"] = category.category
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YY, MMM d, HH:mm:ss"
        dictionary["date"] = dateFormatter.string(from: date)
        dictionary["splitType"] = splitType.id
        dictionary["type"] = type
        dictionary["amount"] = amount
        var subDict: [String: Any] = [:]
        for split in splits {
            subDict[split.user.id] = split.amount
        }
        dictionary["splits"] = subDict
        return dictionary
    }
    
}
