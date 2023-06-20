//
//  SelectedUser.swift
//  SmartMoney
//
//  Created by Shuyao Li on 19/6/23.
//

import Foundation

class SelectedUser : Hashable {
    
    static func == (lhs: SelectedUser, rhs: SelectedUser) -> Bool {
        if lhs.id == rhs.id {
            return true
        }
        return false
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    let id: String
    let name: String
    var paidBySelected = false
    var splitBtwSelected = false
    var from = false
    var to = false
    
    init(_ user: User) {
        self.id = user.id
        self.name = user.name
    }
}
