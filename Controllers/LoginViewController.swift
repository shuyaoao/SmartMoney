//
//  LoginViewController.swift
//  SmartMoney
//
//  Created by Shuyao Li on 18/6/23.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    var alertMessage = ""
    var alertController: UIAlertController?

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)

        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailText.text ?? "Random", password: passwordText.text ?? "Random") { result, error in
            if error != nil {
                self.alertMessage = error!.localizedDescription
                self.showAlert()
            } else {
                self.performSegue(withIdentifier: "goToHomePage", sender: self)
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
