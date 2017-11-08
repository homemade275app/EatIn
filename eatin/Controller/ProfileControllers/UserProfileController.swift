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


class UserProfileController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(r: 255, g: 255, b: 255)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Return", style: .plain, target: self, action: #selector(handleReturn))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editButtonAction))
        
        self.view.addSubview(nameLabel)
        self.view.addSubview(cityLabel)

        setLabelText()
        addLabels()
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
                let username = value?["name"] as? String ?? "Profile"
                self.nameLabel.text = username
                
                //Set city label
                let city = value?["city"] as? String ?? "City"
                if(city != ""){
                    self.cityLabel.text = city
                
                }
                else{
                    self.cityLabel.text = "City"
                }
                
            }) { (error) in
                print(error.localizedDescription)
            }
        }
        
        
        
        
    }
    
   

    let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.textAlignment = .center
        nameLabel.textColor = .orange
        return nameLabel
    }()
    
    let cityLabel: UILabel = {
        let cityLabel = UILabel()
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        cityLabel.textAlignment = .center
        cityLabel.textColor = .orange
        return cityLabel
    }()
    

    
    
    func addLabels() {
        nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 12).isActive = true
        nameLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        cityLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cityLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 12).isActive = true
        cityLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        cityLabel.heightAnchor.constraint(equalToConstant: 75).isActive = true
        

    }
    
  
    
    @objc func editButtonAction(sender: UIButton!) {
        let editProfileController = UINavigationController(rootViewController: EditProfileController())
        present(editProfileController, animated: true, completion: nil)
    }
 
    
}
