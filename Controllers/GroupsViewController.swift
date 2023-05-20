//
//  GroupsViewController.swift
//  SmartMoney
//
//  Created by Shuyao Li on 19/5/23.
//

import UIKit

class GroupsViewController: UITableViewController {
    
    var groupArray = ["Friends", "Family", "Hall Friends", "School", "Drinking Buddies"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
        // Do any additional setup after loading the view.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath)
        cell.textLabel?.text = groupArray[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToGroupDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToGroupDetails" {
            let destinationVC = segue.destination as! GroupDetailsViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.navigationBar.title = groupArray[indexPath.row]
            }
        } else if segue.identifier == "createGroup" {
            let destinationVC = segue.destination as! CreateGroupViewController
            destinationVC.delegate = self
        }
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "createGroup", sender: self)
    }
}

extension GroupsViewController : CreateGroupViewControllerDelegate {
    func updateData(_ vc: CreateGroupViewController) {
        if let text = vc.groupNameTextField.text {
            self.groupArray.append(text)
            self.tableView.reloadData()
        }
        
    }
}
