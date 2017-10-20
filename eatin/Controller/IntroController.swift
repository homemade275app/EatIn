//
//  IntroController.swift
//  eatin
//
//  Created by Blaine Andreoli on 10/19/17.
//  Copyright © 2017 CS275. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase

class IntroController: UIViewController, FBSDKLoginButtonDelegate {
    
    var facebookHeightAnchor: NSLayoutConstraint?
    var loginCreateButtonAnchor: NSLayoutConstraint?
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if(error != nil) {
            print("Error")
            return
        }
        
        let accessToken = FBSDKAccessToken.current()
        guard let tokenString = accessToken?.tokenString else {return}
        
        let credentials = FacebookAuthProvider.credential(withAccessToken: tokenString)
        
        Auth.auth().signIn(with: credentials, completion: { (user,
            error) in
            if error != nil {
                print("FB User error: ", error ?? "")
                return
            }
            print("Successfully logged in with user ", user ?? "")
            
            guard let uid = user?.uid else {
                return
            }
            
            //successfully authenticated user
            let ref = Database.database().reference()
            let usersReference = ref.child("users").child(uid)
            
            let values = ["name": user?.displayName, "email": user?.email, "address": "", "city": "", "state": "", "country": "", "zip": "", "phoneNumber": "", "chefStatus": "0"]
            
            usersReference.updateChildValues(values as Any as! [AnyHashable : Any], withCompletionBlock: { (err, ref) in
                
                if let err = err {
                    print(err)
                    return
                }
            
                self.dismiss(animated: true, completion: nil)
            })
        })
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Facebook Logout")
    }
    
    let facebookButton : FBSDKLoginButton = {
        let facebookButton = FBSDKLoginButton()
        facebookButton.translatesAutoresizingMaskIntoConstraints = false
        for const in facebookButton.constraints{
            if const.firstAttribute == NSLayoutAttribute.height && const.constant == 28{
                facebookButton.removeConstraint(const)
            }
        }
        facebookButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return facebookButton
    }()
    
    let loginCreateButton : UIButton = {
        let loginCreateButton = UIButton()
        loginCreateButton.translatesAutoresizingMaskIntoConstraints = false
        loginCreateButton.setTitle("Login / Create Account", for: UIControlState())
        loginCreateButton.setTitleColor(UIColor.orange, for: UIControlState())
        loginCreateButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        loginCreateButton.backgroundColor = UIColor(r: 255, g: 255, b: 255)
        loginCreateButton.addTarget(self, action:#selector(handleEnterLogin), for: .touchUpInside)
        return loginCreateButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(r: 255, g: 165, b: 0)
        
        view.addSubview(facebookButton)
        view.addSubview(loginCreateButton)
        
        setupFacebookLogin()
        setupLoginButton()
    }
    
    func setupFacebookLogin() {
        facebookButton.delegate = self
        facebookButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        facebookButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        facebookButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        facebookButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupLoginButton() {
        loginCreateButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginCreateButton.topAnchor.constraint(equalTo: facebookButton.bottomAnchor, constant:12).isActive = true
        loginCreateButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        loginCreateButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    @objc
    func handleEnterLogin() {
        let loginController = LoginController()
        
        present(loginController, animated: true, completion: nil)
    }
}
