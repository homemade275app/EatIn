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
        
        setUpTabView()
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
    
    func setUpTabView() {
        let tabOne = ExploreController()
        let tabTwo = CategoryController()
        let tabThree = SavedController()
        let tabFour = InboxController()
        let tabFive = ProfileController()
        
        let tabOneBarItem = UITabBarItem(title: "Tab 1", image: UIImage(named: "defaultImage.png"), selectedImage: UIImage(named: "selectedImage.png"))
        
        tabOne.tabBarItem = tabOneBarItem
        
        let tabTwoBarItem = UITabBarItem(title: "Tab 2", image: UIImage(named: "defaultImage.png"), selectedImage: UIImage(named: "selectedImage.png"))
        
        tabTwo.tabBarItem = tabTwoBarItem
        
        let tabThreeBarItem = UITabBarItem(title: "Tab 3", image: UIImage(named: "defaultImage.png"), selectedImage: UIImage(named: "selectedImage.png"))
        
        tabThree.tabBarItem = tabThreeBarItem
        
        let tabFourBarItem = UITabBarItem(title: "Tab 4", image: UIImage(named: "defaultImage.png"), selectedImage: UIImage(named: "selectedImage.png"))
        
        tabFour.tabBarItem = tabFourBarItem
        
        let tabFiveBarItem = UITabBarItem(title: "Tab 5", image: UIImage(named: "defaultImage.png"), selectedImage: UIImage(named: "selectedImage.png"))
        
        tabFive.tabBarItem = tabFiveBarItem
        
        self.viewControllers = [tabOne, tabTwo, tabThree, tabFour, tabFive]
    }
}

