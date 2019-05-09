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
    @discardableResult convenience init(tipID: String, tipAmount: Double, longDate: Date, tipDate: String, tipTime: String, day: Day, context: NSManagedObjectContext = CoreDataStack.shared.containerMainContext){
        self.init(context: context)
        self.tipID = tipID
        self.tipAmount = tipAmount
        self.longDate = longDate
        self.tipDate = tipDate
        self.tipTime = tipTime
        self.day = day
    }
}



extension Day{
    @discardableResult convenience init(tips : [Tip], clockInTime : Date, clockOutTime : Date?, totalTips : Double?, hourly : Double?, timeWorked: String?, context: NSManagedObjectContext = CoreDataStack.shared.containerMainContext){
        self.init(context: context)
        self.clockInTime = clockInTime
        self.clockOutTime = clockOutTime
        self.totalTips = totalTips ?? 0.00
        self.hourly = hourly ?? 0.00
        self.timeWorked = timeWorked
        
    }
}
