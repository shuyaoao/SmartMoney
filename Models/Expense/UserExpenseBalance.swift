//
//  UserExpenseBalance.swift
//  SmartMoney
//
//  Created by Shuyao Li on 16/6/23.
//

import Foundation

class UserExpenseBalance {
    var UserVsBalance: Dictionary<String, Balance>
    var totalYourExpense: Double
    var totalPayment: Double
    var totalYouOwe: Double
    var totalYouGetBack: Double
    var credit: Double
    
    init() {
        self.UserVsBalance = Dictionary<String, Balance>()
        self.totalYourExpense = 0.0
        self.totalPayment = 0.0
        self.totalYouOwe = 0.0
        self.totalYouGetBack = 0.0
        self.credit = 0.0
    }
    
    func updateCredit() {
        self.credit = self.totalYouGetBack - self.totalYouOwe
    }
}
