//
//  LoginViewController.swift
//  SmartMoney
//
//  Created by Shuyao Li on 18/6/23.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class LoginViewController: UIViewController {
    var alertMessage = ""
    var alertController: UIAlertController?

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)

        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailText.text ?? "Random", password: passwordText.text ?? "Random") { result, error in
            if error != nil {
                self.alertMessage = error!.localizedDescription
                self.showAlert()
            } else {
                self.performSegue(withIdentifier: "goToHomePage", sender: self)
            }
        }
    }
    
    // Alert Warning Popup
    func showAlert() {
        self.alertController = UIAlertController(title: "Error", message: alertMessage, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            // Handle OK button action (if needed)
            self?.dismissAlert()
        }
        
        self.alertController?.addAction(okAction)
        
        // Present the alert controller
        present(alertController!, animated: true, completion: nil)
    }
    
    func dismissAlert() {
        alertController?.dismiss(animated: true, completion: nil)
        alertController = nil
    }

}


let myself = User(Auth.auth().currentUser!.uid, "Shuyao")

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
                print("SNAPSHOT EXISTS")
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
                        if date != "01 July 1990" {
                            transactionPreviewDataList.append(trans)
                        }
                    }
                }
            }
        })
    }
}

func loadBudgets() {
    let user = Auth.auth().currentUser
    
    if let user = user {
        let uid = user.uid
        
        // MARK: Navigate to User Branch
        let databaseRef = Database.database().reference().child("users")
        let userRef = databaseRef.child(uid)
        
        // Navigate to budget branch
        let budgetRef = userRef.child("budget")
        
        budgetRef.observe(.value, with: { snapshot in
            // Check if snapshot exist
            if snapshot.exists() {
                print("SNAPSHOT EXISTS")
                for child in snapshot.children {
                    if let userSnapshot = child as? DataSnapshot,
                       // Get the value of the snapshot
                       let budgetData = userSnapshot.value as? [String: Any] {
                        
                        // Access budget details (values)
                        let amount = budgetData["budgetAmount"] as? Int
                        let year = budgetData["year"] as? Int
                        let month = budgetData["month"] as? Int
                        
                        // Process budget data as needed
                        let budget : Budget = Budget(budgetAmount: amount!, year: year!, month: month!)
                        
                        presetBudget.append(budget)
                    }
                }
                    
            } else {
                let defaultBudget = Budget(budgetAmount: 200, year: 1990, month: 1)
                let defaultBudgetRef = budgetRef.child("1990-1") // designated key format
                defaultBudgetRef.setValue(defaultBudget.toDictionary())
            }
        })
    }
}

func loadGroups() {
    let user = Auth.auth().currentUser
    
    if let user = user {
        let uid = user.uid
        
        // MARK: Navigate to User Branch
        let databaseRef = Database.database().reference().child("users")
        let userRef = databaseRef.child(uid)
        
        // MARK: Navigate to Groups Branch
        let groupsRef = userRef.child("groups")
        
        // Observe the items in groups branch
        groupsRef.observe(.value, with: { snapshot in
            // Check if snapshot exist
            if snapshot.exists() {
                // for group id in the database
                for child in snapshot.children {
                    if let userSnapshot = child as? DataSnapshot,
                       // Get the value of the snapshot
                       let groupData = userSnapshot.value as? [String: Any] {
                        
                        // Access group id (key)
                        let id = userSnapshot.key
                        
                        // Access group details (values)
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "YY, MMM d, HH:mm:ss"
                        let dateCreated = dateFormatter.date(from: groupData["dateCreated"] as! String)
                        let groupName = groupData["groupName"] as! String
                        let owedAmount = groupData["owedAmount"] as! Double
                        let membersDict = groupData["groupMembers"] as? [String: Any]
                        var groupMembers: [User] = []
                        if membersDict != nil {
                            for (id, name) in membersDict! {
                                let safeName = name as! String
                                groupMembers.append(User(id, safeName))
                            }
                            var expenseList: [GroupExpense] = []
                            if groupData["expenseList"] as? [String: Any] != nil {
                                let expenseDict = groupData["expenseList"] as! [String: Any]
                                for (expenseId, value) in expenseDict {
                                    let value = value as! [String: Any]
                                    let description = value["description"] as! String
                                    let payerDict = value["payer"] as! [String: Any]
                                    let payerID = payerDict["id"] as! String
                                    let payerName = payerDict["name"] as! String
                                    let payer = User(payerID, payerName)
                                    let categoryName = value["category"] as! String
                                    let category = categoryDict[categoryName]
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.dateFormat = "YY, MMM d, HH:mm:ss"
                                    let date = dateFormatter.date(from: value["date"] as! String)
                                    let splitType = SplitType(id: value["splitType"] as! String)
                                    let type = value["type"] as! String
                                    let amount = value["amount"] as! Double
                                    let splitsDict = value["splits"] as! [String: Any]
                                    var splits: [Split] = []
                                    for (userID, amount) in splitsDict {
                                        let name = membersDict![userID] as! String
                                        splits.append(Split(user: User(userID, name), amount: amount as! Double))
                                    }
                                    expenseList.append(GroupExpense(payer, amount, date!, splits, description, splitType, category!, expenseId))
                                }
                                
                            }
                            // Process user data as needed
                            let group : Group = Group(owedAmount, groupName, groupMembers, expenseList, id, dateCreated!)
                            group.updateTotalBalance()
                            
                            if !groupsDataModel.contains(where: { grp in
                                grp.id == group.id
                            }) {
                                groupsDataModel.append(group)
                            } else {
                                var int = 0
                                for ind in 0 ..< (groupsDataModel.count ?? 0) {
                                    if groupsDataModel[ind].id == group.id {
                                        int = ind
                                    }
                                }
                                groupsDataModel[int] = group
                            }
                            groupsDataModel.sort()
                        }
                    }
                }
                // If empty: instatiate a default group
            } else {
                let defaultGroup = Group("Default Group")
                let newGroupRef = groupsRef.child(defaultGroup.id)
                newGroupRef.setValue(defaultGroup.toDictionary())
                loadGroups()
            }
        })
    }
}
