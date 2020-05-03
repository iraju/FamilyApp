//
//  SignUpViewController.swift
//  FamilyApp
//
//  Created by Naresh Itharaju on 4/17/20.
//  Copyright © 2020 naniCode. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class SignUpViewController: UIViewController {

    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var errorLabel: UILabel!
    var selectedImage: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        errorLabel.text = "Something went worng please try again"
        errorLabel.isHidden = true
        imageview.layer.cornerRadius = 50
        imageview.clipsToBounds = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.handleSelectImage))
        imageview.addGestureRecognizer(tapGesture)
        imageview.isUserInteractionEnabled = true

    }
    @objc func handleSelectImage(){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
    @IBAction func signUP_tapped(_ sender: Any) {
        
        Auth.auth().createUser(withEmail: email.text!, password: password.text!, completion: { (user, error) in
                if error != nil{
                    print(error!.localizedDescription)
            }
                    let uid = Auth.auth().currentUser!.uid
                    let storageref = Storage.storage().reference(forURL: "gs://familyapp-6924f.appspot.com").child("profile_pic").child(uid)
                    if  let profileimg = self.selectedImage, let data = profileimg.jpegData(compressionQuality: 0.5){
                        storageref.putData(data, metadata: nil, completion: { (UserMetadata, error) in
                            if error != nil {
                                return
                            }
                    let ref: DatabaseReference!
                    ref = Database.database().reference()
                    let userRef = ref.child("users")
                    let newUserRef = userRef.child(uid)
                    newUserRef.setValue(["userName": self.firstName.text!, "email": self.email.text!])
                            })
                }
            
            })
            
        }
    
}
extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerOriginalImage")] as? UIImage {
            selectedImage = image
            imageview.image = image
        }
        dismiss(animated: true, completion: nil)
        
    }
}
