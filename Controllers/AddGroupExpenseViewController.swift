//
//  AddGroupExpenseViewController.swift
//  SmartMoney
//
//  Created by Shuyao Li on 6/6/23.
//

import UIKit
import SwiftUI

class AddGroupExpenseViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var amtTextField: UITextField!
    @IBOutlet weak var whoPaidScrollView: UICollectionView!
    @IBOutlet weak var splitByWho: UICollectionView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var descriptionLabel: UITextField!
    @IBOutlet weak var splitHowCV: UICollectionView!
    
    var previousVC: GroupDetailsViewController?
    var group: Group?
    var array = [SelectedUser]()
    let splitHow = ["Equally", "Unequally"]
    var splitEqually = true //default splitMethod to be set to equal
    var paidBy: SelectedUser?
    var paidByIndexPath: IndexPath?
    var splitBtw = [SelectedUser]()
    var date = Date()
    var lastIndexPath: IndexPath = [1, 0]
    var splits = [Split]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        amtTextField.delegate = self
        whoPaidScrollView.dataSource = self
        whoPaidScrollView.delegate = self
        splitByWho.dataSource = self
        splitByWho.delegate = self
        
        //create a copy of group members array
        for user in (group?.groupMembers)! {
            array.append(SelectedUser(user))
        }
        
        whoPaidScrollView.register(GroupMemberCollectionViewCell.nib(), forCellWithReuseIdentifier: "GroupMemberCollectionViewCell")
        splitByWho.register(GroupMemberCollectionViewCell.nib(), forCellWithReuseIdentifier: "GroupMemberCollectionViewCell")
        splitHowCV.register(GroupMemberCollectionViewCell.nib(), forCellWithReuseIdentifier: "GroupMemberCollectionViewCell")
        splitHowCV.dataSource = self
        splitHowCV.delegate = self
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        // Do any additional setup after loading the view.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //number of cells based on which collection view
        if collectionView == splitByWho || collectionView == whoPaidScrollView {
            return array.count
        } else {
            return splitHow.count
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //populates the collection view based on the conditions defined
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GroupMemberCollectionViewCell", for: indexPath) as! GroupMemberCollectionViewCell
        if collectionView == splitHowCV {
            cell.configure(splitHow[indexPath.row])
            cell.rectangleView.backgroundColor = UIColor(named: "Medium Blue")
            cell.nameLabel.backgroundColor = UIColor(named: "Medium Blue")
        }
        if collectionView == whoPaidScrollView {
            cell.configure(array[indexPath.row].name)
            if array[indexPath.row].paidBySelected {
                cell.rectangleView.backgroundColor = UIColor(named: "Dark Blue")
                cell.nameLabel.backgroundColor = UIColor(named: "Dark Blue")
            } else {
                cell.rectangleView.backgroundColor = UIColor(named: "Medium Blue")
                cell.nameLabel.backgroundColor = UIColor(named: "Medium Blue")
            }
        }
        if collectionView == splitByWho {
            cell.configure(array[indexPath.row].name)
            if array[indexPath.row].splitBtwSelected {
                cell.rectangleView.backgroundColor = UIColor(named: "Dark Blue")
                cell.nameLabel.backgroundColor = UIColor(named: "Dark Blue")
            } else {
                cell.rectangleView.backgroundColor = UIColor(named: "Medium Blue")
                cell.nameLabel.backgroundColor = UIColor(named: "Medium Blue")
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //performs selection of the cells, depending on which collection view is triggered
        let cell = collectionView.cellForItem(at: indexPath) as! GroupMemberCollectionViewCell
        if collectionView == splitByWho {
            if array[indexPath.row].splitBtwSelected == true {
                cell.rectangleView.backgroundColor = UIColor(named: "Medium Blue")
                cell.nameLabel.backgroundColor = UIColor(named: "Medium Blue")
                array[indexPath.row].splitBtwSelected = false
                splitBtw = splitBtw.filter { user in
                    user.name != array[indexPath.row].name
                }
            } else {
                cell.rectangleView.backgroundColor = UIColor(named: "Dark Blue")
                cell.nameLabel.backgroundColor = UIColor(named: "Dark Blue")
                if let name = cell.nameLabel.text {
                    if !splitBtw.contains(where: { user in
                        user.name == name
                    }) {
                        array[indexPath.row].splitBtwSelected = true
                        splitBtw.append(array[indexPath.row])
                    }
                }
            }
            splitHowCV.reloadData()
        } else {
            if collectionView == whoPaidScrollView && array[indexPath.row].name != paidBy?.name {
                array[indexPath.row].paidBySelected = true
                var index: Int?
                for (ind, user) in array.enumerated() {
                    if user.name == paidBy?.name {
                        index = ind
                    }
                }
                if let safeIndex = index {
                    array[safeIndex].paidBySelected = false
                }
                paidBy = array[indexPath.row]
                whoPaidScrollView.reloadData()
            }
            if collectionView == splitHowCV {
                if indexPath != lastIndexPath {
                    cell.rectangleView.backgroundColor = UIColor(named: "Dark Blue")
                    cell.nameLabel.backgroundColor = UIColor(named: "Dark Blue")
                    if let prevCell = collectionView.cellForItem(at: lastIndexPath) as? GroupMemberCollectionViewCell {
                        prevCell.rectangleView.backgroundColor = UIColor(named: "Medium Blue")
                        prevCell.nameLabel.backgroundColor = UIColor(named: "Medium Blue")
                        array[lastIndexPath.row].paidBySelected = false
                    }
                        if cell.nameLabel.text == "Unequally" {
                            splitEqually = false
                            if amtTextField.hasText {
                            performSegue(withIdentifier: "goToUnequalGroupExpensesPage", sender: collectionView.delegate)
                            }
                        } else {
                            splitEqually = true
                        }
                    
                    lastIndexPath = indexPath
                } else {
                    cell.rectangleView.backgroundColor = UIColor(named: "Dark Blue")
                    cell.nameLabel.backgroundColor = UIColor(named: "Dark Blue")
                    if cell.nameLabel.text == "Unequally" {
                        splitEqually = false
                        if amtTextField.hasText && !splitBtw.isEmpty {
                        performSegue(withIdentifier: "goToUnequalGroupExpensesPage", sender: collectionView.delegate)
                        }
                    } else {
                        splitEqually = true
                    }
                }
            }
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        //formats the date selected
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd mmm yyyy"
        date = datePicker.date
        let dateString = dateFormatter.string(from: datePicker.date)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        //saves and updates tableview, debts and balances
        if descriptionLabel.text != "" && amtTextField.text != "" && paidBy != nil && !splitBtw.isEmpty {
            var splitID: String
            if splitEqually {
                splitID = "Equally"
            } else {
                splitID = "Unequally"
            }
            var payer: User?
            for user in (group?.groupMembers)! {
                if user.id == paidBy?.id {
                    payer = user
                }
            }
            
            if splitEqually {
                for selectedUser in splitBtw {
                    splits.append(Split(user: (group?.groupMembers.first(where: { user in
                        selectedUser.id == user.id
                    }))!, amount: Double(self.amtTextField.text!)! / Double(splitBtw.count)))
                }
            }
            
            group?.createExpense(payer!, Double(self.amtTextField.text!)!, datePicker.date, splits, descriptionLabel.text!, SplitType(id: splitID))
            let groupDetailsVC = self.previousVC
            let groupsVC = self.previousVC?.prevVC
            var index = 0
            for ind in 0 ..< (groupsVC?.groupArray.count ?? 0) {
                if (groupsVC?.groupArray[ind].id)! == group!.id {
                    index = ind
                }
            }
            groupsVC?.groupArray[index] = group!
            groupsVC?.updateData()
            groupDetailsVC?.updateData()
            self.dismiss(animated: true)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //prepare for segue by passing in the necessary properties
        if segue.identifier == "goToUnequalGroupExpensesPage" {
            let destinationVC = segue.destination as! UnequalGroupExpensesTableViewController
            destinationVC.array = splitBtw
            destinationVC.amt = Double(amtTextField.text!)
            destinationVC.group = group
            destinationVC.prevVC = self
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //triggeres segue when textField has stopped editing
        if !splitEqually && textField.text != "" && !splitBtw.isEmpty {
            self.resignFirstResponder()
            performSegue(withIdentifier: "goToUnequalGroupExpensesPage", sender: self)
            //print("segue triggered")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //triggeres segue when return button is pressed
        if !splitEqually && textField.text != "" && !splitBtw.isEmpty{
            self.resignFirstResponder()
            performSegue(withIdentifier: "goToUnequalGroupExpensesPage", sender: self)
            //print("segue triggered")
        }
        return true
    }
    
    @IBSegueAction func embedCategoryScrollView(_ coder: NSCoder) -> UIViewController? {
        return UIHostingController(coder: coder, rootView: CategoryHorizontalScrollView(CategoryDataSource : catDataSource))
    }
    
}
