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
    weak var delegate : CreateGroupViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    }
    
}

protocol CreateGroupViewControllerDelegate : AnyObject {
    func updateData(_ vc: CreateGroupViewController)
    //call back to GroupsViewContoller
}
