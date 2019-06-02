//
//  History.swift
//  HealthCare
//
//  Created by user154004 on 5/31/19.
//  Copyright © 2019 Pramish Luitel. All rights reserved.
//

import Foundation

class History{
    var userID: String
    var history: String
    var message: String
    var medication: String
    var date: String
    var time: String
    var appointmentID: String
    
    init(userID:String, history:String, message:String, medication:String, date:String, time:String, appointmentID:String) {
        self.userID = userID
        self.history = history
        self.message = message
        self.medication = medication
        self.date = date
        self.time = time
        self.appointmentID = appointmentID
    }
}
