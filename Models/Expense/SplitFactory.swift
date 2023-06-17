//
//  SplitFactory.swift
//  SmartMoney
//
//  Created by Shuyao Li on 16/6/23.
//

import Foundation

class SplitFactory {
    
    static func getSplitObject(_ expenseSplitType: SplitType) -> ExpenseSplit {
        if expenseSplitType.id == "Equally" {
            return EqualExpenseSplit()
        } else {
            return UnequalExpenseSplit()
        }
    }
    
}
