
//  SmartMoney
//
//  Created by Shuyao Li on 19/5/23.
//


//  SmartMoney
//
//  Created by Shuyao Li on 19/5/23.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class HomePageViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    //@IBOutlet weak var updatedNameTextField: UITextField!
    @IBOutlet weak var profilePicture: UIImageView!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //add in function to retrieve name from database
        
        retrievePhoto()
        //updatedNameTextField.isHidden = true
        //updatedNameTextField.delegate = self
        profilePicture.layer.cornerRadius = profilePicture.frame.size.width / 2
        profilePicture.clipsToBounds = true
        profilePicture.layer.borderWidth = 4
        profilePicture.layer.borderColor = UIColor(named: "Dark Blue")?.cgColor
        
        // MARK: Retrieve User Details
        let user = Auth.auth().currentUser
        nameLabel.text = user?.displayName //to be changed to incoporate user input at welcome page
        emailLabel.text = user?.email
        myself = User(user!.uid, user!.displayName!)
        
        // MARK: Load all Data of the User
        print("Loading transactions")
        loadTransactions()
        print("Transactions successfully loaded")
        
        print("Loading Groups")
        loadGroups()
        print("Groups successfully loaded")
        
        print("Loading Budget Data")
        loadBudgets()
        print("Budgets successfully loaded")
    }
    
    @IBAction func logoutButtonPressed(_ sender: UIButton) {
        // Clear viewstack
        
        performSegue(withIdentifier: "logout", sender: self)
    }

    
    @IBAction func importPicture(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.originalImage] as? UIImage else { return }
        profilePicture.image = image
        
        picker.dismiss(animated: true, completion: nil)
        uploadPhotoToDatabase()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func uploadPhotoToDatabase() {
        //turn photo into data
        guard profilePicture.image != nil else {
            return
        }
        let storageRef = Storage.storage().reference()
        let imageData = profilePicture.image?.pngData()
        guard imageData != nil else {
            return
        }
        let path = "images/\(UUID().uuidString).png"
        let fileRef = storageRef.child(path)
        let uploadTask = fileRef.putData(imageData!) { _, error in
            guard error == nil else {
                print("Failed to upload")

                return
            }
            let user = Auth.auth().currentUser
            let databaseRef = Database.database().reference().child("users")
            let userRef = databaseRef.child(user!.uid)
            // Add image url to user database
            userRef.child("profileImage").setValue(path)
            print("profile image uploaded")
        }
    }
    
    func retrievePhoto() {
        let user = Auth.auth().currentUser
        
        if let user = user {
            print("user exists")
            let uid = user.uid
            
            // MARK: Navigate to User Branch
            let databaseRef = Database.database().reference().child("users")
            let userRef = databaseRef.child(uid)
            let imageRef = userRef.child("profileImage")
            
            imageRef.observe(.value, with: { snapshot in
                // Check if snapshot exist
                if snapshot.exists() {
                    print("profile pic snapshot exists")
                    let url = snapshot.value as! String
                    print(url)
                    let storageRef = Storage.storage().reference().child(url)
                    storageRef.getData(maxSize: 1 * 3000 * 3000) { data, error in
                        if error == nil && data != nil {
                            print("no errors")
                            let image = UIImage(data: data!)
                            DispatchQueue.main.async {
                                self.profilePicture.image = image
                                print("profile picture set")
                            }
                        } else if data == nil && error != nil {
                            print("no data")
                        } else {
                            print("there are errors")
                        }
                        
                    }
                } else {
                    print("profile pic doesnt exist")
                    //self.uploadPhotoToDatabase()
                    print("default image uploaded and retrived")
                }
            })
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    //makes the profile picture round
    func round(image: UIImage) -> UIImage {
        let imageWidth = image.size.width
        let imageHeight = image.size.height
        
        let diameter = min(imageWidth, imageHeight)
        let isLandscape = imageWidth > imageHeight
        
        let xOffset = isLandscape ? (imageWidth - diameter) / 2 : 0
        let yOffset = isLandscape ? 0 : (imageHeight - diameter) / 2
        
        let imageSize = CGSize(width: diameter, height: diameter)
        
        return UIGraphicsImageRenderer(size: imageSize).image { _ in
            
            let ovalPath = UIBezierPath(ovalIn: CGRect(origin: .zero, size: imageSize))
            ovalPath.addClip()
            image.draw(at: CGPoint(x: -xOffset, y: -yOffset))
            UIColor.white.setStroke()
            ovalPath.lineWidth = diameter / 50
            ovalPath.stroke()
        }
    }
    
}

extension HomePageViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text != "" {
            nameLabel.text = textField.text
            welcomeLabel.text = "Welcome, \(textField.text!)"
            //update database
        }
        self.resignFirstResponder()
        //updatedNameTextField.isHidden = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            nameLabel.text = textField.text
            welcomeLabel.text = "Welcome, \(textField.text!)"
            //update database
        }
        self.resignFirstResponder()
        //updatedNameTextField.isHidden = true
        return true
    }
}
