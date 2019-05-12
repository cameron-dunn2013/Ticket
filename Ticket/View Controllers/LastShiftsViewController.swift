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
        day1AmountLabel.text = "$\(numberFormatter.string(from: NSNumber(value: model.sevenShifts[0].totalTips!)) ?? "$0.00")"
        }
        if model.sevenShifts.count > 1{
        day2AmountLabel.text = "$\(numberFormatter.string(from: NSNumber(value: model.sevenShifts[1].totalTips!)) ?? "$0.00")"
        }
        if model.sevenShifts.count > 2{
        day3AmountLabel.text = "$\(numberFormatter.string(from: NSNumber(value: model.sevenShifts[2].totalTips!)) ?? "$0.00")"
        }
        if model.sevenShifts.count > 3{
        day4AmountLabel.text = "$\(numberFormatter.string(from: NSNumber(value: model.sevenShifts[3].totalTips!)) ?? "$0.00")"
        }
        if model.sevenShifts.count > 4{
        day5AmountLabel.text = "$\(numberFormatter.string(from: NSNumber(value: model.sevenShifts[4].totalTips!)) ?? "$0.00")"
        }
        if model.sevenShifts.count > 5{
        day6AmountLabel.text = "$\(numberFormatter.string(from: NSNumber(value: model.sevenShifts[5].totalTips!)) ?? "$0.00")"
        }
        if model.sevenShifts.count > 6{
        day7AmountLabel.text = "$\(numberFormatter.string(from: NSNumber(value: model.sevenShifts[6].totalTips!)) ?? "$0.00")"
        }
        var totalAmountCounter : Double = 0.00
        var totalHours : Double = 0.00
        for index in model.sevenShifts{
            totalAmountCounter += index.totalTips!
            totalHours += index.hoursWorked!
        }
        let averageAmount = totalAmountCounter / 7
        averageAmountLabel.text = "\(averageAmount)"
        totalAmountLabel.text = "$\(numberFormatter.string(from: NSNumber(value: totalAmountCounter)) ?? "$0.00")"
    }

}
