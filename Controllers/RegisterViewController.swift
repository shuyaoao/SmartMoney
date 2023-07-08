//
//  RegisterViewController.swift
//  SmartMoney
//
//  Created by Shuyao Li on 18/6/23.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class RegisterViewController: UIViewController {
    var alertMessage = ""
    var alertController: UIAlertController?
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var profileNameTextField: UITextField!
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
                // Authentication Failed
                if error != nil {
                    self.alertMessage = error!.localizedDescription
                    self.showAlert()
                    
                // Authentication Successful
                } else {
                    guard let user = result?.user else { return }
                        
                    // MARK: Update user name for the user
                    let changeRequest = user.createProfileChangeRequest()
                    changeRequest.displayName = self.profileNameTextField.text // Set the user's name
                    changeRequest.commitChanges { error in
                        if let error = error {
                            // Handle profile update error
                            print("Profile update error: \(error.localizedDescription)")
                        } else {
                            // Name successfully added to the user's profile
                            print("Name added to user profile: \(user.displayName ?? "")")
                        }
                    }
                    
                    // MARK: Initialise data upon registration
                    let databaseRef = Database.database().reference()
                    let usersRef = databaseRef.child("users")
                    // Access user content
                    usersRef.setValue(user.uid)
                    
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
