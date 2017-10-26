//
//  BecomeAChefController.swift
//  eatin
//
//  Created by Blaine Andreoli on 10/19/17.
//  Copyright © 2017 CS275. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class BecomeAChefController: UIViewController {
    
    let chefButton : UIButton = {
        let chefButton = UIButton()
        chefButton.backgroundColor = .clear
        chefButton.layer.cornerRadius = 5
        chefButton.layer.borderWidth = 2
        chefButton.translatesAutoresizingMaskIntoConstraints = false
        chefButton.layer.borderColor = UIColor.orange.cgColor
        chefButton.setTitle("Become A Chef", for: .normal)
        chefButton.setTitleColor(UIColor.orange, for: .normal)
        chefButton.addTarget(self, action: #selector(chefButtonAction), for: .touchUpInside)
        return chefButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Become A Chef"
        
        view.backgroundColor = UIColor(r: 255, g: 255, b: 255)
        
        view.addSubview(chefButton)
        setupChefButton()
    }
    
    @objc
    func chefButtonAction() {
        let ref = Database.database().reference()
        
        let userID = Auth.auth().currentUser?.uid
        
        let usersReference = ref.child("users").child(userID!)
        
        usersReference.updateChildValues(["chefStatus" : "1"] as Any as! [AnyHashable : Any], withCompletionBlock: { (err, ref) in
            
            if let err = err {
                print(err)
                return
            }
            let viewController = ViewController()
            
            self.dismiss(animated: true, completion: nil)
            
            self.present(viewController, animated: true, completion: nil)
        })
    }
    
    func setupChefButton() {
        chefButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        chefButton.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 12).isActive = true
        chefButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        chefButton.heightAnchor.constraint(equalToConstant: 75).isActive = true
    }
}
