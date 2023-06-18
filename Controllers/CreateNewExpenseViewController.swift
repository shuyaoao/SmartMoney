//
//  CreateNewExpenseViewController.swift
//  SmartMoney
//
//  Created by Dylan Lo on 12/6/23.
//

import UIKit
import SwiftUI

class CreateNewExpenseViewController: UIViewController {
    static private var enteredNumber: String = ""
    
    // Transaction
    var newTransaction = selectedTransaction()
    
    // Category
    var categorySelectedLabelvar = ""
    
    // UI Buttons
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var transactionNameTextField: UITextField!
    @IBOutlet weak var expenseButton: UIButton!
    @IBOutlet weak var incomeButton: UIButton!
    
    var alertController: UIAlertController?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.expenseButton.isHighlighted = false
        self.incomeButton.isHighlighted = false
        
        // Expense Preselected
        newTransaction.isExpense = true
        
        // Date (Today) preselected
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        newTransaction.date = dateFormatter.string(from: datePicker.date)
    }
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        newTransaction.date = dateFormatter.string(from: datePicker.date)
        print(newTransaction.date!)
    }
    
    // MARK: Terminating Buttons
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        // Resets new Transaction and close popup
        newTransaction = selectedTransaction()
        dismiss(animated: true)
        
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        // Category Selection
        for index in 0..<catDataSource.listofCategories.count {
            if catDataSource.listofCategories[index].selected == true {
                newTransaction.category = catDataSource.listofCategories[index]
            }
            
            // Reset all Category Buttons
            catDataSource.listofCategories[index] = catDataSource.listofCategories[index].buttonunSelected()
        }
        
        // Amount Selection
        newTransaction.amount = convertToDouble(numPad.numPadNumber)
        
        // new Unique id of Transaction
        let id = transactionDataModel.transactionDataList.count
        
        // Checks if any of the datafields are empty
        // if Empty: Show a Warning Message
        if let name = newTransaction.name,
           let date = newTransaction.date,
           let category = newTransaction.category,
           let amount = newTransaction.amount,
           let isExpense = newTransaction.isExpense {
            
            let currentTransactionList = transactionDataModel.transactionDataList
            let unwrappedNewTransaction = Transaction(id: id, name: name, date: date, category: category, amount: amount, isExpense: isExpense)
            
            // Add new transaction to the DataSource
            transactionDataModel.updateTransactionDataList(with: currentTransactionList + [unwrappedNewTransaction])
            print(transactionDataModel.transactionDataList)
            // Resetting of Model Variables
            newTransaction = selectedTransaction()
            numPad.reset()
            
            // Close popup
            dismiss(animated: true)
            
        } else {
            // if any of the field has not been specified
            // Present the alert controller
            showAlert()
        }
    }
    @IBAction func transactNameChanged(_ sender: UITextField) {
        newTransaction.name = transactionNameTextField.text
    }
    
    
    @IBAction func transactionNameChanged(_ sender: UITextField) {
        newTransaction.name = transactionNameTextField.text
    }

    //newTransaction.isExpense = true
    // Income and Expense Buttons
    @IBAction func expenseButtonClicked(_ sender: UIButton) {
        newTransaction.isExpense = true
        self.incomeButton.tintColor = .lightGray
        self.expenseButton.tintColor = .systemTeal
    }
    
    @IBAction func incomeButtonClicked(_ sender: UIButton) {
        newTransaction.isExpense = false
        self.incomeButton.tintColor = .systemTeal
        self.expenseButton.tintColor = .lightGray
    }
    
    // Category Scroll View
    @IBSegueAction func embedHorizontalScrollView(_ coder: NSCoder) -> UIViewController? {
        return UIHostingController(coder: coder, rootView: CategoryHorizontalScrollView(CategoryDataSource : catDataSource))
    }
    
    // NumPad View
    @IBSegueAction func embedNumPad(_ coder: NSCoder) -> UIViewController? {
        return UIHostingController(coder: coder, rootView: numberPad())
    }
    
    // Alert Warning Popup
    func showAlert() {
        alertController = UIAlertController(title: "Invalid Inputs", message: "Please check that you have filled in all fields before saving.", preferredStyle: .alert)
        
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


func convertToDouble(_ string: String) -> Double? {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    numberFormatter.maximumFractionDigits = 2
    
    if let formattedNumber = numberFormatter.number(from: string) {
        return formattedNumber.doubleValue
    }
    return nil
}


