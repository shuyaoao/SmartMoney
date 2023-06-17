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
    @IBOutlet weak var incomeButton: UIButton!
    @IBOutlet weak var expenseButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var transactionNameTextField: UITextField!
    @IBOutlet weak var categorySelectedLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        // Expense preselected
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
        // Category
        for index in 0..<catDataSource.listofCategories.count {
            if catDataSource.listofCategories[index].selected == true {
                newTransaction.category = catDataSource.listofCategories[index]
            }
            
            catDataSource.listofCategories[index].buttonunSelected()
        }
        
        // Amount
        newTransaction.amount = convertToDouble(numPad.numPadNumber)
        
        let id = transactionDataModel.transactionDataList.count // Naive id
        
        // Unwrapping of Optionals
        let name = newTransaction.name!
        let date = newTransaction.date!
        let category = newTransaction.category!
        let amount = newTransaction.amount!
        let isExpense = newTransaction.isExpense!
        
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
        
    }
    @IBAction func transactNameChanged(_ sender: UITextField) {
        newTransaction.name = transactionNameTextField.text
    }
    
    
    @IBAction func transactionNameChanged(_ sender: UITextField) {
        newTransaction.name = transactionNameTextField.text
    }

    @IBAction func expenseButtonSelected(_ sender: UIButton) {
        expenseButton.backgroundColor = .systemTeal
        incomeButton.backgroundColor = .white
        newTransaction.isExpense = true
    }
    
    @IBAction func incomeButtonSelected(_ sender: UIButton) {
        expenseButton.backgroundColor = .systemTeal
        expenseButton.backgroundColor = .white
        newTransaction.isExpense = false
    }
    
    @IBSegueAction func embedHorizontalScrollView(_ coder: NSCoder) -> UIViewController? {
        return UIHostingController(coder: coder, rootView: CategoryHorizontalScrollView(CategoryDataSource : catDataSource))
    }
    
    @IBSegueAction func embedNumPad(_ coder: NSCoder) -> UIViewController? {
        return UIHostingController(coder: coder, rootView: numberPad())
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
