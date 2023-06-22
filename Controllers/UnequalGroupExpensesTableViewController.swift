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
    var prevVC: AddGroupExpenseViewController?
    var group: Group?
    var splitsDict = [SelectedUser: Double]()
    var splits = [Split]()
    var amounts = [Int: Double]()
    var alertController: UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
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
        cell.amountTextField.tag = indexPath.row
        
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
        var count = 0.0
        for (_, amt) in amounts {
            count += amt
        }
        if Double(round((count - amt!) * 100) / 100.0) > 0 {
            showAlert()
        } else {
            for (selectedUser, amount) in splitsDict {
                for user in (group?.groupMembers)! {
                    if user.id == selectedUser.id {
                        splits.append(Split(user: user, amount: amount))
                    }
                }
            }
            prevVC?.splits = splits
            self.dismiss(animated: true)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //shows user how much is remaining of the total debt
        var remainingAmt = amt!
        var safeAmt: Double
        if textField.text == nil {
            safeAmt = 0
        } else {
            safeAmt = Double(textField.text!) ?? 0
        }
        amounts[textField.tag] = safeAmt
        var count = 0.0
        for (_, amt) in amounts {
            count += amt
        }
        if Double(round((count - amt!) * 100) / 100.0) > 0 {
            showAlert()
        } else {
            if safeAmt >= 0 {
                splitsDict[array[textField.tag]] = safeAmt
                for (_, amt) in amounts {
                    remainingAmt -= amt
                }
                if remainingAmt <= 0 {
                    remainingAmtLabel.text = String(format: "$0.00 remaining of $%.2f", amt!)
                } else {
                    remainingAmtLabel.text = String(format: "$%.2f remaining of $%.2f", remainingAmt, amt!)
                }
            }
        }
    }
    
    //alert when amount does not tally
    func showAlert() {
        alertController = UIAlertController(title: "Amount doesn't tally!", message: "Please check your inputs", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            // Handle OK button action (if needed)
            self?.dismissAlert()
        }
        
        alertController?.addAction(okAction)
        
        // Present the alert controller
        present(alertController!, animated: true, completion: nil)
    }
    
    func dismissAlert() {
        alertController?.dismiss(animated: true, completion: nil)
        alertController = nil
    }
}
