//
//  GroupDebtSimplifier.swift
//  SmartMoney
//
//  Created by Shuyao Li on 17/6/23.
//

import Foundation

class GroupDebtSimplifier {
    
    var userController: UserController
    var groupController: GroupController
    var balanceController: BalanceController
    
    init() {
        self.userController = UserController()
        self.groupController = GroupController()
        self.balanceController = BalanceController()
    }
    
    func demo() {
        let user1 = User("User1")
        let user2 = User("User2")
        let user3 = User("User3")
        
        userController.addUser(user1)
        userController.addUser(user2)
        userController.addUser(user3)
        groupController.createNewGroup("Outing with Friends", user1)
        let group = groupController.getGroup("Outing with Friends")
        group?.addMember(userController.getUser("User1")!)
        group?.addMember(userController.getUser("User2")!)
        var splits = [Split]()
        splits.append(Split(user: userController.getUser("User1")!, amount: 250))
        splits.append(Split(user: userController.getUser("User2")!, amount: 300))
        splits.append(Split(user: userController.getUser("User3")!, amount: 290))
        group?.createExpense(userController.getUser("User1")!, 840, Date(), splits, "Breakfast",  SplitType(id: "Unequally"))
        var splits2 = [Split]()
        splits2.append(Split(user: userController.getUser("User1")!, amount: 30))
        splits2.append(Split(user: userController.getUser("User2")!, amount: 20))
        splits2.append(Split(user: userController.getUser("User3")!, amount: 10))
        group?.createExpense(userController.getUser("User2")!, 60, Date(), splits2, "BubbleTea",  SplitType(id: "Unequally"))
        var splits3 = [Split]()
        splits3.append(Split(user: userController.getUser("User1")!, amount: 200))
        splits3.append(Split(user: userController.getUser("User2")!, amount: 200))
        splits3.append(Split(user: userController.getUser("User3")!, amount: 200))
        group?.createExpense(userController.getUser("User2")!, 600, Date(), splits3, "Something",  SplitType(id: "Equally"))
        for user in userController.userList {
            balanceController.showBalanceSheetOfUser(user)
        }
        
        
    }
}
