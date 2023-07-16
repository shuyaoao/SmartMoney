
//  SmartMoney
//
//  Created by Shuyao Li on 19/5/23.
//


//  SmartMoney
//
//  Created by Shuyao Li on 19/5/23.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class HomePageViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var updatedNameTextField: UITextField!
    @IBOutlet weak var profilePicture: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //add in function to retrieve name from database
        updatedNameTextField.isHidden = true
        updatedNameTextField.delegate = self
        profilePicture.layer.cornerRadius = profilePicture.frame.size.width / 2
        profilePicture.clipsToBounds = true
        profilePicture.layer.borderWidth = 4
        profilePicture.layer.borderColor = UIColor(named: "Dark Blue")?.cgColor
        nameLabel.text = "Shuyao" //to be changed to incoporate user input at welcome page
        retrievePhoto()
        
        // MARK: Retrieve User Details
        let user = Auth.auth().currentUser
        
        // MARK: Load all Data of the User
        print("Loading transactions")
        loadTransactions()
        print("Transactions successfully loaded")
        
        print("Loading Groups")
        loadGroups()
        print("Groups successfully loaded")
        
        print("Loading Budget Data")
        loadBudgets()
        print("Budgets successfully loaded")

    }
    
    @IBAction func logoutButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "logout", sender: self)
    }
    
    @IBAction func updateNameButtonPressed(_ sender: Any) {
        updatedNameTextField.isHidden = false
        updatedNameTextField.becomeFirstResponder()
    }
    
    @IBAction func importPicture(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.originalImage] as? UIImage else { return }
        profilePicture.image = image
        
        picker.dismiss(animated: true, completion: nil)
        uploadPhotoToDatabase()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func uploadPhotoToDatabase() {
        //turn photo into data
        guard profilePicture.image != nil else {
            return
        }
        let storageRef = Storage.storage().reference()
        let imageData = profilePicture.image?.pngData()
        guard imageData != nil else {
            return
        }
        let path = "images/\(UUID().uuidString).png"
        let fileRef = storageRef.child(path)
        let uploadTask = fileRef.putData(imageData!) { _, error in
            guard error == nil else {
                print("Failed to upload")

                return
            }
            
            
            let user = Auth.auth().currentUser
            let databaseRef = Database.database().reference().child("users")
            let userRef = databaseRef.child(user!.uid)
            // Add image url to user database
            userRef.child("profileImage").setValue(path)
            print("profile image uploaded")
        }
    }
    
    func retrievePhoto() {
        let user = Auth.auth().currentUser
        
        if let user = user {
            print("user exists")
            let uid = user.uid
            
            // MARK: Navigate to User Branch
            let databaseRef = Database.database().reference().child("users")
            let userRef = databaseRef.child(uid)
            let imageRef = userRef.child("profileImage")
            
            imageRef.observe(.value, with: { snapshot in
                // Check if snapshot exist
                if snapshot.exists() {
                    print("profile pic snapshot exists")
                    // get user profile image url
                    for child in snapshot.children {
                        if let userSnapshot = child as? DataSnapshot,
                           // Get the value of the snapshot
                           let url = userSnapshot.value as? String {
                            print("userSnapshot exists")
                            let storageRef = Storage.storage().reference()
                            let fileRef = storageRef.child(url)
                            fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
                                if error == nil && data != nil {
                                    print("no errors")
                                    let image = UIImage(data: data!)
                                    DispatchQueue.main.async {
                                        self.profilePicture.image = image
                                        print("profile picture set")
                                    }
                                }
                                print("there are errors")
                            }
                        }
                    }
                } else {
                    let defaultProfilePicture = UIImage(named: "person.circle")
                    self.profilePicture.image = defaultProfilePicture
                    self.uploadPhotoToDatabase()
                    print("default image uploaded and retrived")
                }
            })
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    //makes the profile picture round
    func round(image: UIImage) -> UIImage {
        let imageWidth = image.size.width
        let imageHeight = image.size.height
        
        let diameter = min(imageWidth, imageHeight)
        let isLandscape = imageWidth > imageHeight
        
        let xOffset = isLandscape ? (imageWidth - diameter) / 2 : 0
        let yOffset = isLandscape ? 0 : (imageHeight - diameter) / 2
        
        let imageSize = CGSize(width: diameter, height: diameter)
        
        return UIGraphicsImageRenderer(size: imageSize).image { _ in
            
            let ovalPath = UIBezierPath(ovalIn: CGRect(origin: .zero, size: imageSize))
            ovalPath.addClip()
            image.draw(at: CGPoint(x: -xOffset, y: -yOffset))
            UIColor.white.setStroke()
            ovalPath.lineWidth = diameter / 50
            ovalPath.stroke()
        }
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




extension HomePageViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text != "" {
            nameLabel.text = textField.text
            welcomeLabel.text = "Welcome, \(textField.text!)"
            //update database
        }
        self.resignFirstResponder()
        updatedNameTextField.isHidden = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            nameLabel.text = textField.text
            welcomeLabel.text = "Welcome, \(textField.text!)"
            //update database
        }
        self.resignFirstResponder()
        updatedNameTextField.isHidden = true
        return true
    }
}
