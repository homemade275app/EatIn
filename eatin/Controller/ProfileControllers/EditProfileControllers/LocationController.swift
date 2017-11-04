//
//  LocationController.swift
//  eatin
//
//  Created by Grant Slattery on 11/4/17.
//  Copyright © 2017 CS275. All rights reserved.
//

import UIKit

class LocationController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Location"
        
        view.backgroundColor = UIColor(r: 255, g: 255, b: 255)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Return", style: .plain, target: self, action: #selector(handleReturn))
    }
    
    @objc
    func handleReturn() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
