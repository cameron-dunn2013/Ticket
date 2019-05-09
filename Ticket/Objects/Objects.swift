//
//  TipClass.swift
//  Ticket
//
//  Created by Cameron Dunn on 5/5/19.
//  Copyright © 2019 Cameron Dunn. All rights reserved.
//

import Foundation
import CoreData


class Tip: Codable{
    var tipID : UUID = UUID()
    var tipAmount: Double!
    var longDate : Date = Date()
    var tipTime : String!
    var tipDate : String!
    init(tipAmount: Double, longDate: Date = Date()){
        self.tipAmount = tipAmount
        self.longDate = longDate
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mma"
        self.tipTime = formatter.string(from: longDate)
        formatter.dateFormat = "MM/dd/yyyy"
    }
}



class Day: Codable{
    var clockInTime : Date = Date()
    var clockOutTime : Date?
    var tips : [Tip] = []
    var totalTips : Double?
    var hourly : Double?
    var timeWorked : String?
    var currentlyClockedIn : Bool = false
    init(){
        currentlyClockedIn = false
    }
}
