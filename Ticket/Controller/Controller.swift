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
   
    var currentDay : Day = Day()
    var clockedIn : Bool = false
    
    func encode(with aCoder: NSCoder){
        
    }
    
    
    func createTip(amount : Double, tableView : UITableView){
        let currentDate = Date()
        let tip = Tip(tipAmount: amount, longDate: currentDate)
        currentDay.tips.appendAtBeginning(newItem: tip)
        saveCurrentDay()
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
        let day = Day()
        currentDay = day
        saveCurrentDay()
        return (nil, true)
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
        guard let url = dayFileURL else {return}
        do{
            let data = try Data(contentsOf: url)
            let decoder = PropertyListDecoder()
            currentDay = try decoder.decode(Day.self, from: data)
        }catch{
            print(error)
        }
        clockedIn = currentDay.currentlyClockedIn
    }
    
    
    func saveCurrentDay(){
        guard let url = dayFileURL else {return}
        do{
            let data = try PropertyListEncoder().encode(currentDay)
            try data.write(to: url)
        }catch{
            print(error)
        }
        
    }
    private var dayFileURL : URL?{
        let fileManager = FileManager.default
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {return nil}
        let finalLocation = documentsDirectory.appendingPathComponent("day.plist")
        return finalLocation
    }
}
