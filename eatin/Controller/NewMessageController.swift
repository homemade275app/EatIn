//
//  NewMessageController.swift
//  eatin
//
//  Created by Ndudi Nkanginieme on 10/31/17.
//  Copyright © 2017 CS275. All rights reserved.
import UIKit
import Firebase
import FirebaseAuth
import FBSDKLoginKit

class NewMessageController: UITableViewController {
    
    let cellid = "cellid"
    
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(r: 255, g: 255, b: 255)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "cancel", style: .plain ,target: self, action: #selector(handleCancel))
        fetchUser()
    }
    func fetchUser(){
        
        Database.database().reference().child("users").observeSingleEvent(of: .value, with: {(snapshot) in
            
            for rest in snapshot.children.allObjects as! [DataSnapshot] {
                let value = rest.value as? NSDictionary
                let user = User(dictionary: value as! [String : Any])
                user.id = rest.key
                self.users.append(user)
                
                self.tableView.reloadData()
                
            }
        }, withCancel: nil)
    }
    @objc func handleCancel(){
        dismiss(animated: true, completion: nil)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellid)
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        return cell
    }
    
}
