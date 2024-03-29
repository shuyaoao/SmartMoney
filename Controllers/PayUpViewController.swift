//
//  PayUpViewController.swift
//  SmartMoney
//
//  Created by Shuyao Li on 12/6/23.
//

import UIKit
import Combine
import Firebase
import FirebaseAuth

class PayUpViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    var array = [SelectedUser]()
    @IBOutlet weak var fromTableView: UITableView!
    @IBOutlet weak var toTableView: UITableView!
    @IBOutlet weak var amountTextField: UITextField!
    var from: SelectedUser?
    var to: SelectedUser?
    var payUpAmount: Double?
    var group: Group?
    var prevVC: GroupDetailsViewController?
    var alertController: UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toTableView.delegate = self
        toTableView.dataSource = self
        fromTableView.delegate = self
        fromTableView.dataSource = self
        amountTextField.delegate = self
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        for user in (group?.groupMembers)! {
            array.append(SelectedUser(user))
        }
    }
    
    func showAlert() {
        alertController = UIAlertController(title: "Invalid Amount", message: "Please check your inputs", preferredStyle: .alert)
        
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //populates the table with custom cells displaying names of group members
        let cell = tableView.dequeueReusableCell(withIdentifier: "PayUpCell", for: indexPath) as! PayUpTableViewCell
        if tableView == fromTableView {
            if array[indexPath.row].isFrom {
                cell.rectangleView.backgroundColor = UIColor(named: "Dark Blue")
                cell.nameLabel.backgroundColor = UIColor(named: "Dark Blue")
            } else {
                cell.rectangleView.backgroundColor = UIColor(named: "Medium Blue")
                cell.nameLabel.backgroundColor = UIColor(named: "Medium Blue")
            }
        } else {
            if array[indexPath.row].isTo {
                cell.rectangleView.backgroundColor = UIColor(named: "Dark Blue")
                cell.nameLabel.backgroundColor = UIColor(named: "Dark Blue")
            } else {
                cell.rectangleView.backgroundColor = UIColor(named: "Medium Blue")
                cell.nameLabel.backgroundColor = UIColor(named: "Medium Blue")
            }
        }
        cell.configure(array[indexPath.row].name)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //when a cell is selected, update accordingly
        print(array[indexPath.row].name)
        if tableView == fromTableView {
            if array[indexPath.row].name == to?.name {
                print("from and to cannot be the same person!")
            }
            else if from == nil {
                array[indexPath.row].isFrom = true
                from = array[indexPath.row]
            } else {
                var index: Int?
                for (ind, user) in array.enumerated() {
                    if user.name == from!.name {
                        index = ind
                    }
                }
                if let safeIndex = index {
                    array[safeIndex].isFrom = false
                }
                array[indexPath.row].isFrom = true
                from = array[indexPath.row]
            }
        } else {
            if array[indexPath.row].name == from?.name {
                print("from and to cannot be the same person!")
            }
                else if to == nil {
                    array[indexPath.row].isTo = true
                    to = array[indexPath.row]
                }
            else {
                    var index: Int?
                    for (ind, user) in array.enumerated() {
                        if user.name == to!.name {
                            index = ind
                        }
                    }
                    if let safeIndex = index {
                        array[safeIndex].isTo = false
                    }
                    array[indexPath.row].isTo = true
                    to = array[indexPath.row]
                }
            }
        tableView.reloadData()
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        if amountTextField.text == nil {
            showAlert()
        } else if Double(amountTextField.text!) == nil {
            showAlert()
        } else if Double(amountTextField.text!)! <= 0 {
            showAlert()
        } else {
        //saves the input and updates balances, table view and debts
            if from != nil && to != nil && amountTextField.text != "" {
                var payer: User?
                var payee: User?
                for user in (group?.groupMembers)! {
                    if user.id == from?.id {
                        payer = user
                    }
                    if user.id == to?.id {
                        payee = user
                    }
                }
                let amount = Double(amountTextField.text!)!
                let payup = group?.createExpense(payer!, amount, Date(), [Split(user: payee!, amount: amount)])
                let groupDetailsVC = self.prevVC
                let groupsVC = self.prevVC?.prevVC
                var index = 0
                for ind in 0 ..< (groupsDataModel.count ?? 0) {
                    if (groupsDataModel[ind].id) == group!.id {
                        index = ind
                    }
                }
                groupsDataModel[index] = group!
                groupsVC?.updateData()
                groupDetailsVC?.updateData()
                addNewPayupToDatabase(payup!)
                self.dismiss(animated: true)
            }
        }
    }
    
    func addNewPayupToDatabase(_ expense : GroupExpense) {
        let user = Auth.auth().currentUser
        let databaseRef = Database.database().reference().child("users")
        let userRef = databaseRef.child(user!.uid)
        let groupsRef = userRef.child("groups")
        let group = groupsRef.child(group!.id)
        let expenseListRef = group.child("expenseList")
        
        // Add new expense with id
        expenseListRef.child(expense.id).setValue(expense.toDictionary())
        print("Added Pay Up to Database")
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text != "" {
            payUpAmount = Double(textField.text!)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            payUpAmount = Double(textField.text!)
        }
        return true
    }
}
