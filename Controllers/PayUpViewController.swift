//
//  PayUpViewController.swift
//  SmartMoney
//
//  Created by Shuyao Li on 12/6/23.
//

import UIKit

class PayUpViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    var array = [User("Dylan"), User("Shuyao"), User("Bernice"), User("Ana"), User("Shi Han"), User("Jiang En")]
    @IBOutlet weak var fromTableView: UITableView!
    @IBOutlet weak var toTableView: UITableView!
    @IBOutlet weak var amountTextField: UITextField!
    var from: User?
    var to: User?
    var payUpAmount: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toTableView.delegate = self
        toTableView.dataSource = self
        fromTableView.delegate = self
        fromTableView.dataSource = self
        amountTextField.delegate = self
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PayUpCell", for: indexPath) as! PayUpTableViewCell
        if tableView == fromTableView {
            if array[indexPath.row].from {
                cell.rectangleView.backgroundColor = UIColor(named: "Dark Blue")
                cell.nameLabel.backgroundColor = UIColor(named: "Dark Blue")
            } else {
                cell.rectangleView.backgroundColor = UIColor(named: "Medium Blue")
                cell.nameLabel.backgroundColor = UIColor(named: "Medium Blue")
            }
        } else {
            if array[indexPath.row].to {
                cell.rectangleView.backgroundColor = UIColor(named: "Dark Blue")
                cell.nameLabel.backgroundColor = UIColor(named: "Dark Blue")
            } else {
                cell.rectangleView.backgroundColor = UIColor(named: "Medium Blue")
                cell.nameLabel.backgroundColor = UIColor(named: "Medium Blue")
            }
        }
        cell.configure(array[indexPath.row].name)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(array[indexPath.row].name)
        if tableView == fromTableView {
            if array[indexPath.row].name == to?.name {
                print("from and to cannot be the same person!")
            }
            else if from == nil {
                array[indexPath.row].from = true
                from = array[indexPath.row]
            } else {
                var index: Int?
                for (ind, user) in array.enumerated() {
                    if user.name == from!.name {
                        index = ind
                    }
                }
                if let safeIndex = index {
                    array[safeIndex].from = false
                }
                array[indexPath.row].from = true
                from = array[indexPath.row]
            }
        } else {
            if array[indexPath.row].name == from?.name {
                print("from and to cannot be the same person!")
            }
                else if to == nil {
                    array[indexPath.row].to = true
                    to = array[indexPath.row]
                }
            else {
                    var index: Int?
                    for (ind, user) in array.enumerated() {
                        if user.name == to!.name {
                            index = ind
                        }
                    }
                    if let safeIndex = index {
                        array[safeIndex].to = false
                    }
                    array[indexPath.row].to = true
                    to = array[indexPath.row]
                }
            }
        tableView.reloadData()
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        //saves the input
        self.dismiss(animated: true)
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text != "" {
            payUpAmount = Double(textField.text!)
            print(payUpAmount!)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            payUpAmount = Double(textField.text!)
            print(payUpAmount!)
        }
        return true
    }
}
