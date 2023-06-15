//
//  CreateNewExpenseViewController.swift
//  SmartMoney
//
//  Created by Dylan Lo on 12/6/23.
//

import UIKit
import SwiftUI

class CreateNewExpenseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    /*
     struct Transaction: Identifiable {
         let id: Int
         let name: String
         let date : String
         let category : String
         let amount : Double
         let isExpense : Bool // if false, then income
     }

     */
    
    // MARK: Terminating Buttons
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        // Closes Popup
        dismiss(animated: true)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        // Create Transaction Data
        // let newTransaction = Transaction(name: <#T##String#>, date: <#T##String#>, category: <#T##String#>, amount: <#T##Double#>, isExpense: <#T##Bool#>)
        
        // Close Popup
        dismiss(animated: true)
    }
    
    
    @IBSegueAction func embedHorizontalScrollView(_ coder: NSCoder) -> UIViewController? {
        return UIHostingController(coder: coder, rootView: categoryHorizontalScrollView(listCatStack: listCatStack))
    }
    @IBSegueAction func embedNumPad(_ coder: NSCoder) -> UIViewController? {
        return UIHostingController(coder: coder, rootView: numberPad())
    }
    

}
