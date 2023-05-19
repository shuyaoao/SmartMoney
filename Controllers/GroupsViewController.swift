//
//  GroupsViewController.swift
//  SmartMoney
//
//  Created by Shuyao Li on 19/5/23.
//

import UIKit

class GroupsViewController: UITableViewController {
    
    let groupArray = ["Friends", "Family", "Hall Friends", "School", "Drinking Buddies"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        performSegue(withIdentifier: "", sender: <#T##Any?#>)
//    }
    @IBAction func addButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "createGroup", sender: self)
    }
}
