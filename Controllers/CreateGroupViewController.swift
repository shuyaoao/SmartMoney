//
//  CreateGroupViewController.swift
//  SmartMoney
//
//  Created by Shuyao Li on 19/5/23.
//

import UIKit

class CreateGroupViewController: UIViewController {

    var lastTextFiledFrame: CGFloat = CGFloat.zero
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        //add in functionality to create a new group and update database
        self.dismiss(animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        //some function to add another textfield below
    }
    
}
