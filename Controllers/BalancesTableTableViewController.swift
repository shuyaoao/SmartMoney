//
//  BalancesTableTableViewController.swift
//  SmartMoney
//
//  Created by Shuyao Li on 12/6/23.
//

import UIKit

class BalancesTableTableViewController: UITableViewController {
    
    var group: Group?
    var membersArray = [User]()
    var balances = [User: [Payment]]()
    var finalArray = [[Payment]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        membersArray = group?.groupMembers ?? [User]()
        let results = group?.simplifier.simplify(group?.expenseList ?? [GroupExpense]()) ?? [Payment]()
        for member in membersArray {
            balances[member] = [Payment]()
        }
        for payment in results {
            if payment.payer.name != payment.payee.name {
                balances[payment.payer]?.append(payment)
            }
        }
        
        for (_, payments) in balances {
            if !payments.isEmpty {
                finalArray.append(payments)
            }
        }
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "BalancesCell")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //update with the number of debts owed/being owed
        return finalArray[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BalancesCell", for: indexPath)
        let payer = finalArray[indexPath.section][indexPath.row].payer
        let payee = finalArray[indexPath.section][indexPath.row].payee
        let amount = finalArray[indexPath.section][indexPath.row].amount
        cell.textLabel?.text = String(format: "%@ owes %@ $%.2f", payer.name, payee.name, amount)
        cell.backgroundColor = UIColor(named: "Off-White")
        //update with the exact amounts owed individually
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return finalArray.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //sets the headers of each section to group members' names
        let label = UILabel()
        if !finalArray[section].isEmpty {
            label.text = finalArray[section][0].payer.name
            label.font = UIFont(name:"HelveticaNeue-Medium", size: 18.0)
            label.textAlignment = .center
        }
        return label
    }
}
