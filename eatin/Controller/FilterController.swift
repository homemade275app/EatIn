//
//  FilterController.swift
//  eatin
//
//  Created by Alex Ram on 11/10/17.
//  Copyright © 2017 CS275. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FBSDKLoginKit

class FilterController: UICollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Filter"
        collectionView?.backgroundColor = UIColor.white
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain ,target: self, action: #selector(handleCancel))
    }
    
    @objc func handleCancel(){
        dismiss(animated: true, completion: nil)
    }
    
}
