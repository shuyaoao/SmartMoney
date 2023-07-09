//
//  ProfileViewController.swift
//  SmartMoney
//
//  Created by Shuyao Li on 19/5/23.
//

import UIKit
import SwiftUI
import Firebase
import FirebaseAuth
import Combine
//import FirebaseStorage

class ProfileViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //in the future, this part will incorporate with the database to display user information
        profilePicture.layer.cornerRadius = profilePicture.frame.size.width / 2
        profilePicture.clipsToBounds = true
        profilePicture.layer.borderWidth = 4
        profilePicture.layer.borderColor = UIColor(named: "Dark Blue")?.cgColor
        nameLabel.text = "Shuyao" //to be changed to incoporate user input at welcome page
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func logoutButtonPressed(_ sender: UIButton) {
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
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
//    func uploadPhotoToDatabase() {
//        //turn photo into data
//        guard profilePicture.image != nil else {
//            return
//        }
//        let imageData = profilePicture.image?.jpegData(compressionQuality: 0.8)
//
//        guard imageData != nil else {
//            return
//        }
//        //create storage reference
//        let user = Auth.auth().currentUser
//        let databaseRef = Storage.storage().reference().child("users")
//        let userRef = databaseRef.child(user!.uid)
//        let profilePictureRef = userRef.child("profilePicture")
//
//        // put image data into database
//        let uploadTask = profilePictureRef.put
//    }
    
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
