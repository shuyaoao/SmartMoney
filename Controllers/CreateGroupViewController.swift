//
//  CreateGroupViewController.swift
//  SmartMoney
//
//  Created by Shuyao Li on 19/5/23.
//

import UIKit

class CreateGroupViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var groupMembersTableView: UITableView!
    var lastTextFiledFrame: CGFloat = CGFloat.zero
    @IBOutlet weak var groupNameTextField: UITextField!
    weak var delegate : CreateGroupViewControllerDelegate?
    @IBOutlet weak var editButton: UIButton!
    var count = 1
    var members = [Int:User]()
    var alertController: UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //registering the custom table cell
        let nib = UINib(nibName: GroupMemberTableViewCell.id, bundle: nil)
        groupNameTextField.tag = 0
        groupMembersTableView.register(nib, forCellReuseIdentifier: GroupMemberTableViewCell.id)
        groupMembersTableView.dataSource = self
        groupMembersTableView.delegate = self
        groupMembersTableView.reloadData()
        groupNameTextField.delegate = self
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    //if user presses cancel, dismiss this screen and show the GroupsViewController
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    //dismiss this screen and show the GroupsViewController with the new group
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        //functionality to create a new group and update database
        if groupNameTextField.text == "" || members.count <= 0 {
            showAlert()
        } else {
            delegate?.updateData(self)
            self.dismiss(animated: true)
        }
    }
    
    //show alerts
    func showAlert() {
        if groupNameTextField.text == "" {
            alertController = UIAlertController(title: "You have not entered a group name!", message: "Please check your inputs", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
                // Handle OK button action (if needed)
                self?.dismissAlert()
            }
            
            alertController?.addAction(okAction)
            // Present the alert controller
            present(alertController!, animated: true, completion: nil)
        } else if members.isEmpty {
            alertController = UIAlertController(title: "You must enter at least one group member!", message: "Please check your inputs", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
                // Handle OK button action (if needed)
                self?.dismissAlert()
            }
            
            alertController?.addAction(okAction)
            // Present the alert controller
            present(alertController!, animated: true, completion: nil)
        }
    }
    
    func dismissAlert() {
        alertController?.dismiss(animated: true, completion: nil)
        alertController = nil
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        //some function to add another textfield to add more group members
        count += 1
        groupMembersTableView.reloadData()
    }
    
    @IBAction func editButtonPressed(_ sender: Any) {
        //toggles in and out of editing mode
        if groupMembersTableView.isEditing == false {
            editButton.setTitle("Done", for: .normal)
            groupMembersTableView.setEditing(true, animated: true)
        } else {
            editButton.setTitle("Delete", for: .normal)
            groupMembersTableView.setEditing(false, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //allows deletion of a group
        if editingStyle == .delete {
            count -= 1
            groupMembersTableView.deleteRows(at: [indexPath], with: .fade)
            members.removeValue(forKey: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //populates tableview with groups
        let cell = groupMembersTableView.dequeueReusableCell(withIdentifier: "GroupMemberTableViewCell") as! GroupMemberTableViewCell
        cell.memberNameTextField.delegate = self
        cell.memberNameTextField.tag = indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
}

protocol CreateGroupViewControllerDelegate : AnyObject {
    func updateData(_ vc: CreateGroupViewController)
    //call back to GroupsViewContoller
}

extension CreateGroupViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //records the group members of a group
        textField.resignFirstResponder()
        if textField.text != "" && textField != groupNameTextField {
            members[textField.tag] = User(textField.text!)
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //records the group members of a group
        textField.resignFirstResponder()
        if textField.text != "" && textField != groupNameTextField {
            members[textField.tag] = User(textField.text!)
        }
    }
}
