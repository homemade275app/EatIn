//
//  chatlogController.swift
//  eatin
//
//  Created by Ndudi Nkanginieme on 11/1/17.
//  Copyright © 2017 CS275. All rights reserved.
//

import UIKit
import Firebase

class chatlogController: UICollectionViewController{
    
    let inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Message....."
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "New Message"
        collectionView?.backgroundColor = UIColor.white
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "cancel", style: .plain ,target: self, action: #selector(handleCancel))
        setupInputComponoent()
        
    }
    @objc func handleCancel(){
        dismiss(animated: true, completion: nil)
    }
    
    func setupInputComponoent(){
        let containerView = UIView()
        containerView.backgroundColor = UIColor.white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(containerView)
        
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        let sendBotton  = UIButton(type: .system)
        sendBotton.setTitle("send", for: .normal)
        sendBotton.translatesAutoresizingMaskIntoConstraints = false
        //Add Target for send botton
        sendBotton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        containerView.addSubview(sendBotton)
        
        // Here we need x, y, w, h,
        sendBotton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendBotton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendBotton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        sendBotton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        
        
        containerView.addSubview(inputTextField)
        
        // x,y,w,h
        inputTextField.leftAnchor.constraint(equalTo: view.leftAnchor,constant: 8).isActive = true
        inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: sendBotton.leftAnchor).isActive = true
        inputTextField.heightAnchor.constraint(equalTo:containerView.heightAnchor).isActive = true
        
        //create seperating line for message text feild.
        let seperatorLine = UIView()
        seperatorLine.backgroundColor = UIColor.black
        seperatorLine.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(seperatorLine)
        
        //set the dimensions here
        seperatorLine.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        seperatorLine.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        seperatorLine.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        seperatorLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        
    }
    
    // Create Handlesend method for adding a target to send botton
    @objc func handleSend(){
        
        let ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let values = ["text": inputTextField.text!]
        childRef.updateChildValues(values)
        
        
    }
    
}

