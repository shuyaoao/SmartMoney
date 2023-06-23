//
//  DeleteExpenseViewController.swift
//  SmartMoney
//
//  Created by Dylan Lo on 23/6/23.
//

import UIKit
import SwiftUI

class DeleteExpenseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
    }
    
    
    
    
    @IBAction func backButton(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    
    @IBSegueAction func embedDeleteTransactionList(_ coder: NSCoder, sender: Any?, segueIdentifier: String?) -> UIViewController? {
        return UIHostingController(coder: coder, rootView: DeleteTransactionView(transactiondatamodel: transactionDataModel))
    }
    
}
