//
//  UnequalGroupExpensesTableViewController.swift
//  SmartMoney
//
//  Created by Shuyao Li on 9/6/23.
//

import UIKit

class UnequalGroupExpensesTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var remainingAmtLabel: UILabel!
    var array = [SelectedUser]()
    @IBOutlet weak var tableView: UITableView!
    var amt : Double?
    var exactAmounts : [String: Double] = [:]
    var count = 0.0
    var remainingAmt : Double?
    var prevVC: AddGroupExpenseViewController?
    var group: Group?
    var splitsDict = [SelectedUser: Double]()
    var splits = [Split]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        remainingAmt = amt
        remainingAmtLabel.text = String(format: "$%.2f remaining of $%.2f", amt!, amt!)
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //populates the table with custom cells displaying names of group members
        let cell = tableView.dequeueReusableCell(withIdentifier: UnequalExpensesTableViewCell.id, for: indexPath) as! UnequalExpensesTableViewCell
        cell.amountTextField.delegate = self
        cell.amountTextField.tag = indexPath.row
        cell.configure(array[indexPath.row].name)
        cell.amountTextField.delegate = self
        
        return cell
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        //set split method back to equals and deselects the split method collection view
        prevVC?.splitEqually = true
        prevVC?.splitHowCV.reloadData()
        self.dismiss(animated: true)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        //saves the exact amounts of the debts
        if count != amt! {
            print("amount doesnt tally!")
        } else {
            for (selectedUser, amount) in splitsDict {
                for user in (group?.groupMembers)! {
                    if user.id == selectedUser.id {
                        splits.append(Split(user: user, amount: amount))
                    }
                }
            }
        }
        prevVC?.splits = splits
        self.dismiss(animated: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //shows user how much is remaining of the total debt
        if let safeAmt = Double(textField.text!) {
            if count + safeAmt > amt! {
                print("amount doesnt tally!")
            } else {
                count += safeAmt
                remainingAmt! -= safeAmt
                remainingAmtLabel.text = String(format: "$%.2f remaining of $%.2f", remainingAmt!, amt!)
                
            }
            splitsDict[array[textField.tag]] = safeAmt
        }
    }
}
