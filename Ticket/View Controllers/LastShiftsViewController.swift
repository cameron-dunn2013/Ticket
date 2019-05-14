//
//  LastDaysViewController.swift
//  Ticket
//
//  Created by Cameron Dunn on 5/9/19.
//  Copyright © 2019 Cameron Dunn. All rights reserved.
//

import UIKit

class LastShiftsViewController: UIViewController {

    @IBOutlet weak var day1AmountLabel: UILabel!
    @IBOutlet weak var day2AmountLabel: UILabel!
    @IBOutlet weak var day3AmountLabel: UILabel!
    @IBOutlet weak var day4AmountLabel: UILabel!
    @IBOutlet weak var day5AmountLabel: UILabel!
    @IBOutlet weak var day6AmountLabel: UILabel!
    @IBOutlet weak var day7AmountLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var averageAmountLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateLabels()
    }
    
    func updateLabels(){
        let numberFormatter = NumberFormatter()
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.minimumIntegerDigits = 1
        if model.sevenShifts.count != 0{
            guard let totalTips = model.sevenShifts[0].totalTips else {return}
        day1AmountLabel.text = "$\(numberFormatter.string(from: NSNumber(value: totalTips)) ?? "$0.00")"
        }
        if model.sevenShifts.count > 1{
            guard let totalTips = model.sevenShifts[1].totalTips else {return}
        day2AmountLabel.text = "$\(numberFormatter.string(from: NSNumber(value: totalTips)) ?? "$0.00")"
        }
        if model.sevenShifts.count > 2{
            guard let totalTips = model.sevenShifts[2].totalTips else {return}
        day3AmountLabel.text = "$\(numberFormatter.string(from: NSNumber(value: totalTips)) ?? "$0.00")"
        }
        if model.sevenShifts.count > 3{
            guard let totalTips = model.sevenShifts[3].totalTips else {return}
        day4AmountLabel.text = "$\(numberFormatter.string(from: NSNumber(value: totalTips)) ?? "$0.00")"
        }
        if model.sevenShifts.count > 4{
            guard let totalTips = model.sevenShifts[4].totalTips else {return}
        day5AmountLabel.text = "$\(numberFormatter.string(from: NSNumber(value: totalTips)) ?? "$0.00")"
        }
        if model.sevenShifts.count > 5{
            guard let totalTips = model.sevenShifts[5].totalTips else {return}
        day6AmountLabel.text = "$\(numberFormatter.string(from: NSNumber(value: totalTips)) ?? "$0.00")"
        }
        if model.sevenShifts.count > 6{
            guard let totalTips = model.sevenShifts[6].totalTips else {return}
            day7AmountLabel.text = "$\(numberFormatter.string(from: NSNumber(value: totalTips)) ?? "$0.00")"
        }
        var totalAmountCounter : Double = 0.00
        var hours = 0
        var minutes = 0
        for index in model.sevenShifts{
            totalAmountCounter += index.totalTips!
            guard let hourInt = index.hourInt, let minuteInt = index.minuteInt else {return}
            hours += hourInt
            minutes += minuteInt
        }
        if(minutes > 60){
            hours += Int(minutes / 60)
            minutes = Int(Double().truncatingRemainder(dividingBy: 60))
        }
        hoursLabel.text = "\(hours)hrs \(minutes)mins"
        var averageAmount : Float = 0.00
        if(hours == 0){
            averageAmount = Float(totalAmountCounter) / Float(Float(minutes) * 0.016)
        }else{
            averageAmount = Float(totalAmountCounter) / Float(hours)
        }
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        formatter.minimumIntegerDigits = 1
        averageAmountLabel.text = "\(formatter.string(from: NSNumber(value: averageAmount)) ?? "0.00")"
        totalAmountLabel.text = "$\(numberFormatter.string(from: NSNumber(value: totalAmountCounter)) ?? "$0.00")"
    }
    

}
