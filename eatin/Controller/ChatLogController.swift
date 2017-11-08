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
        let Field = UITextField()
        Field.placeholder = "Enter Message....."
        Field.translatesAutoresizingMaskIntoConstraints = false
        return Field
    }()
    
    let inputRecipiant: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Recipiant.."
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "New Message"
        collectionView?.backgroundColor = UIColor.white
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain ,target: self, action: #selector(handleCancel))
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
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
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
        
        //Add message recipiant box
        let containerView2 = UIView()
        containerView2.backgroundColor = UIColor.white
        containerView2.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(containerView2)
        
        containerView2.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerView2.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -620) .isActive = true
        containerView2.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView2.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        containerView2.addSubview(inputRecipiant)
        
        // x,y,w,h
        inputRecipiant.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        inputRecipiant.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -620).isActive = true
        inputRecipiant.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        //inputRecipiant.centerYAnchor.constraint(equalTo: containerView2.centerYAnchor).isActive = true
        //inputRecipiant.rightAnchor.constraint(equalTo: containerView2.leftAnchor).isActive = true
        inputRecipiant.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    // Create Handlesend method for adding a target to send botton
    @objc func handleSend(){
        let user = User()
        let userinputRecipiant = inputRecipiant.text
        Database.database().reference().child("users").observe(.childAdded, with: {(DataSnapshot) in
            if let Dictionary = DataSnapshot.value as? [String: AnyObject]{
                //let user = User()
                user.setValuesForKeys(Dictionary)
                DispatchQueue.main.async{
                if (user.name == userinputRecipiant){
                    user.id = DataSnapshot.key
                }else{
                    print("error")
                    }}
            }
        }, withCancel: nil)
        let ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let fromId = Auth.auth().currentUser?.uid
        
        let toId = user.id
        let timestamp = Int(NSDate().timeIntervalSince1970)
        let values = ["text": inputTextField.text!, "toId": toId,"fromID": fromId, "timestamp": timestamp] as [String : Any]
        childRef.updateChildValues(values)
        
        
    }
    
}

