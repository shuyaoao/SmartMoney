//
//  User.swift
//  SmartMoney
//
//  Created by Shuyao Li on 9/6/23.
//

import Foundation

struct SelectedUser: Hashable {
    var name: String
    var paidBySelected = false
    var splitBtwSelected = false
    var from = false
    var to = false
    
    
    init(_ name: String) {
        self.name = name
    }
}
