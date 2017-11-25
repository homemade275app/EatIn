//
//  user.swift
//  eatin
//
//  Created by Ndudi Nkanginieme on 11/1/17.
//  Copyright © 2017 CS275. All rights reserved.
//

import UIKit
class User: NSObject {
    var id: String?
    var name: String?
    var email: String?
    var address: String?
    var chefStatus: String?
    var city: String?
    var country: String?
    var state: String?
    var zip: String?
    var phoneNumber: String?
    var profileImageUrl: String?
    
    init(dictionary: [String: Any]) {
        self.name = dictionary["name"] as? String
        self.email = dictionary["email"] as? String
        self.address = dictionary["address"] as? String
        self.chefStatus = dictionary["chefStatus"] as? String
        self.city = dictionary["city"] as? String
        self.country = dictionary["country"] as? String
        self.state = dictionary["state"] as? String
        self.zip = dictionary["zip"] as? String
        self.phoneNumber = dictionary["phoneNumber"] as? String
        self.profileImageUrl = dictionary["profileImageUrl"] as? String
    }
}
