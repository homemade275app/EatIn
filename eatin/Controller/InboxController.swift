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
import FirebaseStorage
import FBSDKLoginKit

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}

class InboxController: UITableViewController {
    let cellid = "cellid"
    var mess = [Message]()
    var messagesDictionary = [String: Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(r: 255, g: 255, b: 255)
        
        self.title = "Inbox"
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellid)
        
        observeUserMessages()

    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func tableView(_ tableView: UITableView, commit editingStyle:
        UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard let uid = Auth.auth().currentUser?.uid else{
            return
        }
        let messages = self.mess[indexPath.row]
        if let chatPartnerId = messages.chatPartnerId(){
            Database.database().reference().child("user-messages").child(uid).child(chatPartnerId).removeValue(completionBlock: { (error, ref) in
                if error != nil {
                    print("Failed to delete message:",error)
                }
                self.mess.remove(at: indexPath.row)
                self.messagesDictionary.removeValue(forKey: messages.chatPartnerId()!)
                self.handleReloadTable()
            })
        }
        
        
    }

    
    var timer: Timer?
    
    func observeUserMessages() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let ref = Database.database().reference().child("user-messages").child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            
            let messageId = snapshot.key
            let messagesReference = Database.database().reference().child("messages").child(messageId)
            
            messagesReference.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    let message = Message(dictionary: dictionary)
                    
                    if let chatPartnerId = message.chatPartnerId() {
                        self.messagesDictionary[chatPartnerId] = message
                        
                        self.mess = Array(self.messagesDictionary.values)
                        self.mess.sort(by: { (message1, message2) -> Bool in
                            
                            return message1.timestamp?.int32Value > message2.timestamp?.int32Value
                        })
                    }
                    
                    self.timer?.invalidate()
                    print("we just canceled our timer")
                    
                    self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
                    print("schedule a table reload in 0.1 sec")
                }
                
            }, withCancel: nil)
            
        }, withCancel: nil)
    }
    
    @objc
    func handleReloadTable() {
        //this will crash because of background thread, so lets call this on dispatch_async main thread
        DispatchQueue.main.async(execute: {
            print("we reloaded the table")
            self.tableView.reloadData()
        })
    }
    
    @objc func handleCancel(){
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mess.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellid)
        
        //let cell = tableView.dequeueReusableCell(withIdentifier: cellid, for: indexPath)
        let message = mess[indexPath.row]
        Database.database().reference().child("users").child(message.chatPartnerId()!).observeSingleEvent(of: .value, with: {(snapshot) in
            let value = snapshot.value as? NSDictionary
            cell.textLabel?.text = value?["name"] as? String
            
            if(value!["profileImageUrl"] as? String != nil && value!["profileImageUrl"] as? String != "") {
                let storageRef = Storage.storage().reference(forURL: value!["profileImageUrl"] as! String)
                storageRef.getData(maxSize: 1 * 2048 * 2048) { (data, error) -> Void in
                    if (error != nil) {
                        print(error ?? "error")
                    } else {
                        cell.imageView?.image = UIImage(data: data!)!
                    }
                }
            } else {
                cell.imageView?.image = UIImage(named: "profile")
            }
        })
        cell.detailTextLabel?.text = message.text
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = mess[indexPath.row]
        
        guard let chatPartnerId = message.chatPartnerId() else {
            return
        }
        
        let ref = Database.database().reference().child("users").child(chatPartnerId)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject] else {
                return
            }
            
            let user = User(dictionary: dictionary)
            user.id = chatPartnerId
            //user.setValuesForKeys(dictionary)
            self.showChatControllerForUser(user)
            
        }, withCancel: nil)
    }
    
    @objc func handleNewMessage(){
        let newMessageController = NewMessageController()
        let navController = UINavigationController(rootViewController: newMessageController)
        present(navController,animated: true, completion: nil)

    }
    
    func showChatControllerForUser(_ user: User) {
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.user = user
        let navController = UINavigationController(rootViewController: chatLogController)
        present(navController, animated: true)
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
