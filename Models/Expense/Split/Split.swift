//
//  Split.swift
//  SmartMoney
//
//  Created by Shuyao Li on 16/6/23.
//

import Foundation

class Split {
    var user: User
    var amount: Double
    
    init(user: User, amount: Double) {
        self.user = user
        self.amount = amount
    }
    
    func setUser(_ user: User) {
        self.user = user
    }
    
    func setAmount(_ amt: Double) {
        self.amount = amt
    }
    
}
