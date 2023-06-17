//
//  BalancesTableTableViewController.swift
//  SmartMoney
//
//  Created by Shuyao Li on 12/6/23.
//

import UIKit

class BalancesTableTableViewController: UITableViewController {
    
    var array = [User("Dylan"), User("Shuyao"), User("Bernice"), User("Ana"), User("Shi Han"), User("Jiang En")]
    var number = [1,2,3,4,5,6]//update with the number of debts owed/being owed
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "BalancesCell")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //update with the number of debts owed/being owed
        return number[section]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BalancesCell", for: indexPath)
        cell.textLabel?.text = String(format: "\(array[indexPath.row].name) owes you %.2f", 10.50)
        cell.backgroundColor = UIColor(named: "Off-White")
        //update with the exact amounts owed individually
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return array.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let button = UIButton()
        button.setTitle(array[section].name, for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }
}
