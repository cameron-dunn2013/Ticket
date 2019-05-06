//
//  Model.swift
//  Ticket
//
//  Created by Cameron Dunn on 5/5/19.
//  Copyright © 2019 Cameron Dunn. All rights reserved.
//

import Foundation
import UIKit
import CoreData

let model = Model()

class Model{
    
    let filePath = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]).appendingPathComponent("day.plist")
   
    var currentDay : Day = Day()
    var clockedIn : Bool = false
    
    func createTip(amount : Double, tableView : UITableView){
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        let shortenedDate = formatter.string(for: currentDate)
        formatter.dateFormat = "hh:mm a"
        let time = formatter.string(for: currentDate)
        let tip = Tip(tipAmount: amount, tipDate: shortenedDate!, tipTime: time!)
        currentDay.tips.appendAtBeginning(newItem: tip)
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
        let day = Day()
        currentDay = day
        saveDay()
        return (nil, true)
    }
    
    func saveDay(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "DayEntity", in: context)
        let newDay = NSManagedObject(entity: entity!, insertInto: context)
        newDay.setValuesForKeys(["clockInTime": currentDay.clockInTime,
                                 "tips":currentDay.tips,
                                 "totalTips":currentDay.totalTips ?? 0.00
            ])
        do{
            try context.save()
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
            self.currentDay.timeWorked = formatter.string(from: currentDay1.clockInTime, to: currentDay2.clockOutTime!)
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
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "DayEntity")
        do{
            day = try context.fetch(request).first as? Day
        }catch{
            print(error)
            return
        }
        guard let newDay = day else {return}
        currentDay = newDay
    }
}
