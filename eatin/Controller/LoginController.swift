//
//  LoginController.swift
//  eatin
//
//  Created by Blaine Andreoli on 10/11/17.
//  Copyright © 2017 CS275. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import UserNotifications

class LoginController: UIViewController {
    
    var inputsContainerViewHeightAnchor: NSLayoutConstraint?
    var nameTextFieldHeightAnchor: NSLayoutConstraint?
    var emailTextFieldHeightAnchor: NSLayoutConstraint?
    var passwordTextFieldHeightAnchor: NSLayoutConstraint?
    
    let inputsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    let loginRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 255, g: 255, b: 255)
        button.setTitle("Login", for: UIControlState())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.orange, for: UIControlState())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        button.addTarget(self, action:#selector(handleLoginRegister), for: .touchUpInside)
        
        return button
    }()
    
    let returnButton: UIButton = {
        let returnButton = UIButton()
        returnButton.backgroundColor = UIColor(r: 255, g: 165, b: 0);
        returnButton.setTitle("Return", for: UIControlState())
        returnButton.setTitleColor(UIColor.white, for: UIControlState())
        returnButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        returnButton.translatesAutoresizingMaskIntoConstraints = false
        returnButton.addTarget(self, action:#selector(handleReturn), for: .touchUpInside)
        return returnButton
    }()
    
    @objc
    func handleLoginRegister() {
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            handleLogin()
        } else {
            handleRegister()
        }
    }
    
    @objc
    func handleRegister() {
        let email = emailTextField.text
        let password = passwordTextField.text
        let name = nameTextField.text
        
        if(name == "" || name == nil) {
            let alert = UIAlertController(title: "Error", message: "Must Enter Name", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Continue", style: .default))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        Auth.auth().createUser(withEmail: email!, password: password!) { (user, error) in
            
            if(error != nil) {
                if let errCode = AuthErrorCode(rawValue: error!._code) {
                    switch errCode {
                    case .invalidEmail:
                        let alert = UIAlertController(title: "Error", message: "Invalid Email", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Continue", style: .default))
                        self.present(alert, animated: true, completion: nil)
                    case .emailAlreadyInUse:
                        let alert = UIAlertController(title: "Error", message: "Email already in use", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Continue", style: .default))
                        self.present(alert, animated: true, completion: nil)
                    case .weakPassword:
                        let alert = UIAlertController(title: "Error", message: "Password is too weak", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Continue", style: .default))
                        self.present(alert, animated: true, completion: nil)
                    default:
                        print("Create User Error: \(error!)")
                    }
                }
                return
            }
                
            guard let uid = user?.uid else {
                return
            }
            
            //successfully authenticated user
            let ref = Database.database().reference()
            let usersReference = ref.child("users").child(uid)
            let values = ["name": name, "email": email, "address": "", "city": "", "state": "", "country": "", "zip": "", "phoneNumber": "", "chefStatus": "0", "profileImageUrl": ""]
            
            usersReference.updateChildValues(values as Any as! [AnyHashable : Any], withCompletionBlock: { (err, ref) in
                
                if let err = err {
                    print(err)
                    return
                }
                
                self.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
            })
        }
    }
    
    @objc
    func handleLogin() {
        let email = emailTextField.text
        let password = passwordTextField.text
        
        Auth.auth().signIn(withEmail: email!, password: password!) { (user, error) in
            
            if(error != nil) {
                if let errCode = AuthErrorCode(rawValue: error!._code) {
                    switch errCode {
                    case .invalidEmail:
                        let alert = UIAlertController(title: "Error", message: "Invalid Email or Password", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Continue", style: .default))
                        self.present(alert, animated: true, completion: nil)
                    case .wrongPassword:
                        let alert = UIAlertController(title: "Error", message: "Invalid Email or Password", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Continue", style: .default))
                        self.present(alert, animated: true, completion: nil)
                    default:
                        print("Create User Error: \(error!)")
                    }
                }
                return
            }
            
            self.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    let nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let nameSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let emailSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isSecureTextEntry = true
        return tf
    }()
    
    let facebookSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var loginRegisterSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Login", "Register"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = UIColor.white
        sc.selectedSegmentIndex = 0
        sc.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
        return sc
    }()
    
    @objc
    func handleLoginRegisterChange() {
        if loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex) == "Register" {
            loginRegisterButton.setTitle("Register", for: UIControlState())
        } else {
            loginRegisterButton.setTitle("Login", for: UIControlState())
        }
        // change height of inputContainerView, but how???
        inputsContainerViewHeightAnchor?.constant = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 100 : 150
        
        // change height of nameTextField
        nameTextFieldHeightAnchor?.isActive = false
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1/3)
        nameTextFieldHeightAnchor?.isActive = true
        nameTextField.isHidden = loginRegisterSegmentedControl.selectedSegmentIndex == 0
        
        emailTextFieldHeightAnchor?.isActive = false
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        emailTextFieldHeightAnchor?.isActive = true
        
        passwordTextFieldHeightAnchor?.isActive = false
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        passwordTextFieldHeightAnchor?.isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(r: 255, g: 165, b: 0)
        
        view.addSubview(inputsContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(loginRegisterSegmentedControl)
        view.addSubview(returnButton)
        
        setupInputsContainerView()
        setupLoginRegisterButton()
        setupLoginRegisterSegmentedControl()
        setupReturnButton()
    }
    
    @objc
    func handleReturn() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupLoginRegisterSegmentedControl() {
        //need x, y, width, height constraints
        loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterSegmentedControl.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -12).isActive = true
        loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, multiplier: 1).isActive = true
        loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 36).isActive = true
    }
    
    func setupInputsContainerView() {
        //need x, y, width, height constraints
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputsContainerViewHeightAnchor = inputsContainerView.heightAnchor.constraint(equalToConstant: 100)
        inputsContainerViewHeightAnchor?.isActive = true
        
        inputsContainerView.addSubview(facebookSeparatorView)
        inputsContainerView.addSubview(nameTextField)
        inputsContainerView.addSubview(nameSeparatorView)
        inputsContainerView.addSubview(emailTextField)
        inputsContainerView.addSubview(emailSeparatorView)
        inputsContainerView.addSubview(passwordTextField)
        
        //need x, y, width, height constraints
        nameTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        nameTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        
        nameTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nameTextField.isHidden = true
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 0)
        nameTextFieldHeightAnchor?.isActive = true
        
        //need x, y, width, height constraints
        nameSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        nameSeparatorView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        nameSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        //need x, y, width, height constraints
        emailTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/2)
        emailTextFieldHeightAnchor?.isActive = true
        
        //need x, y, width, height constraints
        emailSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        emailSeparatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        //need x, y, width, height constraints
        passwordTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/2)
        passwordTextFieldHeightAnchor?.isActive = true
    }
    
    func setupLoginRegisterButton() {
        //need x, y, width, height constraints
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 12).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupReturnButton() {
        returnButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 12).isActive = true
        returnButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        returnButton.widthAnchor.constraint(equalToConstant: 75).isActive = true
        returnButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
}

extension UIColor {
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
}
