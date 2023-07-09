//
//  BalanceController.swift
//  SmartMoney
//
//  Created by Shuyao Li on 16/6/23.
//

import Foundation

class BalanceController {
    
    func updateExpenses(_ payer: User, _ splits: [Split], _ amount: Double) {
        var payerUserExpense = payer.userExpenseBalance
        payerUserExpense.totalPayment += amount
        
        for split: Split in splits {
            var userOwe = split.user
            var userOweExpense = userOwe.userExpenseBalance
            var amountOwed = split.amount
            
            if payer.id == userOwe.id {
                payerUserExpense.totalYourExpense += amountOwed
            } else {
                payerUserExpense.totalYouGetBack += amountOwed
                
                var userOweBalance: Balance
                if payerUserExpense.UserVsBalance[userOwe] != nil {
                    userOweBalance = payerUserExpense.UserVsBalance[userOwe]!
                } else {
                    userOweBalance = Balance()
                    payerUserExpense.UserVsBalance[userOwe] = userOweBalance
                }
                userOweBalance.amountGetBack += amountOwed
                
                userOweExpense.totalYouOwe += amountOwed
                userOweExpense.totalYourExpense += amountOwed
                userOweExpense.updateCredit()
                payerUserExpense.updateCredit()
                
                var userPaidBalance: Balance
                if userOweExpense.UserVsBalance[payer] != nil {
                    userPaidBalance = userOweExpense.UserVsBalance[payer]!
                } else {
                    userPaidBalance = Balance()
                    userOweExpense.UserVsBalance[payer] = userPaidBalance
                }
                userPaidBalance.amountOwe += amountOwed
            }
        }
    }
    
//    func showBalanceSheetOfUser(_ user: User) {
//        print("---------------------------------------")
//        print("Balance sheet of user : " + user.name)
//        let userExpenseBalanceSheet =  user.userExpenseBalance
//        print("TotalYourExpense: " + String(format: "%.2f", userExpenseBalanceSheet.totalYourExpense))
//        print("TotalGetBack: " + String(format: "%.2f", userExpenseBalanceSheet.totalYouGetBack))
//        print("TotalYourOwe: " + String(format: "%.2f", userExpenseBalanceSheet.totalYouOwe))
//        print("TotalPaymentMade: " + String(format: "%.2f", userExpenseBalanceSheet.totalPayment))
//        print("TotalCredit: " + String(format: "%.2f", userExpenseBalanceSheet.credit))
//        for (name, balance) in userExpenseBalanceSheet.UserVsBalance {
//            print(String(format: "Name: %@, YouGetBack: %.2f, YouOwe: %.2f", name, balance.amountGetBack, balance.amountOwe))
//        }
//        print("---------------------------------------");
//    }
}
