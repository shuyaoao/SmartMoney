//
//  AddGroupExpenseViewController.swift
//  SmartMoney
//
//  Created by Shuyao Li on 6/6/23.
//

import UIKit

class AddGroupExpenseViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var amtTextField: UITextField!
    @IBOutlet weak var whoPaidScrollView: UICollectionView!
    @IBOutlet weak var splitByWho: UICollectionView!
    @IBOutlet weak var splitHowCV: UICollectionView!
    
    var array = [SelectedUser("Dylan"), SelectedUser("Shuyao"), SelectedUser("Bernice"), SelectedUser("Ana"), SelectedUser("Shi Han"), SelectedUser("Jiang En")]
    let splitHow = ["Equally", "Unequally"]
    var splitEqually = true
    var paidBy: SelectedUser?
    var paidByIndexPath: IndexPath?
    var splitBtw = [SelectedUser]()
    //var amount = 0.0
    var lastIndexPath: IndexPath = [1, 0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        amtTextField.delegate = self
        whoPaidScrollView.dataSource = self
        whoPaidScrollView.delegate = self
        splitByWho.dataSource = self
        splitByWho.delegate = self
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
        //performs selection of the cells
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
            print(splitBtw.map({ user in
                user.name
            }))
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
                print(paidBy!.name)
                
            }
            if collectionView == splitHowCV && indexPath != lastIndexPath {
                cell.rectangleView.backgroundColor = UIColor(named: "Dark Blue")
                cell.nameLabel.backgroundColor = UIColor(named: "Dark Blue")
                if let prevCell = collectionView.cellForItem(at: lastIndexPath) as? GroupMemberCollectionViewCell {
                    prevCell.rectangleView.backgroundColor = UIColor(named: "Medium Blue")
                    prevCell.nameLabel.backgroundColor = UIColor(named: "Medium Blue")
                    array[lastIndexPath.row].paidBySelected = false
                    if cell.nameLabel.text == "Unequally" {
                        splitEqually = false
                        //if amtTextField.hasText {
                        performSegue(withIdentifier: "goToUnequalGroupExpensesPage", sender: collectionView.delegate)
                        //}
                        print(splitEqually)
                    } else {
                        splitEqually = true
                        print(splitEqually)
                    }
                }
                lastIndexPath = indexPath
            }
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        //saves and updates debts
        self.dismiss(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToUnequalGroupExpensesPage" {
            let destinationVC = segue.destination as! UnequalGroupExpensesTableViewController
            destinationVC.array = splitBtw
            destinationVC.amt = Double(amtTextField.text!)
        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //if !splitEqually && textField.hasText {
            self.resignFirstResponder()
            performSegue(withIdentifier: "goToUnequalGroupExpensesPage", sender: self)
            print("segue triggered")
        //}
        return true
    }
}
