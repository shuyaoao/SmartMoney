//
//  ExpenseSplit.swift
//  SmartMoney
//
//  Created by Shuyao Li on 16/6/23.
//

import Foundation

protocol ExpenseSplit {
    func validateSplitRequest(_ splits: [Split], _ amount: Double) -> Bool
}
