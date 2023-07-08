
//  SmartMoney
//
//  Created by Shuyao Li on 19/5/23.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class HomePageViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Retrieve User Details
        let user = Auth.auth().currentUser
        
        // MARK: Load all Data of the User
        print("Loading transactions")
        loadTransactions()
        print("Transactions successfully loaded")
    }
}
/*
 database
    L users
        L test@gmail.com
            L transactions
                L id
                    L name : String
                    L date : String
                    L category : String
                    L amount : Double
                    L isExpense : bool
            L
 */

func loadTransactions() {
    let user = Auth.auth().currentUser
    
    if let user = user {
        let uid = user.uid
        
        // MARK: Navigate to User Branch
        let databaseRef = Database.database().reference().child("users")
        let userRef = databaseRef.child(uid)
        
        // MARK: Navigate to Transaction Branch
        let transactionsRef = userRef.child("transactions")
        
        // Observe the items in transaction branch
        transactionsRef.observe(.value, with: { snapshot in
            // Check if snapshot exist
            if snapshot.exists() {
                // for transaction id in the database
                for child in snapshot.children {
                    if let userSnapshot = child as? DataSnapshot,
                        // Get the value of the snapshot
                        let transData = userSnapshot.value as? [String: Any] {
                        
                        // Access transaction id (key)
                        let id = Int(userSnapshot.key)
                        
                        // Access transaction details (values)
                        let name = transData["name"] as? String
                        let date = transData["date"] as? String
                        let categoryName = transData["category"] as? String
                        let category = categoryDict[categoryName!]
                        let amount = transData["amount"] as? Double
                        let isExpense = transData["isExpense"] as? Bool

                        // Process user data as needed
                        let trans : Transaction = Transaction(id: id!, name: name!, date: date!, category: category!, amount: amount!, isExpense: isExpense!)
                        
                        transactionPreviewDataList.append(trans)
                    }
                }
            // If empty: instatiate a default transaction
            } else {
                let defaultTransaction = Transaction(id: 1, name: "Sample", date: "01 July 1990", category: utilitiesCategory, amount: 10.00, isExpense: true)
                let newTransactionRef = transactionsRef.child("1")
                newTransactionRef.setValue(defaultTransaction.toDictionary())
                loadTransactions() // Load transactions again
            }
        })
    }
}



