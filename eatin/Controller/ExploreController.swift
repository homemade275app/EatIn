//
//  ExploreController.swift
//  eatin
//
//  Created by Blaine Andreoli on 10/12/17.
//  Copyright © 2017 CS275. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FBSDKLoginKit

let cellId = "cellId"

class Post {
    var name: String?
    var profileImageName: String?
    var rating: Int?
    var statusTitle: String?
    var statusText: String?
    var statusImageName: String?
    var price: String?
    var availability: String?
    var emblems: String?
}

class ExploreController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let postGoat = Post()
        postGoat.name = "Goat McGoat"
        postGoat.statusTitle = "The Best Grass"
        postGoat.statusText = "Come get your grass, best grass"
        postGoat.profileImageName = "goat"
        postGoat.rating = 3
        postGoat.statusImageName = "grass"
        postGoat.price = "$$$$"
        postGoat.availability = "MWF"
        postGoat.emblems = "GF"
        
        let postSheep = Post()
        postSheep.name = "Sheep mcSheep"
        postSheep.statusTitle = "The Second Best Grass"
        postSheep.statusText = "BAAAA BAA BAAAA BAA BAAAAABAAA ABAAA BAAAA BAA BAAAA BAA BAAAAABAAA ABAAA BAAAA BAA BAAAA BAA BAAAAABAAA ABAAA BAAAA BAA BAAAA BAA BAAAAABAAA ABAAA BAAAA BAA BAAAA BAA BAAAAABAAA ABAAA BAAAA BAA BAAAA BAA BAAAAABAAA ABAAA BAAAA BAA BAAAA BAA BAAAAABAAA ABAAA BAAAA BAA BAAAA BAA BAAAAABAAA ABAAA"
        postSheep.profileImageName = "sheep"
        postSheep.rating = 4
        postSheep.statusImageName = "grass2"
        postSheep.price = "$"
        postSheep.availability = "Sat"
        postSheep.emblems = "Hot"
        
        posts.append(postGoat)
        posts.append(postSheep)
        
        view.backgroundColor = UIColor(r: 255, g: 255, b: 255)
        
        self.title = "Explore"
        
        collectionView?.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        collectionView?.register(FeedCell.self, forCellWithReuseIdentifier: cellId)
        
        collectionView?.alwaysBounceVertical = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(filterController))
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let feedCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FeedCell
        
        feedCell.post = posts[indexPath.item]
        
        return feedCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let statusText = posts[indexPath.item].statusText {
            
            let rect = NSString(string: statusText).boundingRect(with: CGSize(width: view.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)], context: nil)
            
            let knownHeight: CGFloat = 8 + 44 + 23 + 4 + 4 + 200 + 8 + 24 + 8 + 44
            
            return CGSize(width: view.frame.width, height: rect.height + knownHeight + 24)
        }
        
        return CGSize(width: view.frame.width, height: 500)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    @objc func filterController(){
        let filtercontroller = FilterController(collectionViewLayout: UICollectionViewFlowLayout())
        let navController = UINavigationController(rootViewController: filtercontroller)
        present(navController,animated: true, completion: nil)
    }
}

class FeedCell: UICollectionViewCell {
    
    var post: Post? {
        didSet {
            
            if let name = post?.name {
                
                let attributedText = NSMutableAttributedString(string: name + " ", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
                
                var rating = 0
                
                if let ratingNum = post?.rating {
                    rating = ratingNum
                }
                
                let attachment = NSTextAttachment()
                attachment.image = UIImage(named: "orders")
                attachment.bounds = CGRect(x: 0, y: -2, width: 12, height: 12)
                for _ in 1...rating {
                    attributedText.append(NSAttributedString(attachment: attachment))
                }
                attributedText.append(NSAttributedString(string: "\nOctober 25th * Burlington VT * ", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 12), NSAttributedStringKey.foregroundColor: UIColor.rgb(155, green: 161, blue: 161)]))
                
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineSpacing = 4
                
                attributedText.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedText.string.characters.count))
                
                nameLabel.attributedText = attributedText
            }
            
            if let statusTitle = post?.statusTitle {
                statusTitleView.text = statusTitle
            }
            
            if let statusText = post?.statusText {
                statusTextView.text = statusText
            }
            
            if let profileImagename = post?.profileImageName {
                profileImageView.image = UIImage(named: profileImagename)
            }
            
            if let statusImageName = post?.statusImageName {
                statusImageView.image = UIImage(named: statusImageName)
            }
            
            if let price = post?.price {
                priceLabel.text = price
            }
            
            if let availability = post?.availability {
                availabilityLabel.text = availability
            }
            
            if let emblems = post?.emblems {
                emblemLabel.text = emblems
            }
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        

        return label
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let statusTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.isScrollEnabled = false
        return textView
    }()
    
    let statusTitleView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 20)
        textView.isScrollEnabled = false
        return textView
    }()
    
    let statusImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.rgb(155, green: 161, blue: 171)
        return label
    }()
    
    let availabilityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.rgb(155, green: 161, blue: 171)
        return label
    }()
    
    let emblemLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.rgb(155, green: 161, blue: 171)
        return label
    }()
    
    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(226, green: 228, blue: 232)
        return view
    }()
    
    let connectButton: UIButton = FeedCell.buttonForTitle("Connect", imageName: "inbox")
    let saveButton: UIButton = FeedCell.buttonForTitle("Save", imageName: "orders")
    let shareButton: UIButton = FeedCell.buttonForTitle("Share", imageName: "profile")
    
    static func buttonForTitle(_ title: String, imageName: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: UIControlState())
        button.setTitleColor(UIColor.rgb(143, green: 150, blue: 163), for: UIControlState())
        
        button.setImage(UIImage(named: imageName), for: UIControlState())
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0)
        
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        
        return button
    }
    
    func setupViews() {
        backgroundColor = UIColor.white
        addSubview(nameLabel)
        addSubview(profileImageView)
        addSubview(statusTitleView)
        addSubview(statusTextView)
        addSubview(statusImageView)
        addSubview(priceLabel)
        addSubview(availabilityLabel)
        addSubview(emblemLabel)
        addSubview(dividerLineView)
        
        addSubview(connectButton)
        addSubview(saveButton)
        addSubview(shareButton)
        
        addConstraintsWithFormat("H:|-8-[v0(44)]-8-[v1]|", views: profileImageView, nameLabel)
        
        addConstraintsWithFormat("H:|-4-[v0]-4-|", views: statusTitleView)
        
        addConstraintsWithFormat("H:|-4-[v0]-4-|", views: statusTextView)
        
        addConstraintsWithFormat("H:|[v0]|", views: statusImageView)
        
        addConstraintsWithFormat("H:|-64-[v0(v2)]-8-[v1(v2)]-8-[v2]-8-|", views: priceLabel, availabilityLabel, emblemLabel)
        
        addConstraintsWithFormat("H:|-12-[v0]-12-|", views: dividerLineView)
        
        addConstraintsWithFormat("H:|[v0(v2)][v1(v2)][v2]|", views: connectButton, saveButton, shareButton)
        
        addConstraintsWithFormat("V:|-12-[v0]", views: nameLabel)
        
        addConstraintsWithFormat("V:|-8-[v0(44)][v1][v2]-4-[v3(200)]-36-[v4(0.4)][v5(44)]|", views: profileImageView, statusTitleView, statusTextView, statusImageView, dividerLineView, connectButton)
        
        addConstraintsWithFormat("V:[v0(124)]|", views: priceLabel)
        addConstraintsWithFormat("V:[v0(124)]|", views: availabilityLabel)
        addConstraintsWithFormat("V:[v0(124)]|", views: emblemLabel)
        
        addConstraintsWithFormat("V:[v0(44)]|", views: saveButton)
        addConstraintsWithFormat("V:[v0(44)]|", views: shareButton)
        
    }
    
}

extension UIView {
    
    func addConstraintsWithFormat(_ format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
}

extension UIColor {
    
    static func rgb(_ red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
}
