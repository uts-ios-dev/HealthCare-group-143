//
//  Appointment.swift
//  HealthCare
//
//  Created by user154004 on 5/31/19.
//  Copyright © 2019 Pramish Luitel. All rights reserved.
//

import Foundation


class Appointments{
    let Uid : String!
    let Id : String!
    let Time : String!
    let DoctorName: String!
    
    init(Uid:String, Id: String, Time:String, DoctorName:String) {
        self.Uid = Uid
        self.Id = Id
        self.Time = Time
        self.DoctorName = DoctorName
    }
}
