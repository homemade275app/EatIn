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
        self.view.addSubview(zipLabel)

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
        nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 12).isActive = true
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
