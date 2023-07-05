//
//  RegisterViewController.swift
//  SmartMoney
//
//  Created by Shuyao Li on 18/6/23.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {
    var alertMessage = ""
    var alertController: UIAlertController?
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)

        // Do any additional setup after loading the view.
    }
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        print(confirmPasswordTextField.text!)
        print(passwordTextField.text!)
        register()
    }
    
    func register() {
        print(passwordTextField.text! == confirmPasswordTextField.text!)
        if passwordTextField.text! != confirmPasswordTextField.text! {
            alertMessage = "Please check that both your passwords match."
            showAlert()
        } else {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { result, error in
                if error != nil {
                    self.alertMessage = error!.localizedDescription
                    self.showAlert()
                } else {
                    self.dismiss(animated: true)
                }
            }
        }
    }
    
    // Alert Warning Popup
    func showAlert() {
        self.alertController = UIAlertController(title: "Error", message: alertMessage, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            // Handle OK button action (if needed)
            self?.dismissAlert()
        }
        
        self.alertController?.addAction(okAction)
        
        // Present the alert controller
        present(alertController!, animated: true, completion: nil)
    }
    
    func dismissAlert() {
        alertController?.dismiss(animated: true, completion: nil)
        alertController = nil
    }
}
