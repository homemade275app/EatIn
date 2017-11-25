//
//  UserProfileController.swift
//  eatin
//
//  Created by Blaine Andreoli on 10/19/17.
//  Copyright © 2017 CS275. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import FirebaseStorage
import FirebaseAuth

class UserProfileController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Profile"

        view.backgroundColor = UIColor(r: 255, g: 255, b: 255)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Return", style: .plain, target: self, action: #selector(handleReturn))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editButtonAction))
        
        self.view.addSubview(nameLabel)
        self.view.addSubview(zipLabel)
        self.view.addSubview(image)

        setLabelText()
        addLabels()
        setProfileImage()
    }
    
    @objc
    func setImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func setProfileImage() {
        let id = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().child("users").child(id!)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            if(value?["profileImageUrl"] as? String != nil && value?["profileImageUrl"] as? String != "") {
                let storageRef = Storage.storage().reference(forURL: value?["profileImageUrl"] as! String)
                storageRef.getData(maxSize: 1 * 2048 * 2048) { (data, error) -> Void in
                    if (error != nil) {
                        print(error ?? "error")
                    } else {
                        self.image.setImage(UIImage(data: data!)!, for: UIControlState())
                    }
                }
            }
        })
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImage: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImage = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImage = originalImage
        }
        
        if let newImage = selectedImage {
            image.setImage(newImage, for: UIControlState())
            
            let id = Auth.auth().currentUser?.uid
            
            let storage = Storage.storage().reference().child("profileImages/" + id!)
            let userRef = Database.database().reference().child("users").child(id!)
            
            if let data = UIImagePNGRepresentation(newImage) {
                storage.putData(data).observe(.success) { (snapshot) in
                    if let downloadURL = snapshot.metadata?.downloadURL()?.absoluteString {
                        userRef.updateChildValues(["profileImageUrl" : downloadURL])
                    }
                }
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    func handleReturn() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @objc
    func setLabelText() {

        let ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        if(userID != nil) {
            ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                
                //Set name label
                let username = value?["name"] as? String ?? "Name"
                self.nameLabel.text = username
                
                //Set zip label
                let zip = value?["zip"] as? String ?? "ZIP Code"
                if(zip != ""){
                    self.zipLabel.text = zip
                
                }
                else{
                    self.zipLabel.text = "ZIP Code"
                }
                
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
    let image: UIButton = {
        let image = UIButton()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.addTarget(self, action: #selector(setImage), for: .touchUpInside)
        image.setImage(UIImage(named: "profile"), for: UIControlState())
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.textAlignment = .center
        nameLabel.textColor = .orange
        return nameLabel
    }()
    
    let zipLabel: UILabel = {
        let zipLabel = UILabel()
        zipLabel.translatesAutoresizingMaskIntoConstraints = false
        zipLabel.textAlignment = .center
        zipLabel.textColor = .orange
        return zipLabel
    }()

    func addLabels() {
        image.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        image.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 12).isActive = true
        image.widthAnchor.constraint(equalToConstant: 150).isActive = true
        image.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 12).isActive = true
        nameLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        zipLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        zipLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 12).isActive = true
        zipLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        zipLabel.heightAnchor.constraint(equalToConstant: 75).isActive = true
        

    }
    
    @objc func editButtonAction(sender: UIButton!) {
        let editProfileController = UINavigationController(rootViewController: EditProfileController())
        present(editProfileController, animated: true, completion: nil)
    }
}
