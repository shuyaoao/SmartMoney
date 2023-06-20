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
    
    func getBalances(_ transactions: [GroupExpense]) -> [User: Double] {
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
        return netBalance
    }
    
    func simplify(_ transactions: [GroupExpense]) -> [Payment] {
        if transactions.isEmpty {
            return []
        } else {
            let netBalance = getBalances(transactions)
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
