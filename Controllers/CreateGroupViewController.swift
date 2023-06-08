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
    var array = [0, 1]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //_ = UINib(nibName: GroupMemberTableViewCell.id, bundle: nil)
        //groupMembersTableView.register(nib, forCellReuseIdentifier: GroupMemberTableViewCell.id)
        groupMembersTableView.dataSource = self
        groupMembersTableView.delegate = self
        groupMembersTableView.reloadData()
        groupNameTextField.delegate = self
    }
    //if user presses cancel, dismiss this screen and show the GroupsViewController
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    //dismiss this screen and show the GroupsViewController with the new group
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        //add in functionality to create a new group and update database
        delegate?.updateData(self)
        self.dismiss(animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        //some function to add another textfield to add more group members
        array.append(array.count)
        groupMembersTableView.reloadData()
    }
    
    @IBAction func editButtonPressed(_ sender: Any) {
        if groupMembersTableView.isEditing == false {
            editButton.setTitle("Done", for: .normal)
            groupMembersTableView.setEditing(true, animated: true)
        } else {
            editButton.setTitle("Edit", for: .normal)
            groupMembersTableView.setEditing(false, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            array.remove(at: indexPath.row)
            groupMembersTableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = groupMembersTableView.dequeueReusableCell(withIdentifier: "GroupMemberTableViewCell") as! GroupMemberTableViewCell
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
            textField.resignFirstResponder()
            return true
        }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
        }
}
