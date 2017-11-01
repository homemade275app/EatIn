//
//  InboxController.swift
//  eatin
//
//  Created by Blaine Andreoli on 10/12/17.
//  Copyright © 2017 CS275. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FBSDKLoginKit

class InboxController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(r: 255, g: 255, b: 255)
        
        //self.title = "nn"
        //let image = UIImage(named:"icon")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(handlechatLogController))
        //navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleNewMessage))
        
//        let uid = Auth.auth().currentUser?.uid
//        Database.database().reference().child("users").child(uid!).observeSingleEvent(of:.value, with:{ (snapshot) in
//            if let Dictionary = snapshot.value as? [String: AnyObject]{
//                self.title = Dictionary["name"] as? String
//            }}
//            , withCancel: nil)
        
        self.title = "Inbox"
    }
    @objc func handlechatLogController(){
        let chatcogcontroller = chatlogController(collectionViewLayout: UICollectionViewFlowLayout())
        let navController = UINavigationController(rootViewController: chatcogcontroller)
        present(navController,animated: true, completion: nil)
    }
    @objc func handleNewMessage(){
        let newMessageController = NewMessageController()
        let navController = UINavigationController(rootViewController: newMessageController)
        present(navController,animated: true, completion: nil)

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
