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
    
    
    var tips : [Tip] = []
    var currentDay : Day?
    var clockedIn : Bool = false
    
    func createTip(amount : Double){
        let currentDate = Date()
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.month, .day, .year]
        let shortenedDate = formatter.string(for: currentDate)!
        formatter.allowedUnits = [.hour, .minute]
        let time = formatter.string(for: currentDate)!
        let tip = Tip(tipAmount: amount, tipDate: shortenedDate, tipTime: time)
        tips.append(tip)
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
        do{
            let jsonDay = try JSONEncoder().encode(currentDay)
            let jsonString = jsonDay.description
            let data = jsonString.data(using: .ascii)
            if let file = FileHandle(forWritingAtPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!){
                file.write(data!)
                
            }
            
        }catch{
            print(error)
        }
        return (nil, true)
    }
    
    func clockOut() -> (controller: UIAlertController?, showAnimation: Bool){
        if clockedIn {
            currentDay?.clockOutTime = Date()
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.hour, .minute]
            let currentDay1 = currentDay
            let currentDay2 = currentDay
            self.currentDay?.timeWorked = formatter.string(from: currentDay1!.clockInTime, to: currentDay2!.clockOutTime!)
            clockedIn = false
            return (nil, true)
        }else{
            let controller = UIAlertController(title: "Error", message: "You're not currently clocked in.", preferredStyle: .alert)
            controller.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
            return (controller, false)
        }
    }
    
    func loadCurrentDay(){
        guard let day = UserDefaults.standard.object(forKey: "CurrentDay") as? Day else {return}
        clockedIn = true
        currentDay = day
    }
    
    func addTip(tipAmount: Double, tableView: UITableView){
        
    }
    
}
