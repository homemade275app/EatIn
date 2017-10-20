//
//  ProfileController.swift
//  eatin
//
//  Created by Blaine Andreoli on 10/12/17.
//  Copyright © 2017 CS275. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FBSDKLoginKit

class ProfileController: UIViewController {
    
    let profileButton: UIButton = {
        let profileButton = UIButton()
        profileButton.backgroundColor = .clear
        profileButton.layer.cornerRadius = 5
        profileButton.layer.borderWidth = 2
        profileButton.translatesAutoresizingMaskIntoConstraints = false
        profileButton.layer.borderColor = UIColor.orange.cgColor
        profileButton.setTitle("User Profile", for: .normal)
        profileButton.setTitleColor(UIColor.orange, for: .normal)
        profileButton.addTarget(self, action: #selector(profileButtonAction), for: .touchUpInside)
        return profileButton
    }()
    
    let notificationsButton: UIButton = {
        let notificationsButton = UIButton()
        notificationsButton.backgroundColor = .clear
        notificationsButton.layer.cornerRadius = 5
        notificationsButton.layer.borderWidth = 2
        notificationsButton.translatesAutoresizingMaskIntoConstraints = false
        notificationsButton.layer.borderColor = UIColor.orange.cgColor
        notificationsButton.setTitle("Notifications", for: .normal)
        notificationsButton.setTitleColor(UIColor.orange, for: .normal)
        notificationsButton.addTarget(self, action: #selector(notificationsButtonAction), for: .touchUpInside)
        return notificationsButton
    }()
    
    let becomeAChefButton: UIButton = {
        let becomeAChefButton = UIButton()
        becomeAChefButton.backgroundColor = .clear
        becomeAChefButton.layer.cornerRadius = 5
        becomeAChefButton.layer.borderWidth = 2
        becomeAChefButton.translatesAutoresizingMaskIntoConstraints = false
        becomeAChefButton.layer.borderColor = UIColor.orange.cgColor
        becomeAChefButton.setTitle("Become A Chef", for: .normal)
        becomeAChefButton.setTitleColor(UIColor.orange, for: .normal)
        becomeAChefButton.addTarget(self, action: #selector(becomeAChefButtonAction), for: .touchUpInside)
        return becomeAChefButton
    }()
    
    let feedbackButton: UIButton = {
        let feedbackButton = UIButton()
        feedbackButton.backgroundColor = .clear
        feedbackButton.layer.cornerRadius = 5
        feedbackButton.layer.borderWidth = 2
        feedbackButton.translatesAutoresizingMaskIntoConstraints = false
        feedbackButton.layer.borderColor = UIColor.orange.cgColor
        feedbackButton.setTitle("Give Us Feedback", for: .normal)
        feedbackButton.setTitleColor(UIColor.orange, for: .normal)
        feedbackButton.addTarget(self, action: #selector(feedbackButtonAction), for: .touchUpInside)
        return feedbackButton
    }()
    
    let helpButton: UIButton = {
        let helpButton = UIButton()
        helpButton.backgroundColor = .clear
        helpButton.layer.cornerRadius = 5
        helpButton.layer.borderWidth = 2
        helpButton.translatesAutoresizingMaskIntoConstraints = false
        helpButton.layer.borderColor = UIColor.orange.cgColor
        helpButton.setTitle("Help", for: .normal)
        helpButton.setTitleColor(UIColor.orange, for: .normal)
        helpButton.addTarget(self, action: #selector(helpButtonAction), for: .touchUpInside)
        return helpButton
    }()
    
    let settingsButton: UIButton = {
        let settingsButton = UIButton()
        settingsButton.backgroundColor = .clear
        settingsButton.layer.cornerRadius = 5
        settingsButton.layer.borderWidth = 2
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        settingsButton.layer.borderColor = UIColor.orange.cgColor
        settingsButton.setTitle("Settings", for: .normal)
        settingsButton.setTitleColor(UIColor.orange, for: .normal)
        settingsButton.addTarget(self, action: #selector(settingsButtonAction), for: .touchUpInside)
        return settingsButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(r: 255, g: 255, b: 255)
        
        self.title = "Profile"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
        self.view.addSubview(profileButton)
        self.view.addSubview(notificationsButton)
        self.view.addSubview(becomeAChefButton)
        self.view.addSubview(feedbackButton)
        self.view.addSubview(helpButton)
        self.view.addSubview(settingsButton)
        
        addProfileButtons()
    }
    
    func addProfileButtons() {
        profileButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileButton.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 12).isActive = true
        profileButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        profileButton.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        notificationsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        notificationsButton.topAnchor.constraint(equalTo: profileButton.bottomAnchor, constant: 12).isActive = true
        notificationsButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        notificationsButton.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        becomeAChefButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        becomeAChefButton.topAnchor.constraint(equalTo: notificationsButton.bottomAnchor, constant: 12).isActive = true
        becomeAChefButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        becomeAChefButton.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        feedbackButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        feedbackButton.topAnchor.constraint(equalTo: becomeAChefButton.bottomAnchor, constant: 12).isActive = true
        feedbackButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        feedbackButton.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        helpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        helpButton.topAnchor.constraint(equalTo: feedbackButton.bottomAnchor, constant: 12).isActive = true
        helpButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        helpButton.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        settingsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        settingsButton.topAnchor.constraint(equalTo: helpButton.bottomAnchor, constant: 12).isActive = true
        settingsButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        settingsButton.heightAnchor.constraint(equalToConstant: 75).isActive = true
    }
    
    @objc func profileButtonAction(sender: UIButton!) {
        let userProfileController = UINavigationController(rootViewController: UserProfileController())
        present(userProfileController, animated: true, completion: nil)
    }
    
    @objc func notificationsButtonAction(sender: UIButton!) {
        let notificationsController = UINavigationController(rootViewController: NotificationsController())
        present(notificationsController, animated: true, completion: nil)
    }
    
    @objc func becomeAChefButtonAction(sender: UIButton!) {
        let becomeAChefController = UINavigationController(rootViewController: BecomeAChefController())
        present(becomeAChefController, animated: true, completion: nil)
    }
    
    @objc func feedbackButtonAction(sender: UIButton!) {
        let feedbackController = UINavigationController(rootViewController: FeedbackController())
        present(feedbackController, animated: true, completion: nil)
    }
    
    
    @objc func helpButtonAction(sender: UIButton!) {
        let helpController = UINavigationController(rootViewController: HelpController())
        present(helpController, animated: true, completion: nil)
    }
    
    @objc func settingsButtonAction(sender: UIButton!) {
        let settingsController = UINavigationController(rootViewController: SettingsController())
        present(settingsController, animated: true, completion: nil)
    }
    
    @objc
    func handleLogout() {
        
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        if(FBSDKAccessToken.current() != nil) {
            let loginManager = FBSDKLoginManager()
            loginManager.logOut()
        }
        
        let introController = IntroController()
        
        present(introController, animated: true, completion: nil)
    }
}
