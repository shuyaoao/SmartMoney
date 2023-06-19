//
//  GroupDetailsViewController.swift
//  SmartMoney
//
//  Created by Shuyao Li on 19/5/23.
//

import UIKit
import MonthYearPicker
import SwiftUI

class GroupDetailsViewController: UIViewController {

    @IBOutlet weak var expensesTableView: UITableView!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet var groupNameLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var navigationBar: UINavigationItem!
    var picker : MonthYearPickerView?
    @IBOutlet weak var owedAmountDescriptionLabel: UILabel!
    var group: Group?
    var amount : Double?
    
    override func viewDidLoad() {
        //adds a scroll selector to allow users to select a specific month and year to display expenses in that selected timeframe
        super.viewDidLoad()
        expensesTableView.delegate = self
        expensesTableView.dataSource = self
        groupNameLabel.text = group?.groupName
        if let safeAmount = amount {
            if safeAmount > 0 {
                amountLabel.text = String(format: "$%.2f", safeAmount)
                amountLabel.textColor = UIColor(named: "green")
                owedAmountDescriptionLabel.text = "You are owed in total:"
                
            } else if safeAmount == 0 {
                amountLabel.text = String(format: "$%.2f", safeAmount)
                amountLabel.textColor = UIColor.black
                owedAmountDescriptionLabel.text = "You don't owe anything"
            } else {
                amountLabel.text = String(format: "$%.2f", -safeAmount)
                amountLabel.textColor = UIColor.red
                owedAmountDescriptionLabel.text = "You owe in total:"
            }
        }
        dateTextField.delegate = self
        picker = MonthYearPickerView(frame: CGRect(origin: CGPoint(x: 0, y: (view.bounds.height - 216) / 2), size: CGSize(width: view.bounds.width, height: 216)))
        picker!.minimumDate = Date.distantPast
        picker!.maximumDate = Calendar.current.date(byAdding: .year, value: 10, to: Date())
        picker!.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        //view.addSubview(picker)
        dateTextField.inputView = picker!
        dateTextField.text = formatDate(date: Date())
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @IBAction func payUpButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToPayUp", sender: self)
    }
    
    @objc func dateChanged(_ datePicker: MonthYearPickerView) {
        dateTextField.text = formatDate(date: datePicker.date)
        datePicker.resignFirstResponder()
    }

    func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        return formatter.string(from: date)
    }
    
    @IBAction func addGroupExpenseButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "addGroupExpense", sender: self)
    }
    
    @IBAction func balancesButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToBalances", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToBalances" {
            let destinationVC = segue.destination as! BalancesTableTableViewController
            destinationVC.group = group
        } else if segue.identifier == "addGroupExpense" {
            let destinationVC = segue.destination as! AddGroupExpenseViewController
            destinationVC.group = group
        } else if segue.identifier == "goToPayUp" {
            let destinationVC = segue.destination as! PayUpViewController
            destinationVC.group = group
        }
    }
    
    @IBSegueAction func expenseScrollView(_ coder: NSCoder) -> UIViewController? {
        return UIHostingController(coder: coder, rootView: TransactionScrollView(transactionDataModel: transactionDataModel))
    }
}

extension GroupDetailsViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
        }
}

extension GroupDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return group?.expenseList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupExpensesCell", for: indexPath) as! GroupExpensesTableViewCell
        cell.configure((group?.expenseList[indexPath.row])!)
        return cell
    }
}
