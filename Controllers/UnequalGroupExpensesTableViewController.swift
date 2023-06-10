//
//  UnequalGroupExpensesTableViewController.swift
//  SmartMoney
//
//  Created by Shuyao Li on 9/6/23.
//

import UIKit

class UnequalGroupExpensesTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var remainingAmtLabel: UILabel!
    var array = [SelectedUser]()
    @IBOutlet weak var tableView: UITableView!
    var amt : Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        //tableView.register(UnequalExpensesTableViewCell.nib(), forCellReuseIdentifier: "UnequalExpensesCell")
        remainingAmtLabel.text = String(format: "$%.2f remaining of $%.2f", amt!, amt!)
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UnequalExpensesTableViewCell.id, for: indexPath) as! UnequalExpensesTableViewCell
        cell.configure(array[indexPath.row].name)
        return cell
    }
}
