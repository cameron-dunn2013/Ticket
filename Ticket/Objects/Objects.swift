//
//  TipClass.swift
//  Ticket
//
//  Created by Cameron Dunn on 5/5/19.
//  Copyright © 2019 Cameron Dunn. All rights reserved.
//

import Foundation

struct Tip : Codable{
    var tipID = UUID()
    var tipAmount : Double
    var longDate = Date()
    var tipDate : String
    var tipTime : String
    
    init(tipAmount : Double, tipDate: String, tipTime: String){
        self.tipAmount = tipAmount
        self.tipDate = tipDate
        self.tipTime = tipTime
    }
}

struct Day : Codable{
    var tips : [Tip] = []
    var clockInTime : Date = Date()
    var clockOutTime : Date?
    var totalTips : Double?
    var hourly : Double?
    var timeWorked : String?
}
