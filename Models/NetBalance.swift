//
//  NetBalance.swift
//  SmartMoney
//
//  Created by Shuyao Li on 18/6/23.
//

import Foundation

class NetBalance {
    var user: User
    var balance: Double
    
    init(_ user: User, _ balance: Double) {
        self.user = user
        self.balance = balance
    }
}
