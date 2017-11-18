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


class EditProfileController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Edit Profile"
        
        view.backgroundColor = UIColor(r: 255, g: 255, b: 255)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Return", style: .plain, target: self, action: #selector(handleReturn))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButtonAction))
        
        self.view.addSubview(nameLabel)
        self.view.addSubview(nameTextField)
        self.view.addSubview(zipLabel)
        self.view.addSubview(zipTextField)

        
        addLabels()
    }
    
    @objc
    func handleReturn() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    
    let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.textAlignment = .left
        nameLabel.textColor = .orange
        nameLabel.text = "Name"
        return nameLabel
    }()
    
    let nameTextField: UITextField = {
        let nameTextField = UITextField()
        nameTextField.placeholder = "Enter Name"
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        return nameTextField
    }()
    
    let zipLabel: UILabel = {
        let zipLabel = UILabel()
        zipLabel.translatesAutoresizingMaskIntoConstraints = false
        zipLabel.textAlignment = .left
        zipLabel.textColor = .orange
        zipLabel.text = "ZIP Code"
        return zipLabel
    }()
    
    let zipTextField: UITextField = {
        let zipTextField = UITextField()
        zipTextField.placeholder = "Enter ZIP Code"
        zipTextField.translatesAutoresizingMaskIntoConstraints = false
        return zipTextField
    }()
    
    
    @objc func saveButtonAction(sender: UIButton!) {
        
     //   print("Save was pressed")

        //1. If it's not empty. Save value entered into database
        
        
        
        
      
        
        if let text = nameTextField.text, !text.isEmpty
        {
            //do something if it's not empty
            //users name in database updated to nameTextField.text
            let name = nameTextField.text
        
            //update name in database
            let ref = Database.database().reference()
            guard let uid = Auth.auth().currentUser?.uid else {
                return
            }
            let usersReference = ref.child("users").child(uid)
            usersReference.updateChildValues(["name": name])
      

        }
            
        
        else{
            print("Name field is empty")

        }
        //2. If it's empty. Save the placeholder into the database
        if let text = zipTextField.text, !text.isEmpty
        {
            //do something if it's not empty
            print("Zip field text: " + zipTextField.text!)
     
            //users zip in database updated to zipTextField.text
            let zip = zipTextField.text
            
            //update zip in database
            let ref = Database.database().reference()
            guard let uid = Auth.auth().currentUser?.uid else {
                return
            }
            let usersReference = ref.child("users").child(uid)
            usersReference.updateChildValues(["zip": zip])
        }
        else{
            print("Zip field is empty")
            
        }

        
        
        //3. then handle return (complete)
        handleReturn()
        
    }
    
    
    
    
    func addLabels() {
        nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 12).isActive = true
        nameLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        nameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 12).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        nameTextField.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        zipLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        zipLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 12).isActive = true
        zipLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        zipLabel.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        zipTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        zipTextField.topAnchor.constraint(equalTo: zipLabel.bottomAnchor, constant: 12).isActive = true
        zipTextField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        zipTextField.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        
    }
    
    
    
 
    
    
}
