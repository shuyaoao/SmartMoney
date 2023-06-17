//
//  UserController.swift
//  SmartMoney
//
//  Created by Shuyao Li on 16/6/23.
//

import Foundation

class UserController {
    var userList: [User]
    
    init() {
        self.userList = [User]()
    }
    
    func addUser(_ user: User) {
        userList.append(user)
    }
    
    func getUser(_ name: String) -> User? {
        for user: User in userList {
            if user.name == name {
                return user
            }
        }
        return nil
    }
}
