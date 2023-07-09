//
//  GroupDetailsViewController.swift
//  SmartMoney
//
//  Created by Shuyao Li on 19/5/23.
//

import UIKit
import MonthYearPicker
import SwiftUI
import SwipeCellKit
import Combine
import Firebase
import FirebaseAuth

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
    var prevVC: GroupsViewController?
    var selectedExpense: GroupExpense?
    
    override func viewDidLoad() {
        //adds a scroll selector to allow users to select a specific month and year to display expenses in that selected timeframe
        super.viewDidLoad()
        expensesTableView.delegate = self
        expensesTableView.dataSource = self
        groupNameLabel.text = group?.groupName
        group?.expenseList = (group?.expenseList.sorted())!
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
        displayBalance()
    }
    
    func displayBalance() {
        //displays user total balance
        self.group?.updateTotalBalance()
        self.amount = self.group?.owedAmount
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
    }
    
    @IBAction func payUpButtonPressed(_ sender: UIButton) {
        //navigates to payup page
        performSegue(withIdentifier: "goToPayUp", sender: self)
    }
    
    @objc func dateChanged(_ datePicker: MonthYearPickerView) {
        //updates the date chosen
        dateTextField.text = formatDate(date: datePicker.date)
        expensesTableView.reloadData()
        datePicker.resignFirstResponder()
    }

    func formatDate(date: Date) -> String {
        //formats the date
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        return formatter.string(from: date)
    }
    
    @IBAction func addGroupExpenseButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "addGroupExpense", sender: self)
        //navigates to addgroupexpense page
    }
    
    @IBAction func balancesButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToBalances", sender: self)
        //navigates to balances page
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //prepare for navigation to the various pages by setting their properties based on current view controller
        if segue.identifier == "goToBalances" {
            let destinationVC = segue.destination as! BalancesTableTableViewController
            destinationVC.group = group
        } else if segue.identifier == "addGroupExpense" {
            let destinationVC = segue.destination as! AddGroupExpenseViewController
            destinationVC.group = group
            destinationVC.previousVC = self
        } else if segue.identifier == "goToPayUp" {
            let destinationVC = segue.destination as! PayUpViewController
            destinationVC.group = group
            destinationVC.prevVC = self
        } else if segue.identifier == "goToExpenseDetails" && selectedExpense != nil {
            let destinationVC = segue.destination as! GroupExpenseDetailsViewController
            destinationVC.expense = selectedExpense!
            destinationVC.prevVC = self
        }
    }
    
    func updateData() {
        //reloads the page after a payup/expense has been created
        self.expensesTableView.reloadData()
        self.displayBalance()
    }
}

extension GroupDetailsViewController : UITextFieldDelegate {
    //protocol methods for textfield delegate
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
        //number of rows to be displayed in the table view
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        let filteredExpensesList = group?.expenseList.filter({ expense in
            return formatter.string(from: expense.date) == dateTextField.text
        })
        return filteredExpensesList?.count ?? 0
    }
}

extension GroupDetailsViewController : SwipeTableViewCellDelegate {
    //this block of code adds a delete function to enable users to delete a group
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            let cell = tableView.cellForRow(at: indexPath) as! GroupExpensesTableViewCell
            let id = cell.expense?.id
            var index: Int?
            for ind in 0 ..< (self.group?.expenseList.count ?? 0) {
                if self.group?.expenseList[ind].id == id {
                    index = ind
                }
            }
            if index != nil {
                self.group?.expenseList.remove(at: index!)
                self.displayBalance()
                var int = 0
                for ind in 0 ..< (groupsDataModel.count ?? 0) {
                    if groupsDataModel[ind].id == self.group!.id {
                        int = ind
                    }
                }
                groupsDataModel[int] = self.group!
                self.removeExpenseFromDatabase(id!)
                self.prevVC?.updateData()
                print(groupsDataModel)
            }
        }
        // customize the action appearance
        deleteAction.image = UIImage(named: "trash.fill")

        return [deleteAction]
    }
    
    func removeExpenseFromDatabase(_ id: String) {
        // Remove from database
        let user = Auth.auth().currentUser
        let databaseRef = Database.database().reference().child("users")
        let userRef = databaseRef.child(user!.uid)
        let groupsRef = userRef.child("groups")
        let group = groupsRef.child(group!.id)
        let expenseList = group.child("expenseList")
        
        expenseList.child(id).removeValue { error, _ in
            if let error = error {
                print("Error removing value: \(error.localizedDescription)")
            } else {
                print("Value removed successfully.")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        //allows for groups to be deleted
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        return options
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //filters the expenses based on date and populates the table view
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupExpensesCell", for: indexPath) as! GroupExpensesTableViewCell
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        let filteredExpensesList = group?.expenseList.filter({ expense in
            return formatter.string(from: expense.date) == dateTextField.text
        })
        cell.configure((filteredExpensesList?[indexPath.row])!)
        if (filteredExpensesList?[indexPath.row])?.type == "Payup" {
            cell.isUserInteractionEnabled = false
        } else {
            cell.isUserInteractionEnabled = true
        }
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! GroupExpensesTableViewCell
        selectedExpense = cell.expense
        if selectedExpense != nil {
            if selectedExpense?.type != "Payup"{
                performSegue(withIdentifier: "goToExpenseDetails", sender: self)
            }
        }
    }
}
