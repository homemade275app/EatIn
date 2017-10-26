//
//  ChefProfileControler.swift
//  eatin
//
//  Created by Blaine Andreoli on 10/23/17.
//  Copyright © 2017 CS275. All rights reserved.
//

import UIKit

class ChefProfileController : UIViewController {
    
    let chefMenuButton: UIButton = {
        let chefMenuButton = UIButton()
        chefMenuButton.backgroundColor = .clear
        chefMenuButton.layer.cornerRadius = 5
        chefMenuButton.layer.borderWidth = 2
        chefMenuButton.translatesAutoresizingMaskIntoConstraints = false
        chefMenuButton.layer.borderColor = UIColor.orange.cgColor
        chefMenuButton.setTitle("View Your Menu", for: .normal)
        chefMenuButton.setTitleColor(UIColor.orange, for: .normal)
        chefMenuButton.addTarget(self, action: #selector(chefMenuAction), for: .touchUpInside)
        return chefMenuButton
    }()
    
    override func viewDidLoad() {
        self.title = "Chef Profile"
        
        view.backgroundColor = UIColor(r: 255, g: 255, b: 255)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Return", style: .plain, target: self, action: #selector(handleReturn))
        
        view.addSubview(chefMenuButton)
        setupChefButtons()
    }
    
    @objc
    func handleReturn() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc
    func chefMenuAction () {
        let chefMenuController = UINavigationController(rootViewController: ChefMenuController())
        present(chefMenuController, animated: true, completion: nil)
    }
    
    func setupChefButtons() {
        chefMenuButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        chefMenuButton.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 12).isActive = true
        chefMenuButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        chefMenuButton.heightAnchor.constraint(equalToConstant: 75).isActive = true
    }
}
