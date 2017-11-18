//
//  HelpController.swift
//  eatin
//
//  Created by Blaine Andreoli on 10/19/17.
//  Copyright © 2017 CS275. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

class HelpController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Get Help"
        
        view.backgroundColor = UIColor(r: 255, g: 255, b: 255)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Return", style: .plain, target: self, action: #selector(handleReturn))
        
        
        self.view.addSubview(helpLabel)
        self.view.addSubview(faqLabel)
        setLabelText()
        addLabels()
        
        
    }
    
    @objc
    func handleReturn() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc
    func setLabelText() {
        
        self.helpLabel.text = "F.A.Q."
        self.faqLabel.text = "1. dsfas fadsfas dfdsfasfa dsfas \n 2. dsfasfads fasdfdsf asfadsfas \n 3. dsfasfad sfasdf dsfasfadsfas  "
        

    
        
        
        
        
    }
    
    
    
    let helpLabel: UILabel = {
        let helpLabel = UILabel()
        helpLabel.translatesAutoresizingMaskIntoConstraints = false
        helpLabel.textAlignment = .center
        helpLabel.textColor = .black
        return helpLabel
    }()
    
    let faqLabel: UILabel = {
        let faqLabel = UILabel()
        faqLabel.translatesAutoresizingMaskIntoConstraints = false
        faqLabel.textAlignment = .center
        faqLabel.textColor = .black
        faqLabel.numberOfLines = 3
        return faqLabel
    }()
    
    
    
    
    func addLabels() {
        helpLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        helpLabel.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 12).isActive = true
        helpLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        helpLabel.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        faqLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        faqLabel.topAnchor.constraint(equalTo: helpLabel.bottomAnchor, constant: 12).isActive = true
        faqLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        faqLabel.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        
    }
    
}

