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


let model = Model()

class Model{
    
   
    var currentDay : Day = Day()
    var sevenShifts : [Day] = []
    var clockedIn : Bool = false
    var days : [Day] = []
    
    
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
        currentDay.currentlyClockedIn = true
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
            currentDay.currentlyClockedIn = false
            clockedIn = false
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            currentDay.dateSubmitted = dateFormatter.string(from: Date())
            for index in currentDay.tips{
                if(currentDay.totalTips == nil){
                    currentDay.totalTips = index.tipAmount
                }else{
                    currentDay.totalTips! += index.tipAmount!
                }
            }
            days.append(currentDay)
            addToSevenShifts(day: currentDay)
            saveSevenShifts()
            saveDays()
            let newDay = Day()
            newDay.currentlyClockedIn = false
            currentDay = newDay
            saveCurrentDay()
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
    
    func saveDays(){
        guard let url = multipleDaysFileURL else {return}
        do{
            let data = try PropertyListEncoder().encode(days)
            try data.write(to: url)
        }catch{
            print(error)
        }
    }
    
    
    func loadSavedDays(){
        guard let url = multipleDaysFileURL else {return}
        do{
            let data = try Data(contentsOf: url)
            let decoder = PropertyListDecoder()
            days = try decoder.decode([Day].self, from: data)
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
    private var multipleDaysFileURL : URL?{
        let fileManager = FileManager.default
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {return nil}
        let finalLocation = documentsDirectory.appendingPathComponent("daysSave.plist")
        return finalLocation
        }
    private var sevenShiftsFileURL : URL?{
        let fileManager = FileManager.default
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {return nil}
        let finalLocation = documentsDirectory.appendingPathComponent("sevenShifts.plist")
        return finalLocation
    }
}

//Extension for LastDaysViewController.swift
extension Model{
    func addToSevenShifts(day: Day){
        sevenShifts.appendAtBeginning(newItem: day)
        if(sevenShifts.count == 8){
            sevenShifts.remove(at: 7)
        }
    }
    
    
    func saveSevenShifts(){
        guard let url = sevenShiftsFileURL else {return}
        do{
            let data = try PropertyListEncoder().encode(sevenShifts)
            try data.write(to: url)
        }catch{
            print(error)
        }
    }
    
    
    func loadSevenShifts(){
        guard let url = sevenShiftsFileURL else {return}
        do{
            let data = try Data(contentsOf: url)
            let decoder = PropertyListDecoder()
            sevenShifts = try decoder.decode([Day].self, from: data)
        }catch{
            print(error)
        }
    }
}
