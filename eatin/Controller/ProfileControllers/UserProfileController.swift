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
        
        self.view.addSubview(locationButton)
        
        
        addButtons()
        getUserInfo()
    }
    
    @objc
    func handleReturn() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func getUserInfo() {
        let ref = Database.database().reference()
        
        let userID = Auth.auth().currentUser?.uid
        
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let username = value?["name"] as? String ?? "Profile"
            
            self.title = username
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }

    let locationButton: UIButton = {
        let locationButton = UIButton()
        locationButton.backgroundColor = UIColor.red
        locationButton.translatesAutoresizingMaskIntoConstraints = false
        locationButton.setTitle("Location", for: .normal)
        locationButton.setTitleColor(UIColor.white, for: .normal)
        locationButton.addTarget(self, action: #selector(locationButtonAction), for: .touchUpInside)
        return locationButton
    }()
    

    
    
    func addButtons() {
        locationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        locationButton.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 12).isActive = true
        locationButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        locationButton.heightAnchor.constraint(equalToConstant: 75).isActive = true
        

    }
    
  
    
    @objc func locationButtonAction(sender: UIButton!) {
        let locationController = UINavigationController(rootViewController: LocationController())
        present(locationController, animated: true, completion: nil)
    }
 
    
}
