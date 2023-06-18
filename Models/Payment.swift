//
//  Payment.swift
//  SmartMoney
//
//  Created by Shuyao Li on 19/6/23.
//

import Foundation

class Payment {
    var payer: User
    var payee: User
    var amount: Double
    
    init(_ payer: User, _ payee: User, _ amount: Double) {
        self.payer = payer
        self.payee = payee
        self.amount = amount
    }
}
