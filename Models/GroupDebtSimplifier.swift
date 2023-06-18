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
    
    func simplify(_ transactions: [GroupExpense]) -> [Payment] {
        var netBalance = [User: Double]()
        //iterate through the array of transactions
        for expense in transactions {
            for split in expense.splits {
                //updates the debts of those who owe money
                if netBalance[split.user] == nil {
                    netBalance[split.user] = -split.amount
                } else {
                    netBalance[split.user]! -= split.amount
                }
                //updates the credits of those who are being owed money
                if netBalance[expense.payer] == nil {
                    netBalance[expense.payer] = split.amount
                } else {
                    netBalance[expense.payer]! += split.amount
                }
            }
        }
        
        var positives = [NetBalance]()
        var negatives = [NetBalance]()
        
        for (user, credit) in netBalance {
            if credit > 0 {
                pushHeap(&positives, credit, user)
            } else {
                pushHeap(&negatives, -credit, user)
            }
        }
        
        var result = [Payment]()
        while positives.count > 0 {
            var p1 = heapTop(positives)!
            var p2 = heapTop(negatives)!
            popHeap(&positives)
            popHeap(&negatives)
            let payment = Payment(p2.user, p1.user, min(p1.balance, p2.balance))
            result.append(payment)
            if p1.balance > p2.balance {
                pushHeap(&positives, p1.balance - p2.balance, p1.user)
            } else if p1.balance < p2.balance {
                pushHeap(&negatives, p2.balance - p1.balance, p2.user)
            }
        }
        return result
    }
    
    func demo() -> [GroupExpense] {
        let user1 = User("Shuyao")
        let user2 = User("Dylan")
        let user3 = User("Bernice")
        let user4 = User("Ana")
        
        userController.addUser(user1)
        userController.addUser(user2)
        userController.addUser(user3)
        userController.addUser(user4)
        groupController.createNewGroup("Outing with Friends", user1)
        let group = groupController.getGroup("Outing with Friends")
        group?.addMember(userController.getUser("Bernice")!)
        group?.addMember(userController.getUser("Dylan")!)
        group?.addMember(userController.getUser("Ana")!)
        var splits = [Split]()
        splits.append(Split(user: userController.getUser("Shuyao")!, amount: 250))
        splits.append(Split(user: userController.getUser("Dylan")!, amount: 300))
        splits.append(Split(user: userController.getUser("Bernice")!, amount: 290))
        group?.createExpense(userController.getUser("Shuyao")!, 840, Date(), splits, "Breakfast",  SplitType(id: "Unequally"))
        var splits2 = [Split]()
        splits2.append(Split(user: userController.getUser("Shuyao")!, amount: 30))
        splits2.append(Split(user: userController.getUser("Dylan")!, amount: 20))
        splits2.append(Split(user: userController.getUser("Bernice")!, amount: 10))
        group?.createExpense(userController.getUser("Dylan")!, 60, Date(), splits2, "BubbleTea",  SplitType(id: "Unequally"))
        var splits3 = [Split]()
        splits3.append(Split(user: userController.getUser("Shuyao")!, amount: 200))
        splits3.append(Split(user: userController.getUser("Dylan")!, amount: 200))
        splits3.append(Split(user: userController.getUser("Bernice")!, amount: 200))
        group?.createExpense(userController.getUser("Dylan")!, 600, Date(), splits3, "Something",  SplitType(id: "Equally"))
        
        var splits4 = [Split]()
        splits4.append(Split(user: userController.getUser("Shuyao")!, amount: 100))
        splits4.append(Split(user: userController.getUser("Dylan")!, amount: 150))
        group?.createExpense(userController.getUser("Bernice")!, 250, Date(), splits4, "Something else",  SplitType(id: "UnEqually"))
        
        var splits5 = [Split]()
        splits5.append(Split(user: userController.getUser("Shuyao")!, amount: 45))
        splits5.append(Split(user: userController.getUser("Dylan")!, amount: 35))
        splits5.append(Split(user: userController.getUser("Bernice")!, amount: 30))
        group?.createExpense(userController.getUser("Bernice")!, 110, Date(), splits5, "Something else 2",  SplitType(id: "UnEqually"))
        
        var splits6 = [Split]()
        splits6.append(Split(user: userController.getUser("Shuyao")!, amount: 3.55))
        splits6.append(Split(user: userController.getUser("Dylan")!, amount: 2.63))
        splits6.append(Split(user: userController.getUser("Bernice")!, amount: 4.71))
        group?.createExpense(userController.getUser("Dylan")!, 10.89, Date(), splits6, "Something else 3",  SplitType(id: "UnEqually"))
        
        var splits7 = [Split]()
        splits7.append(Split(user: userController.getUser("Dylan")!, amount: 270))
        splits7.append(Split(user: userController.getUser("Bernice")!, amount: 270))
        group?.createExpense(userController.getUser("Dylan")!, 540, Date(), splits7, "Something else 4",  SplitType(id: "Equally"))
        
        var splits8 = [Split]()
        splits8.append(Split(user: userController.getUser("Ana")!, amount: 500))
        splits8.append(Split(user: userController.getUser("Bernice")!, amount: 200))
        group?.createExpense(userController.getUser("Bernice")!, 700, Date(), splits8, "Something else 5",  SplitType(id: "Unequally"))
        
//        for user in userController.userList {
//            balanceController.showBalanceSheetOfUser(user)
//        }
        return group!.expenseList
                
    }
    
    func demonstration() {
        let results = simplify(demo())
        for res in results {
            print(String(format: "%@ owes %@ $%.2f", res.payer.name, res.payee.name, res.amount))
        }
    }
    
    func upheapify(_ heap: inout [NetBalance], _ index: Int) {
        if index == 0 {
            return
        }
        var pi = Int(floor(Double(index - 1) / 2.0))
        if heap[pi].balance < heap[index].balance {
            var temp = heap[pi]
            heap[pi] = heap[index]
            heap[index] = temp
            upheapify(&heap, pi)
        }
    }
    
    func downheapify(_ heap: inout [NetBalance], _ index: Int) {
        var lc = 2 * index + 1
        var rc = 2 * index + 2
        if lc >= heap.count && rc >= heap.count {
            return
        }
        var largest = index
        if lc < heap.count && heap[lc].balance > heap[largest].balance {
            largest = lc
        }
        if rc < heap.count && heap[rc].balance > heap[largest].balance {
            largest = rc
        }
        if largest == index {
            return
        }
        var temp = heap[largest]
        heap[largest] = heap[index]
        heap[index] = temp
        downheapify(&heap, largest)
    }
    
    func pushHeap(_ heap: inout [NetBalance], _ balance: Double, _ user: User) {
        var netBalance = NetBalance(user, balance)
        heap.append(netBalance)
        upheapify(&heap, heap.count - 1)
    }
    
    func popHeap(_ heap: inout [NetBalance])  {
        if heap.count == 0 {
            return
        }
        var i = heap.count - 1
        var temp = heap[0]
        heap[0] = heap[i]
        heap[i] = temp
        heap.popLast()
        downheapify(&heap, 0)
    }
    
    func heapTop(_ heap: [NetBalance]) -> NetBalance? {
        var heap = heap
        if heap.count == 0 {
            return nil
        }
        return heap[0]
    }
}
