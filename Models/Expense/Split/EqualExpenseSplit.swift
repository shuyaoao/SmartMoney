//
//  EqualExpenseSplit.swift
//  SmartMoney
//
//  Created by Shuyao Li on 16/6/23.
//

import Foundation

class EqualExpenseSplit : ExpenseSplit {
    func validateSplitRequest(_ splits: [Split], _ amount: Double) -> Bool {
        let amountShouldBePresent = amount / Double(splits.count)
        for split in splits {
            if split.amount != amountShouldBePresent {
                return false
            }
        }
        return true
    }
}
