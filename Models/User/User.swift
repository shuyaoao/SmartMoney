//
//  User.swift
//  SmartMoney
//
//  Created by Shuyao Li on 9/6/23.
//

import Foundation

class User: Hashable {
    
    //comparing two users
    static func == (lhs: User, rhs: User) -> Bool {
        if lhs.id == rhs.id {
            return true
        }
        return false
    }
    
    var name: String
    var userExpenseBalance: UserExpenseBalance
    let id: String
    
    
    init(_ name: String) {
        self.name = name
        self.userExpenseBalance = UserExpenseBalance()
        self.id = UUID().uuidString
    }
    
    func changeName(_ name: String) {
        self.name = name
    }
    
    //ID uniquely identifies a user
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
