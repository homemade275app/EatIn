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
        self.view.addSubview(cityLabel)
        self.view.addSubview(cityTextField)

        
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
    
    let cityLabel: UILabel = {
        let cityLabel = UILabel()
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        cityLabel.textAlignment = .left
        cityLabel.textColor = .orange
        cityLabel.text = "City"
        return cityLabel
    }()
    
    let cityTextField: UITextField = {
        let cityTextField = UITextField()
        cityTextField.placeholder = "Enter City"
        cityTextField.translatesAutoresizingMaskIntoConstraints = false
        return cityTextField
    }()
    
    
    @objc func saveButtonAction(sender: UIButton!) {
        
        print("Save was pressed")

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
        if let text = cityTextField.text, !text.isEmpty
        {
            //do something if it's not empty
            print("City field text: " + cityTextField.text!)
            //users city in database updated to cityTextField.text
        }
        else{
            print("City field is empty")
            
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
        
        cityLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cityLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 12).isActive = true
        cityLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        cityLabel.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        cityTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cityTextField.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 12).isActive = true
        cityTextField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        cityTextField.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        
    }
    
    
    
 
    
    
}
