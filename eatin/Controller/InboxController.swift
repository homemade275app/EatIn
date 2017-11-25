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

class InboxController: UITableViewController {
    let cellid = "cellid"
    var mess = [Message]()
    
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
        observeMessage()
        
    }
    func observeMessage(){
        
        
        
        Database.database().reference().child("messages").observeSingleEvent(of: .value, with: {(snapshot) in
            
            for rest in snapshot.children.allObjects as! [DataSnapshot] {
                let message = Message()
                let value = rest.value as? NSDictionary
                message.text = value?["text"] as? String
                message.toId = value?["toId"] as? String
                self.mess.append(message)
                
                self.tableView.reloadData()
                
            }
        }, withCancel: nil)
    }
    @objc func handleCancel(){
        dismiss(animated: true, completion: nil)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mess.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellid)
        let message = mess[indexPath.row]
        if let toId = message.toId{
            let ref = Database.database().reference().child("users").child(toId)
            ref.observeSingleEvent(of: .value, with: {(snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject]{
                    cell.textLabel?.text = dictionary["name"] as? String
                }
                
            }, withCancel: nil)
        }
        //cell.textLabel?.text = message.toId
        cell.detailTextLabel?.text = message.text
        return cell
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
