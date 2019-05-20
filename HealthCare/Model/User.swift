//
//  User.swift
//  HealthCare
//
//  Created by user154004 on 5/17/19.
//  Copyright © 2019 Pramish Luitel. All rights reserved.
//

import Foundation

class User{
    var uid: String
    var firstName: String
    var lastName: String
    var dateOfBirth: String
    var gender: String
    var address: String
    var phone: String
    var email: String
    
    init(uid:String, firstName: String, lastName:String, dateOfBirth: String, gender: String, address:String, phone:String, email:String) {
        self.uid = uid
        self.firstName = firstName
        self.lastName = lastName
        self.dateOfBirth = dateOfBirth
        self.gender = gender
        self.address = address
        self.phone = phone
        self.email = email
    }
}
