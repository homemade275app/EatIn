//
//  AddMenuItemController.swift
//  eatin
//
//  Created by Blaine Andreoli on 10/24/17.
//  Copyright © 2017 CS275. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class AddMenuItemController : UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(r: 255, g: 255, b: 255)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleReturn))
        
        self.title = "Add A New Dish"
        
        view.addSubview(nameTextField)
        view.addSubview(descriptionTextField)
        view.addSubview(imageButton)
        view.addSubview(imageView)
        view.addSubview(submitButton)
        
        addInputs()
    }
    
    @objc
    func handleReturn() {
        self.dismiss(animated: true, completion: nil)
    }
    
    let imageView : UIImageView = {
        let homeImage = UIImage()
        return UIImageView(image: homeImage)
    }()
    
    let nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Dish Name"
        tf.backgroundColor = .clear
        tf.layer.cornerRadius = 5
        tf.layer.borderWidth = 2
        tf.layer.borderColor = UIColor.orange.cgColor
        tf.layer.masksToBounds = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let descriptionTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Dish Description"
        tf.backgroundColor = .clear
        tf.layer.cornerRadius = 5
        tf.layer.borderWidth = 2
        tf.layer.borderColor = UIColor.orange.cgColor
        tf.layer.masksToBounds = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let imageButton: UIButton = {
        let imageButton = UIButton()
        imageButton.backgroundColor = .clear
        imageButton.layer.cornerRadius = 5
        imageButton.layer.borderWidth = 2
        imageButton.translatesAutoresizingMaskIntoConstraints = false
        imageButton.layer.borderColor = UIColor.orange.cgColor
        imageButton.setTitle("Upload An Image", for: .normal)
        imageButton.setTitleColor(UIColor.orange, for: .normal)
        imageButton.addTarget(self, action: #selector(imageButtonAction), for: .touchUpInside)
        return imageButton
    }()
    
    let submitButton: UIButton = {
        let submitButton = UIButton()
        submitButton.backgroundColor = .clear
        submitButton.layer.cornerRadius = 5
        submitButton.layer.borderWidth = 2
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.layer.borderColor = UIColor.orange.cgColor
        submitButton.setTitle("Submit", for: .normal)
        submitButton.setTitleColor(UIColor.orange, for: .normal)
        submitButton.addTarget(self, action: #selector(submitAction), for: .touchUpInside)
        return submitButton
    }()
    
    @objc
    func imageButtonAction() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImage: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImage = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImage = originalImage
        }
        
        if let image = selectedImage {
            imageView.image = image
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func addInputs() {
        nameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nameTextField.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 12).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        nameTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        descriptionTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        descriptionTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 12).isActive = true
        descriptionTextField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        descriptionTextField.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
//        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        imageView.topAnchor.constraint(equalTo: descriptionTextField.bottomAnchor, constant: 12).isActive = true
//        imageView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
//        imageView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        imageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageButton.topAnchor.constraint(equalTo: descriptionTextField.bottomAnchor, constant: 12).isActive = true
        imageButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        imageButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        submitButton.topAnchor.constraint(equalTo: imageButton.bottomAnchor, constant: 12).isActive = true
        submitButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        submitButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
    }
    
    @objc
    func submitAction() {
        let name = nameTextField.text
        let desc = descriptionTextField.text
        
        if((name == nil || name == "") || (desc == nil || desc == "")) {
            let alert = UIAlertController(title: "Error", message: "Fields cannot be empty", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Continue", style: .default))
            self.present(alert, animated: true, completion: nil)
        } else {
            let userID = Auth.auth().currentUser?.uid
            let ref = Database.database().reference().child("dishes")
            ref.childByAutoId().setValue(["userID" : userID, "name" : name, "description" : desc])
            self.dismiss(animated: true, completion: nil)
        }
    }
}
