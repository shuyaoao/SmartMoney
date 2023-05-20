//
//  CreateGroupViewController.swift
//  SmartMoney
//
//  Created by Shuyao Li on 19/5/23.
//

import UIKit

class CreateGroupViewController: UIViewController {

    var lastTextFiledFrame: CGFloat = CGFloat.zero
    @IBOutlet weak var groupNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        //add in functionality to create a new group and update database
        performSegue(withIdentifier: "createdGroup", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createdGroup" {
            let destinationVC = segue.destination as! GroupsViewController
            if let text = groupNameTextField.text {
                destinationVC.groupArray.append(text)
                destinationVC.tableView.reloadData()
            }
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        //some function to add another textfield below
    }
    
}
