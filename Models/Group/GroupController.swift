//
//  GroupController.swift
//  SmartMoney
//
//  Created by Shuyao Li on 16/6/23.
//

import Foundation

class GroupController {
    var groupList: [Group]
    
    init() {
        self.groupList = [Group]()
    }
    
    func createNewGroup(_ name: String, _ createdBy: User) {
        let group = Group(name)
        group.groupMembers.append(createdBy)
        self.groupList.append(group)
    }
    
    func getGroup(_ name: String) -> Group? {
        for group: Group in groupList {
            if group.groupName == name {
                return group
            }
        }
        return nil
    }
}
