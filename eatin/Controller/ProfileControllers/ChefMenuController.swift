//
//  ChefMenuController.swift
//  eatin
//
//  Created by Blaine Andreoli on 10/24/17.
//  Copyright © 2017 CS275. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ChefMenuController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var menuList = [info]()
    
    var images = [UIImage]()
    
    let selectedCellHeight: CGFloat = 88.0
    let unselectedCellHeight: CGFloat = 44.0
    
    let menuTable : UITableView = {
        let menuTable = UITableView()
        menuTable.backgroundColor = UIColor(r: 255, g: 255, b: 255)
        menuTable.rowHeight = 50
        menuTable.translatesAutoresizingMaskIntoConstraints = false
        menuTable.register(menuItem.self, forCellReuseIdentifier: "cell")
        return menuTable
    }()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! menuItem
        cell.name.text = menuList[(indexPath as NSIndexPath).item].name
        cell.desc.text = menuList[(indexPath as NSIndexPath).item].desc
        cell.populateImages(key: menuList[(indexPath as NSIndexPath).item].itemID)
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Your Menu"
        
        view.backgroundColor = UIColor(r: 255, g: 255, b: 255)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleMenuAdd))
        
        view.addSubview(menuTable)
        
        setupMenuTable()
        
        self.menuTable.reloadData()
        
        populateTable()
        
        menuTable.rowHeight = UITableViewAutomaticDimension
    }
    
    func populateTable() {
        let userID = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().child("dishes")
        ref.observeSingleEvent(of: .value, with: { snapshot in
            for rest in snapshot.children.allObjects as! [DataSnapshot] {
                let value = rest.value as? NSDictionary
                if(userID == value!["userID"] as? String) {
                    let name = value!["name"] as? String
                    let desc = value!["description"] as? String
                    let list = info(name : name!, desc : desc!, itemID : rest.key)
                    self.menuList.append(list)
                    self.menuTable.beginUpdates()
                    self.menuTable.insertRows(at: [
                        NSIndexPath(row: self.menuList.count-1, section: 0) as IndexPath
                        ], with: .automatic)
                    self.menuTable.endUpdates()
                }
            }
        })
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            menuList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    @objc
    func handleMenuAdd() {
        let addMenuItemController = UINavigationController(rootViewController: AddMenuItemController())
        present(addMenuItemController, animated: true, completion: nil)
    }
    
    func setupMenuTable() {
        menuTable.dataSource = self
        menuTable.delegate = self
        
        menuTable.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 0).isActive = true
        menuTable.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 0).isActive = true
        menuTable.heightAnchor.constraint(equalTo: view.heightAnchor, constant: 0).isActive = true
        menuTable.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
}

struct info {
    let name : String
    let desc : String
    let itemID : String
}

class menuItem : UITableViewCell, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! food
        
        cell.setImage(newImage: imageList[(indexPath as NSIndexPath).item])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: 200)
    }
    
    
    fileprivate func registerCells() {
        images.register(food.self, forCellWithReuseIdentifier: "cellId")
    }
    
    var name : UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    var desc  : UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    var imageList = [UIImage]()
    
    var images : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.pageIndicatorTintColor = .lightGray
        pc.currentPageIndicatorTintColor = UIColor(red: 247/255, green: 154/255, blue: 27/255, alpha: 1)
        pc.numberOfPages = imageList.count
        return pc
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        addGestureRecognizer(swipeLeft)
        
        registerCells()
        
        addSubview(name)
        addSubview(desc)
        addSubview(images)
        
        images.isScrollEnabled = false
        
        images.delegate = self
        images.dataSource = self
        
        name.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        name.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
        name.widthAnchor.constraint(equalTo: widthAnchor, constant: -24).isActive = true
        name.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        desc.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        desc.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 12).isActive = true
        desc.widthAnchor.constraint(equalTo: widthAnchor, constant: -24).isActive = true
        desc.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        images.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        images.topAnchor.constraint(equalTo: desc.bottomAnchor, constant: 12).isActive = true
        images.widthAnchor.constraint(equalTo: widthAnchor, constant: -24).isActive = true
        images.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
                    images.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                    pageControl.currentPage -= 1
                }
            case UISwipeGestureRecognizerDirection.left:
                if pageControl.currentPage != imageList.count - 1 {
                    let indexPath = IndexPath(item: pageControl.currentPage + 1, section: 0)
                    images.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                    pageControl.currentPage += 1
                }
            default:
                break
            }
        }
    }
    
    func populateImages(key : String) {
        //var count = 1
        let ref = Database.database().reference().child("dishImages")
        ref.observeSingleEvent(of: .value, with: { snapshot in
            for rest in snapshot.children.allObjects as! [DataSnapshot] {
                let value = rest.value as? NSDictionary
                let id = value?["menuID"] as? String
                if(id == key) {
                    let storageRef = Storage.storage().reference(forURL: value?["id"] as! String)
                    storageRef.getData(maxSize: 1 * 2048 * 2048) { (data, error) -> Void in
                        if (error != nil) {
                            print(error ?? "error")
                        } else {
                            let currentImage = UIImage(data: data!)!
                            print("Image")
                            self.imageList.append(currentImage)
                            self.pageControl.numberOfPages += 1
                            let indexPath = IndexPath(item: self.imageList.index(of: currentImage)!, section: 0)
                            self.images.insertItems(at: [indexPath])
                            
                        }
                    }
                }
            }
            self.images.reloadData()
        })
    }
}

class food: UICollectionViewCell {
    
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
