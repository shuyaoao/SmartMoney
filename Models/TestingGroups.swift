//
//  TestingGroups.swift
//  SmartMoney
//
//  Created by Shuyao Li on 19/6/23.
//

import Foundation

//var groupArray = [Group(10.00, "Family", [User("Mom"), User("Dad"), User("Sister"), User("Brother")]),
//                  Group(20.00, "Friends", [User("Lisa"), User("Jennie"), User("Rose"), User("Jisoo")]),
//                  Group(-30.50, "Hall Friends", [User("Liza"), User("Clara"), User("Delna")]),
//                  Group(20.25, "School", [User("Ana"), User("Dylan"), User("Shuyao"), User("Bernice"), User("Shi Han"), User("Jiang En")])]

let myself = User("Shuyao")

class Family: Group {
    
    init() {
        super.init("Family")
        self.groupMembers = [User("Mom"), User("Dad"), User("Sister"), User("Brother"), myself]
        for user in groupMembers {
            self.simplifier.userController.addUser(user)
        }
        self.expenseList = [GroupExpense]()
        var splits = [Split]()
        splits.append(Split(user: self.simplifier.userController.getUser("Mom")!, amount: 10))
        splits.append(Split(user: self.simplifier.userController.getUser("Dad")!, amount: 15))
        splits.append(Split(user: self.simplifier.userController.getUser("Sister")!, amount: 25))
        splits.append(Split(user: self.simplifier.userController.getUser("Shuyao")!, amount: 25))
        splits.append(Split(user: self.simplifier.userController.getUser("Brother")!, amount: 20))
        self.createExpense(self.simplifier.userController.getUser("Brother")!, 95, Date(), splits, "Breakfast",  SplitType(id: "Unequally"), foodCategory)
        self.updateTotalBalance()
    }
}

class Friends: Group {
    
    init() {
        super.init("Friends")
        self.groupMembers = [User("Lisa"), User("Jennie"), User("Jisoo"), User("Rose"), myself]
        for user in groupMembers {
            self.simplifier.userController.addUser(user)
        }
        self.expenseList = [GroupExpense]()
        var splits = [Split]()
        splits.append(Split(user: self.simplifier.userController.getUser("Lisa")!, amount: 1000))
        splits.append(Split(user: self.simplifier.userController.getUser("Jennie")!, amount: 1500))
        splits.append(Split(user: self.simplifier.userController.getUser("Jisoo")!, amount: 2500))
        splits.append(Split(user: self.simplifier.userController.getUser("Rose")!, amount: 2500))
        splits.append(Split(user: self.simplifier.userController.getUser("Shuyao")!, amount: 2500))
        self.createExpense(self.simplifier.userController.getUser("Shuyao")!, 10000, Date(), splits, "Skincare",  SplitType(id: "Unequally"), healthCategory)
        
        var splits2 = [Split]()
        splits2.append(Split(user: self.simplifier.userController.getUser("Lisa")!, amount: 200))
        splits2.append(Split(user: self.simplifier.userController.getUser("Jennie")!, amount: 200))
        splits2.append(Split(user: self.simplifier.userController.getUser("Jisoo")!, amount: 200))
        splits2.append(Split(user: self.simplifier.userController.getUser("Rose")!, amount: 200))
        self.createExpense(self.simplifier.userController.getUser("Lisa")!, 800, Date(), splits2, "Dinner",  SplitType(id: "Equally"), foodCategory)
        
        self.updateTotalBalance()
    }
}

class Hexagon : Group {
    init() {
        super.init("Hexagon")
        let user1 = myself
        let user2 = User("Dylan")
        let user3 = User("Bernice")
        let user4 = User("Ana")
        self.groupMembers = [User("Dylan"), User("Bernice"), User("Ana"), myself]
        for user in groupMembers {
            self.simplifier.userController.addUser(user)
        }
        self.expenseList = [GroupExpense]()
        
        var splits = [Split]()
        splits.append(Split(user: self.simplifier.userController.getUser("Shuyao")!, amount: 250))
        splits.append(Split(user: self.simplifier.userController.getUser("Dylan")!, amount: 300))
        splits.append(Split(user: self.simplifier.userController.getUser("Bernice")!, amount: 290))
        self.createExpense(self.simplifier.userController.getUser("Shuyao")!, 840, Date(), splits, "Breakfast",  SplitType(id: "Unequally"), foodCategory)
        var splits2 = [Split]()
        splits2.append(Split(user: self.simplifier.userController.getUser("Shuyao")!, amount: 30))
        splits2.append(Split(user: self.simplifier.userController.getUser("Dylan")!, amount: 20))
        splits2.append(Split(user: self.simplifier.userController.getUser("Bernice")!, amount: 10))
        self.createExpense(self.simplifier.userController.getUser("Dylan")!, 60, Date(), splits2, "BubbleTea",  SplitType(id: "Unequally"), foodCategory)
        var splits3 = [Split]()
        splits3.append(Split(user: self.simplifier.userController.getUser("Shuyao")!, amount: 200))
        splits3.append(Split(user: self.simplifier.userController.getUser("Dylan")!, amount: 200))
        splits3.append(Split(user: self.simplifier.userController.getUser("Bernice")!, amount: 200))
        self.createExpense(self.simplifier.userController.getUser("Dylan")!, 600, Date(), splits3, "Something",  SplitType(id: "Equally"), unfilledCategory)
        
        var splits4 = [Split]()
        splits4.append(Split(user: self.simplifier.userController.getUser("Shuyao")!, amount: 100))
        splits4.append(Split(user: self.simplifier.userController.getUser("Dylan")!, amount: 150))
        splits4.append(Split(user: self.simplifier.userController.getUser("Bernice")!, amount: 0))
        self.createExpense(self.simplifier.userController.getUser("Bernice")!, 250, Date(), splits4, "Something else",  SplitType(id: "UnEqually"), unfilledCategory)
        
        var splits5 = [Split]()
        splits5.append(Split(user: self.simplifier.userController.getUser("Shuyao")!, amount: 45))
        splits5.append(Split(user: self.simplifier.userController.getUser("Dylan")!, amount: 35))
        splits5.append(Split(user: self.simplifier.userController.getUser("Bernice")!, amount: 30))
        self.createExpense(self.simplifier.userController.getUser("Bernice")!, 110, Date(), splits5, "Something else 2",  SplitType(id: "UnEqually"), unfilledCategory)
        
        var splits6 = [Split]()
        splits6.append(Split(user: self.simplifier.userController.getUser("Shuyao")!, amount: 3.55))
        splits6.append(Split(user: self.simplifier.userController.getUser("Dylan")!, amount: 2.63))
        splits6.append(Split(user: self.simplifier.userController.getUser("Bernice")!, amount: 4.71))
        self.createExpense(self.simplifier.userController.getUser("Dylan")!, 10.89, Date(), splits6, "Something else 3",  SplitType(id: "UnEqually"), unfilledCategory)
        
        var splits7 = [Split]()
        splits7.append(Split(user: self.simplifier.userController.getUser("Dylan")!, amount: 270))
        splits7.append(Split(user: self.simplifier.userController.getUser("Bernice")!, amount: 270))
        self.createExpense(self.simplifier.userController.getUser("Dylan")!, 540, Date(), splits7, "Something else 4",  SplitType(id: "Equally"), unfilledCategory)
        
        var splits8 = [Split]()
        splits8.append(Split(user: self.simplifier.userController.getUser("Ana")!, amount: 500))
        splits8.append(Split(user: self.simplifier.userController.getUser("Bernice")!, amount: 200))
        self.createExpense(self.simplifier.userController.getUser("Bernice")!, 700, Date(), splits8, "Something else 5",  SplitType(id: "Unequally"), unfilledCategory)
        
        self.updateTotalBalance()
    }
}

