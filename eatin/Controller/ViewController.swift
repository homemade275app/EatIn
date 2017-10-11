//
//  ViewController.swift
//  eatin
//
//  Created by Blaine Andreoli on 10/11/17.
//  Copyright © 2017 CS275. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
    }
    
    @objc
    func handleLogout() {
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
    }
}

