//
//  FeedbackController.swift
//  eatin
//
//  Created by Grant Slattery on 11/18/17.
//  Copyright © 2017 CS275. All rights reserved.
//

import UIKit

class FeedbackController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Give Feedback"
        
        view.backgroundColor = UIColor(r: 255, g: 255, b: 255)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Return", style: .plain, target: self, action: #selector(handleReturn))
    }
    
    @objc
    func handleReturn() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
