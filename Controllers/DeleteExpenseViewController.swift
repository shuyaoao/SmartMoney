//
//  DeleteExpenseViewController.swift
//  SmartMoney
//
//  Created by Dylan Lo on 23/6/23.
//

import UIKit
import SwiftUI

class DeleteExpenseViewController: UIViewController {
    weak var mainViewController: ExpensesViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let scale = CGFloat(242/255)
        let color = UIColor(red: scale, green: scale, blue: scale, alpha: CGFloat(1))
        view.backgroundColor = color
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        mainViewController?.refresh()
        dismiss(animated: true)
    }
    
    @IBSegueAction func embedDeleteTransactionList(_ coder: NSCoder, sender: Any?, segueIdentifier: String?) -> UIViewController? {
        return UIHostingController(coder: coder, rootView: DeleteTransactionView(transactiondatamodel: transactionDataModel))
    }
    
}
