//
//  model.swift
//  Ticket
//
//  Created by Cameron Dunn on 5/5/19.
//  Copyright © 2019 Cameron Dunn. All rights reserved.
//

import Foundation
import UIKit
import CoreData


let model = Controller()

class Controller{
    
    let filePath = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]).appendingPathComponent("day.plist")
   
    var currentDay : Day = Day(tips: [], clockInTime: Date(), clockOutTime: nil, totalTips: nil, hourly: nil, timeWorked: nil)
    var clockedIn : Bool = false
    
    func encode(with aCoder: NSCoder){
        
    }
    
    
    func createTip(amount : Double, tableView : UITableView){
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        let shortenedDate = formatter.string(for: currentDate)
        formatter.dateFormat = "hh:mm a"
        let time = formatter.string(for: currentDate)
        let tip = Tip(tipID: UUID().uuidString, tipAmount: amount, longDate: Date(), tipDate: shortenedDate!, tipTime: time!)
        currentDay.tips?.appendAtBeginning(newItem: tip)
        saveDay()
        tableView.reloadData()
    }
    
    func clockIn() -> (controller: UIAlertController?, animation: Bool){
        if clockedIn {
            let controller = UIAlertController(title: "Error", message: "You're already clocked in.", preferredStyle: .alert)
            controller.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
            return (controller, false)
        }
        clockedIn = true
        print("Clocked in")
        let day = Day(tips: [], clockInTime: Date(), clockOutTime: nil, totalTips: nil, hourly: nil, timeWorked: nil)
        currentDay = day
        saveDay()
        return (nil, true)
    }
    
    func saveDay(){
        let context = CoreDataStack.shared.dayMainContext
        let entity = NSEntityDescription.entity(forEntityName: "Day", in: context)
        let newDay = NSManagedObject(entity: entity!, insertInto: context)
        newDay.setValuesForKeys(["clockInTime": currentDay.clockInTime!,
                                 "tips":currentDay.tips ?? [],
                                 "totalTips":currentDay.totalTips
            ])
        do{
            try context.save()
            print("saved")
        }catch{
            print(error)
        }
        
    }
    
    func clockOut() -> (controller: UIAlertController?, showAnimation: Bool){
        if clockedIn {
            currentDay.clockOutTime = Date()
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.hour, .minute]
            let currentDay1 = currentDay
            let currentDay2 = currentDay
            self.currentDay.timeWorked = formatter.string(from: currentDay1.clockInTime!, to: currentDay2.clockOutTime!)
            clockedIn = false
            return (nil, true)
        }else{
            let controller = UIAlertController(title: "Error", message: "You're not currently clocked in.", preferredStyle: .alert)
            controller.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
            return (controller, false)
        }
    }
    
    func loadCurrentDay(){
        var day : Day?
        let context = CoreDataStack.shared.dayMainContext
        let request : NSFetchRequest<Day> = Day.fetchRequest()
        do{
            day = try context.fetch(request).first!
        }catch{
            print(error)
            return
        }
        currentDay = day!
    }
}
