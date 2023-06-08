//
//  Group.swift
//  SmartMoney
//
//  Created by Shuyao Li on 4/6/23.
//

import Foundation

class Group {
    var membersArray : Array<String>
    var owedAmount : Double
    var groupName : String
    var currentDebts : Dictionary<String, Double>
    
    init(_ membersArray: Array<String>, _ owedAmount: Double, _ groupName: String) {
        self.membersArray = membersArray
        self.owedAmount = owedAmount
        self.groupName = groupName
        self.currentDebts = Dictionary<String, Double>()
    }
    
    init(_ owedAmount: Double, _ groupName: String) {
        self.membersArray = [String]()
        self.owedAmount = owedAmount
        self.groupName = groupName
        self.currentDebts = Dictionary<String, Double>()
    }
    
}
