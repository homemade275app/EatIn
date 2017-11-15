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
import FirebaseStorage

class AddMenuItemController : UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var imageLayout: NSLayoutConstraint?
    
    var images = [UIImage]()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.pageIndicatorTintColor = .lightGray
        pc.currentPageIndicatorTintColor = UIColor(red: 247/255, green: 154/255, blue: 27/255, alpha: 1)
        pc.numberOfPages = self.images.count
        return pc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.isScrollEnabled = false
        
        view.backgroundColor = UIColor(r: 255, g: 255, b: 255)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleReturn))
        
        self.title = "Add A New Dish"
        
        view.addSubview(nameTextField)
        view.addSubview(descriptionTextField)
        view.addSubview(imageButton)
        view.addSubview(collectionView)
        view.addSubview(submitButton)
        
        addInputs()
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeUp.direction = UISwipeGestureRecognizerDirection.up
        self.view.addGestureRecognizer(swipeUp)
        
        registerCells()
    }
    
    @objc
    func handleReturn() {
        self.dismiss(animated: true, completion: nil)
    }
    
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
            imageLayout?.constant = 200
            collectionView.isHidden = false
            images.append(image)
            pageControl.numberOfPages += 1;
            let indexPath = IndexPath(item: images.index(of: image)!, section: 0)
            collectionView.insertItems(at: [indexPath])
            collectionView.reloadData()
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
        
        collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: descriptionTextField.bottomAnchor, constant: 12).isActive = true
        collectionView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        imageLayout = collectionView.heightAnchor.constraint(equalToConstant: 0)
        imageLayout?.isActive = true
        collectionView.isHidden = true
        
        imageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 12).isActive = true
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
            let newMenuItem = ref.childByAutoId()
            newMenuItem.setValue(["userID" : userID, "name" : name, "description" : desc])
            
            let imgRef = Database.database().reference().child("dishImages")
            
            let storage = Storage.storage().reference().child("images/")
            var count = 1
            let key = newMenuItem.key
            
            for image in images {
                
                let imageRef = storage.child(key + String(count))
                if let data = UIImagePNGRepresentation(image) {
                    imageRef.putData(data).observe(.success) { (snapshot) in
                        if let downloadURL = snapshot.metadata?.downloadURL()?.absoluteString {
                            imgRef.childByAutoId().setValue(["id" : downloadURL, "menuID" : key])
                        }
                    }
                }
                count = count + 1
            }
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc
    func respondToSwipeGesture(gesture: UIGestureRecognizer)
    {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer
        {
            switch swipeGesture.direction
            {
            case UISwipeGestureRecognizerDirection.right:
                if(pageControl.currentPage != 0) {
                    let indexPath = IndexPath(item: pageControl.currentPage - 1, section: 0)
                    collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                    pageControl.currentPage -= 1
                }
            case UISwipeGestureRecognizerDirection.left:
                if pageControl.currentPage != images.count - 1 {
                    let indexPath = IndexPath(item: pageControl.currentPage + 1, section: 0)
                    collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                    pageControl.currentPage += 1
                }
            case UISwipeGestureRecognizerDirection.up:
                if(images.count != 0) {
                    images.remove(at: pageControl.currentPage)
                    collectionView.reloadData()
                    pageControl.numberOfPages -= 1
                    pageControl.currentPage -= 1;
                    if(images.count == 0) {
                        imageLayout?.constant = 0
                        collectionView.isHidden = true
                    }
                }
            default:
                break
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! foodImage

        cell.setImage(newImage: images[(indexPath as NSIndexPath).item])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        //        print(UIDevice.current.orientation.isLandscape)
        
        collectionView.collectionViewLayout.invalidateLayout()
        
        let indexPath = IndexPath(item: pageControl.currentPage, section: 0)
        //scroll to indexPath after the rotation is going
        DispatchQueue.main.async {
            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            self.collectionView.reloadData()
        }
    }
    
    fileprivate func registerCells() {
        collectionView.register(foodImage.self, forCellWithReuseIdentifier: "cellId")
    }
    
}

class foodImage: UICollectionViewCell {
    
    var imageHeight: NSLayoutConstraint?
    
    func setImage(newImage : UIImage) {
        image.image = newImage
    }
    
    var image: UIImageView = {
        let newImage = UIImageView()
        newImage.translatesAutoresizingMaskIntoConstraints = false
        newImage.contentMode = .scaleAspectFill
        newImage.clipsToBounds = true
        return newImage
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(image)
        
        image.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        image.topAnchor.constraint(equalTo: topAnchor).isActive = true
        image.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        imageHeight = image.heightAnchor.constraint(equalToConstant: 200)
        imageHeight?.isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
