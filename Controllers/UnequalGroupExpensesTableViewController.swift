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
    var exactAmounts : [SelectedUser: Double] = [:]
    var count = 0.0
    var remainingAmt : Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        remainingAmt = amt
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
        cell.amountTextField.delegate = self
        
        return cell
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        //saves the exact amounts of the debts
        self.dismiss(animated: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let safeAmt = Double(textField.text!) {
            if count + safeAmt > amt! {
                print("amount doesnt tally!")
            } else {
                count += safeAmt
                remainingAmt! -= safeAmt
                remainingAmtLabel.text = String(format: "$%.2f remaining of $%.2f", remainingAmt!, amt!)
            }
        }
    }
}
