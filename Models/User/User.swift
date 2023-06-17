//
//  User.swift
//  SmartMoney
//
//  Created by Shuyao Li on 9/6/23.
//

import Foundation

class User {
    
    var name: String
    var paidBySelected = false
    var splitBtwSelected = false
    var from = false
    var to = false
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
}
