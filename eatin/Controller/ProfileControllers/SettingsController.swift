//
//  SettingsController.swift
//  eatin
//
//  Created by Blaine Andreoli on 10/19/17.
//  Copyright © 2017 CS275. All rights reserved.
//

import UIKit
import Firebase

import FBSDKLoginKit

class SettingsController: UIViewController {
    

    
    let deleteButton: UIButton = {
        let deleteButton = UIButton()
        deleteButton.backgroundColor = UIColor.red
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.setTitle("Delete Account", for: .normal)
        deleteButton.setTitleColor(UIColor.white, for: .normal)
        deleteButton.addTarget(self, action: #selector(deleteButtonAction), for: .touchUpInside)
        return deleteButton
    }()
    
    let logoutButton: UIButton = {
        let logoutButton = UIButton()
        logoutButton.backgroundColor = UIColor.red
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.setTitle("Logout", for: .normal)
        logoutButton.setTitleColor(UIColor.white, for: .normal)
        logoutButton.addTarget(self, action: #selector(logoutButtonAction), for: .touchUpInside)
        return logoutButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Settings"
        
        view.backgroundColor = UIColor(r: 255, g: 255, b: 255)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Return", style: .plain, target: self, action: #selector(handleReturn))
      
        self.view.addSubview(logoutButton)
        self.view.addSubview(deleteButton)

        
        addButtons()
    }
    
    func addButtons() {
        logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoutButton.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 12).isActive = true
        logoutButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        logoutButton.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        deleteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        deleteButton.topAnchor.constraint(equalTo: logoutButton.bottomAnchor, constant: 12).isActive = true
        deleteButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        deleteButton.heightAnchor.constraint(equalToConstant: 75).isActive = true
    }
    
    
    @objc
    func handleReturn() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc
    func deleteButtonAction() {
        let alert = UIAlertController(title: "Account Deletion", message: "Are you sure you want to delete your account?", preferredStyle: .alert)
        alert.addAction(okAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @objc
    func logoutButtonAction() {
        let alert = UIAlertController(title: "Account Logout", message: "Are you sure you want to logout of your account?", preferredStyle: .alert)
        alert.addAction(yesAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    lazy var okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
        UIAlertAction in
        let user = Auth.auth().currentUser
        let uid = user?.uid
        
        let ref = Database.database().reference().child("users")
        ref.child(uid!).removeValue()
        
        user?.delete() { error in
            if error != nil {
                
            } else {
                do {
                    try Auth.auth().signOut()
                }catch let logoutError {
                    print(logoutError)
                }
            }
        }
        
        let introController = IntroController()
        self.present(introController, animated: true, completion: nil)
    }
    
    lazy var yesAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default) {
        UIAlertAction in
        
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        if(FBSDKAccessToken.current() != nil) {
            let loginManager = FBSDKLoginManager()
            loginManager.logOut()
        }
        
        let introController = InfoController()
        self.present(introController, animated: true, completion: nil)
        
    }
    
}
