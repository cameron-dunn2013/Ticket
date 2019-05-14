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
let homeVC = HomeViewController()

class Model{
    
    var currentDay : Day = Day()
    var sevenShifts : [Day] = []
    var clockedIn : Bool = false
    var days : [Day] = []
    var handledDuplicate = false
    
    
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
    
    
    
    func clockOut() -> (showAnimation: Bool, dayExists: Bool){
        if (clockedIn == true){
            currentDay.clockOutTime = Date()
            let interval = currentDay.clockOutTime?.timeIntervalSince(currentDay.clockInTime)
            let timeFormatter = NumberFormatter()
            timeFormatter.maximumFractionDigits = 0
            currentDay.hourInt = Int(interval! / 3600)
            currentDay.minuteInt = Int(interval!.truncatingRemainder(dividingBy: 3600) / 60)
            currentDay.hoursWorked = interval! / 3600
            if(currentDay.hourInt! == 0 || currentDay.hourInt! < 1){
                currentDay.timeWorked = "\(timeFormatter.string(from: NSNumber(value: (currentDay.minuteInt!)))!)mins"
            }else if currentDay.hourInt == 1{
                currentDay.timeWorked = "\(timeFormatter.string(from: NSNumber(value: (currentDay.hourInt!)))!)hr \(timeFormatter.string(from: NSNumber(value: (currentDay.minuteInt!)))!)mins"
            }else{
                currentDay.timeWorked = "\(timeFormatter.string(from: NSNumber(value: (currentDay.hourInt!)))!)hrs \(timeFormatter.string(from: NSNumber(value: (currentDay.minuteInt!)))!)mins"
            }
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
            for index in days{
                if(index.dateSubmitted == currentDay.dateSubmitted && handledDuplicate == false){
                    return(false, true)
                }
            }
            currentDay.currentlyClockedIn = false
            clockedIn = false
            days.append(currentDay)
            addToSevenShifts(day: currentDay)
            saveSevenShifts()
            saveDays()
            let newDay = Day()
            newDay.currentlyClockedIn = false
            currentDay = newDay
            saveCurrentDay()
            handledDuplicate = false
            return (true, false)
            
        }else{
            let controller = UIAlertController(title: "Error", message: "You're not currently clocked in.", preferredStyle: .alert)
            controller.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
            return (false, false)
        }
    }
    
    func addToCurrentDay(){
        var counter = 0
        for index in days{
            if(index.dateSubmitted == currentDay.dateSubmitted){
                if(days[counter].totalTips != nil){
                    guard let totalTips = currentDay.totalTips else {return}
                    days[counter].totalTips! += totalTips
                }
                if(days[counter].hoursWorked != nil){
                    guard let hoursWorked = days[counter].hoursWorked else {return}
                    days[counter].hoursWorked! += hoursWorked
                    let timeFormatter = NumberFormatter()
                    timeFormatter.maximumFractionDigits = 0
                    let hour = days[counter].hoursWorked! / 3600
                    let minute = days[counter].hoursWorked!.truncatingRemainder(dividingBy: 3600) / 60
                    if(hour == 0 || hour < 1){
                        days[counter].timeWorked = "\(timeFormatter.string(from: NSNumber(value: (minute)))!)mins"
                    }else if hour == 1{
                        days[counter].timeWorked = "\(timeFormatter.string(from: NSNumber(value: (hour)))!)hr \(timeFormatter.string(from: NSNumber(value: (minute)))!)mins"
                    }else{
                        days[counter].timeWorked = "\(timeFormatter.string(from: NSNumber(value: (hour)))!)hrs \(timeFormatter.string(from: NSNumber(value: (minute)))!)mins"
                    }
                }
                days[counter].tips.append(contentsOf: currentDay.tips)
                clockedIn = false
                currentDay.currentlyClockedIn = false
                saveSevenShifts()
                saveDays()
                let newDay = Day()
                newDay.currentlyClockedIn = false
                currentDay = newDay
                saveCurrentDay()
            }
            counter += 1
        }
    }
    
    func overridePreviousShift(){
        var counter = 0
        for index in days{
            if(index.dateSubmitted == currentDay.dateSubmitted){
                days[counter] = currentDay
                if(sevenShifts.count != 0){
                    sevenShifts[0] = currentDay
                    clockedIn = false
                    currentDay.currentlyClockedIn = false
                    saveSevenShifts()
                    saveDays()
                    let newDay = Day()
                    newDay.currentlyClockedIn = false
                    currentDay = newDay
                    saveCurrentDay()
                }
                counter += 1
            }
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
