//
//  ChefMenuController.swift
//  eatin
//
//  Created by Blaine Andreoli on 10/24/17.
//  Copyright © 2017 CS275. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ChefMenuController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var menuList = [String]();
    
    let menuTable : UITableView = {
        let menuTable = UITableView()
        menuTable.backgroundColor = UIColor(r: 255, g: 255, b: 255)
        menuTable.rowHeight = 50
        menuTable.translatesAutoresizingMaskIntoConstraints = false
        menuTable.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        return menuTable
    }()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
        cell.textLabel!.text = "\(menuList[indexPath.row])"
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Your Menu"
        
        view.backgroundColor = UIColor(r: 255, g: 255, b: 255)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleMenuAdd))
        
        view.addSubview(menuTable)
        
        setupMenuTable()
        
        self.menuTable.reloadData()
        
        populateTable()
        
    }
    
    func populateTable() {
        let userID = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().child("dishes")
        ref.observeSingleEvent(of: .value, with: { snapshot in
            print(snapshot.childrenCount) // I got the expected number of items
            for rest in snapshot.children.allObjects as! [DataSnapshot] {
                let value = rest.value as? NSDictionary
                if(userID == value!["userID"] as? String) {
                    let name = value!["name"] as? String
                    let desc = value!["description"] as? String
                    self.menuList.append(name! + " - " + desc!)
                    self.menuTable.beginUpdates()
                    self.menuTable.insertRows(at: [
                        NSIndexPath(row: self.menuList.count-1, section: 0) as IndexPath
                        ], with: .automatic)
                    self.menuTable.endUpdates()
                }
            }
        })
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            menuList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    @objc
    func handleMenuAdd() {
        let addMenuItemController = UINavigationController(rootViewController: AddMenuItemController())
        present(addMenuItemController, animated: true, completion: nil)
    }
    
    func setupMenuTable() {
        menuTable.dataSource = self
        menuTable.delegate = self
        
        menuTable.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 0).isActive = true
        menuTable.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 0).isActive = true
        menuTable.heightAnchor.constraint(equalTo: view.heightAnchor, constant: 0).isActive = true
        menuTable.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
}
