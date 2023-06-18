//
//  GroupsViewController.swift
//  SmartMoney
//
//  Created by Shuyao Li on 19/5/23.
//

import UIKit
import SwipeCellKit

class GroupsViewController: UITableViewController {
    
    var groupArray = [Group(10.00, "Friends"), Group(20.00, "Family"), Group(-30.50, "Hall Friends"), Group(20.25, "School"), Group(100.20, "Drinking Buddies")]
    
    
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
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //if user presses on the group, prepare for navigation to GroupDetailsViewController
        if segue.identifier == "goToGroupDetails" {
            let destinationVC = segue.destination as! GroupDetailsViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                //destinationVC.navigationBar.title = groupArray[indexPath.row].groupName
                destinationVC.groupName = groupArray[indexPath.row].groupName
                destinationVC.amount = groupArray[indexPath.row].owedAmount
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
            self.groupArray.append(Group(0, text))
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as! GroupTableViewCell
        cell.delegate = self
        cell.nameLabel.text = groupArray[indexPath.row].groupName
        let amt = groupArray[indexPath.row].owedAmount
        if amt < 0 {
            cell.amtLabel.text = String(format: "$%.2f", -amt)
            cell.amtLabel.textColor = UIColor.systemGreen
        } else if amt == 0 {
            cell.amtLabel.text = String(format: "$%.2f", amt)
            cell.amtLabel.textColor = UIColor.black
        } else {
            cell.amtLabel.text = String(format: "$%.2f", amt)
            cell.amtLabel.textColor = UIColor.red
        }
//        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        return options
    }
}
