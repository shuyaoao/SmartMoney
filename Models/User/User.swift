//
//  User.swift
//  SmartMoney
//
//  Created by Shuyao Li on 9/6/23.
//

import Foundation

class User: Hashable {
    
    var name: String
    var userExpenseBalance: UserExpenseBalance
    let id: String
    
    //comparing two users
    static func == (lhs: User, rhs: User) -> Bool {
        if lhs.id == rhs.id {
            return true
        }
        return false
    }
    
    init(_ name: String) {
        self.name = name
        self.userExpenseBalance = UserExpenseBalance()
        self.id = UUID().uuidString
    }
    
    init(_ id: String, _ name: String) {
        self.id = id
        self.name = name
        self.userExpenseBalance = UserExpenseBalance()
    }
    
    func changeName(_ name: String) {
        self.name = name
    }
    
    //ID uniquely identifies a user
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    func toDictionary() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        dictionary["id"] = id
        dictionary["name"] = name
        return dictionary
    }
}
