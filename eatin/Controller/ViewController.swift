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
    
    var pageList : [UINavigationController] = []
    
    var set = 0;
    
    fileprivate lazy var defaultTabBarHeight = { tabBar.frame.size.height }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabs()
        checkIfUserIsLoggedIn()
        
    }
    
    func checkIfUserIsLoggedIn(){
        
        if(Auth.auth().currentUser?.uid == nil) {
            set = 0
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        }else {
            let uid = Auth.auth().currentUser?.uid
            Database.database().reference().child("Users").child(uid!).observeSingleEvent(of:.value, with:{ (snapshot) in print(snapshot)}, withCancel: nil)
        }
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let newTabBarHeight = defaultTabBarHeight + 20.0
        
        var newFrame = tabBar.frame
        newFrame.size.height = newTabBarHeight
        newFrame.origin.y = view.frame.size.height - newTabBarHeight
        
        tabBar.frame = newFrame
    }
    
    func setupTabs() {
        let feedController = ExploreController(collectionViewLayout: UICollectionViewFlowLayout())
        let exploreController = UINavigationController(rootViewController: feedController)
        exploreController.tabBarItem.title = "Explore"
        exploreController.tabBarItem.image = UIImage(named: "explore")
        pageList.append(exploreController)
        
        pageList.append(UINavigationController())
        
        let inboxController = UINavigationController(rootViewController: InboxController())
        inboxController.tabBarItem.title = "Inbox"
        inboxController.tabBarItem.image = UIImage(named: "inbox")
        pageList.append(inboxController)
        
        let profileController = UINavigationController(rootViewController: ProfileController())
        profileController.tabBarItem.title = "Profile"
        profileController.tabBarItem.image = UIImage(named: "profile")
        pageList.append(profileController)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let userID = Auth.auth().currentUser?.uid
        
        if(set == 0 || userID != nil) {
            getChefPage()
            set = 1
        }
    }
    
    @objc
    func handleLogout() {
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        let introController = IntroController()
        
        present(introController, animated: true, completion: nil)
    }
    
    func getChefPage(){
        
        let ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        if(userID != nil) {
            ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                let chefStatus = value?["chefStatus"] as? String ?? "0"
                if(chefStatus == "1") {
                    let chefMenuController = UINavigationController(rootViewController: ChefMenuController())
                    chefMenuController.tabBarItem.title = "Your Menu"
                    chefMenuController.tabBarItem.image = UIImage(named: "chef")
                    self.pageList[1] = (chefMenuController)
                } else {
                    let becomeAChefController = UINavigationController(rootViewController: BecomeAChefController())
                    becomeAChefController.tabBarItem.title = "Become A Chef"
                    becomeAChefController.tabBarItem.image = UIImage(named: "chef")
                    self.pageList[1] = (becomeAChefController)
                }
                self.viewControllers = nil
                self.viewControllers = self.pageList
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
}

