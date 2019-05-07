//
//  TipClass.swift
//  Ticket
//
//  Created by Cameron Dunn on 5/5/19.
//  Copyright © 2019 Cameron Dunn. All rights reserved.
//

import Foundation
import CoreData


extension Tip{
    @discardableResult convenience init(tipID: String, tipAmount: Double, longDate: Date, tipDate: String, tipTime: String, context: NSManagedObjectContext = CoreDataStack.shared.tipMainContext){
        self.init(context: context)
        self.tipID = tipID
        self.tipAmount = tipAmount
        self.longDate = longDate
        self.tipDate = tipDate
        self.tipTime = tipTime
    }
}

//    var tipID = UUID().uuidString
//    var tipAmount : Double = 0.00
//    var longDate : Date = Date()
//    var tipDate : String = ""
//    var tipTime : String = ""

extension Day{
    @discardableResult convenience init(tips : [Tip], clockInTime : Date, clockOutTime : Date?, totalTips : Double?, hourly : Double?, timeWorked: String?, context: NSManagedObjectContext = CoreDataStack.shared.dayMainContext){
        self.init(context: context)
        self.tips = tips
        self.clockInTime = clockInTime
        self.clockOutTime = clockOutTime
        self.totalTips = totalTips ?? 0.00
        self.hourly = hourly ?? 0.00
        self.timeWorked = timeWorked
        
    }
    //    var tips : [Tip] = []
    //    var clockInTime : Date = Date()
    //    var clockOutTime : Date?
    //    var totalTips : Double?
    //    var hourly : Double?
    //    var timeWorked : String?

}
