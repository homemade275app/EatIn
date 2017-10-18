//
//  ViewController.swift
//  eatin
//
//  Created by Blaine Andreoli on 10/11/17.
//  Copyright © 2017 CS275. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(Auth.auth().currentUser?.uid == nil) {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        }
    
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
    }
    
    @objc
    func handleLogout() {
        
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        let loginController = LoginController()
        
        present(loginController, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()

        //setup our custom view controllers
        let exploreController = UINavigationController(rootViewController: ExploreController())
        exploreController.tabBarItem.title = "Explore"
        //exploreController.tabBarItem.image = UIImage(named: "explore")

        let categoryController = UINavigationController(rootViewController: CategoryController())
        categoryController.tabBarItem.title = "Categories"
        //categoryController.tabBarItem.image = UIImage(named: "category")

        let savedController = UINavigationController(rootViewController: SavedController())
        savedController.tabBarItem.title = "Saved"
        //savedController.tabBarItem.image = UIImage(named: "saved")

        let inboxController = UINavigationController(rootViewController: InboxController())
        inboxController.tabBarItem.title = "Inbox"
        //inboxController.tabBarItem.image = UIImage(named: "inbox")

        let profileController = UINavigationController(rootViewController: ProfileController())
        profileController.tabBarItem.title = "Profile"
        //profileController.tabBarItem.image = UIImage(named: "profile")

        viewControllers = [exploreController, categoryController, savedController, inboxController, profileController]

    }
}

