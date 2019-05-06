//
//  Model.swift
//  Ticket
//
//  Created by Cameron Dunn on 5/5/19.
//  Copyright © 2019 Cameron Dunn. All rights reserved.
//

import Foundation
import UIKit

let model = Model()

class Model{
    
    let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("day.txt")
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
        currentDay.tips.append(tip)
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
        deleteSave()
        do{
            let jsonDay = try JSONEncoder().encode(currentDay)
            let jsonString = jsonDay.description
            try jsonString.write(to: filePath, atomically: false, encoding: .utf8)
            
        }catch{
            print(error)
        }
    }
    
    func deleteSave(){
        do{
            try FileManager().removeItem(at: filePath)
        }catch{
            print(error)
        }
    }
    
    func clockOut() -> (controller: UIAlertController?, showAnimation: Bool){
        if clockedIn {
            do{
                try FileManager().removeItem(at: filePath)
            }catch{
                print(error)
            }
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
        do{
            guard let data = try Data(base64Encoded: String(contentsOf: filePath)) else {return}
            day = try JSONDecoder().decode(Day.self, from: data)
        }catch{
            print(error)
        }
        guard let tempDay = day else {return}
        currentDay = tempDay
        deleteSave()
    }
    
}
