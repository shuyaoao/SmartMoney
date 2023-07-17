//
//  GroupsViewController.swift
//  SmartMoney
//
//  Created by Shuyao Li on 19/5/23.
//

import UIKit
import SwipeCellKit
import Combine
import Firebase
import FirebaseAuth

class GroupsViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
        // Do any additional setup after loading the view.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupsDataModel.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToGroupDetails", sender: self)
        //go to groupDetailsView when a specific group is selected
    }
    
    func updateData() {
        for group in groupsDataModel {
            group.updateTotalBalance()
        }
        self.tableView.reloadData()
        print(groupsDataModel)
        print("dataReloaded")
    }
    
    func addNewGroupToDatabase(_ group : Group) {
        let user = Auth.auth().currentUser
        let databaseRef = Database.database().reference().child("users")
        let userRef = databaseRef.child(user!.uid)
        let groupsRef = userRef.child("groups")
        
        // Add new group with id
        groupsRef.child(group.id).setValue(group.toDictionary())
        print("Added Group to Database")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //if user presses on the group, prepare for navigation to GroupDetailsViewController
        if segue.identifier == "goToGroupDetails" {
            let destinationVC = segue.destination as! GroupDetailsViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                //destinationVC.navigationBar.title = groupArray[indexPath.row].groupName
                destinationVC.group = groupsDataModel[indexPath.row]
                destinationVC.amount = groupsDataModel[indexPath.row].owedAmount
                destinationVC.prevVC = self
            }
        //else if user presses on the plus button, prepare for navigation to CreateGroupViewController
        } else if segue.identifier == "createGroup" {
            let destinationVC = segue.destination as! CreateGroupViewController
            destinationVC.delegate = self
        }
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "createGroup", sender: self)
        //navigate to CreateGroupViewController
    }
}

extension GroupsViewController : CreateGroupViewControllerDelegate {
    func updateData(_ vc: CreateGroupViewController) {
        if let text = vc.groupNameTextField.text {
            let newGroup = Group(text)
            newGroup.addMember(myself)
            newGroup.simplifier.userController.addUser(myself)
            for (_, user) in vc.members {
                newGroup.addMember(user)
                newGroup.simplifier.userController.addUser(user)
            }
            groupsDataModel.append(newGroup)
            addNewGroupToDatabase(newGroup)
            self.tableView.reloadData()
            print("new group added")
        //retrieve date from CreateGroupViewController and add the group to existing array, then refresh the tableview
        }
        
    }
}

extension GroupsViewController : SwipeTableViewCellDelegate {
    //this block of code adds a delete function to enable users to delete a group
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            let groupID = groupsDataModel[indexPath.row].id
            groupsDataModel.remove(at: indexPath.row)
            self.removeGroupFromDatabase(groupID)
        }

        // customize the action appearance
        deleteAction.image = UIImage(named: "trash.fill")

        return [deleteAction]
    }
    
    func removeGroupFromDatabase(_ id: String) {
        // Remove group from database
        let user = Auth.auth().currentUser
        let databaseRef = Database.database().reference().child("users")
        let userRef = databaseRef.child(user!.uid)
        let groupsRef = userRef.child("groups")
        
        groupsRef.child(id).removeValue { error, _ in
            if let error = error {
                print("Error removing value: \(error.localizedDescription)")
            } else {
                print("Value removed successfully.")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //configures the table cell to display group information(name and summarised debt)
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as! GroupTableViewCell
        cell.delegate = self
        cell.nameLabel.text = groupsDataModel[indexPath.row].groupName
        let amt = groupsDataModel[indexPath.row].owedAmount
        if amt < 0 {
            cell.amtLabel.text = String(format: "$%.2f", -amt)
            cell.amtLabel.textColor = UIColor.red
        } else if amt == 0 {
            cell.amtLabel.text = String(format: "$%.2f", amt)
            cell.amtLabel.textColor = UIColor.black
        } else {
            cell.amtLabel.text = String(format: "$%.2f", amt)
            cell.amtLabel.textColor = UIColor(named: "green")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        //allows for groups to be deleted
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        //will add in functionality to delete group from database when this action is trgiggered
        return options
    }
}
