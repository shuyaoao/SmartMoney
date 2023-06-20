//
//  GroupsViewController.swift
//  SmartMoney
//
//  Created by Shuyao Li on 19/5/23.
//

import UIKit
import SwipeCellKit

class GroupsViewController: UITableViewController {
    
    var groupArray: [Group] = [Family(), Friends(), Hexagon()]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
        // Do any additional setup after loading the view.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupArray.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToGroupDetails", sender: self)
        //go to groupDetailsView when a specific group is selected
    }
    
    func updateData() {
        for group in groupArray {
            group.updateTotalBalance()
        }
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //if user presses on the group, prepare for navigation to GroupDetailsViewController
        if segue.identifier == "goToGroupDetails" {
            let destinationVC = segue.destination as! GroupDetailsViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                //destinationVC.navigationBar.title = groupArray[indexPath.row].groupName
                destinationVC.group = groupArray[indexPath.row]
                destinationVC.amount = groupArray[indexPath.row].owedAmount
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
            newGroup.addMember(User("Shuyao")) //to replace with logged in user after database has been inplemented
            for (_, user) in vc.members {
                newGroup.addMember(user)
            }
            self.groupArray.append(newGroup)
            self.tableView.reloadData()
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
            self.groupArray.remove(at: indexPath.row)
        }

        // customize the action appearance
        deleteAction.image = UIImage(named: "trash.fill")

        return [deleteAction]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //configures the table cell to display group information(name and summarised debt)
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as! GroupTableViewCell
        cell.delegate = self
        cell.nameLabel.text = groupArray[indexPath.row].groupName
        let amt = groupArray[indexPath.row].owedAmount
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
