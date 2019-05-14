//
//  BreakdownViewController.swift
//  Ticket
//
//  Created by Cameron Dunn on 5/10/19.
//  Copyright © 2019 Cameron Dunn. All rights reserved.
//

import UIKit
import JTAppleCalendar
class BreakdownViewController: UIViewController {
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var hourlyLabel: UILabel!
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var tableView: UITableView!
    
    var selectedDay : Day?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        monthLabel.text = formatter.string(from: Date())
        calendarView.scrollToDate(Date())
        calendarView.selectDates([Date()])
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        calendarView.reloadData()
        updateLabels()
    }
    
    

}

//Extension for Calendar data source
extension BreakdownViewController: JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        
        let startDate = formatter.date(from: "2018 01 01")!
        let endDate = formatter.date(from: "2030 01 01")!
        return ConfigurationParameters(startDate: startDate, endDate: endDate)
    }
}


//Extension for calendar Delegate
extension BreakdownViewController: JTAppleCalendarViewDelegate {
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "dateCell", for: indexPath) as! DateCell
        self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        return cell
    }
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
       configureCell(view: cell, cellState: cellState)
    }
}


//functions to handle populating the calendar and selecting dates on the calendar.
extension BreakdownViewController{
    //handle taps on dates
    func handleCellSelected(cell: DateCell, cellState: CellState) {
        if cellState.isSelected {
            cell.selectedView.isHidden = false
        } else {
            cell.selectedView.isHidden = true
        }
    }
    
    func handleDataCells(cell: DateCell, cellState: CellState){
        let formatter = DateFormatter()
        formatter.dateFormat = "MM dd yyyy"
        for index in model.days{
            if(index.dateSubmitted == formatter.string(from: cellState.date)){
                cell.dateHeldView.isHidden = false
            }
        }
    }
    
    
    func calendar(_ calendar: JTAppleCalendarView, willScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        monthLabel.text = formatter.string(from: visibleDates.monthDates[0].date)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        for index in model.days{
            if(formatter.string(from: date) == index.dateSubmitted){
                self.selectedDay = index
            }else{
                self.selectedDay = nil
            }
        }
        updateLabels()
        configureCell(view: cell, cellState: cellState)
    }
    
    func updateLabels(){
        for index in model.days{
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yyyy"
            if(selectedDay?.dateSubmitted == index.dateSubmitted){
                hoursLabel.isHidden = false
                hourlyLabel.isHidden = false
                totalLabel.isHidden = false
                hoursLabel.text = index.timeWorked
                let numberFormatter = NumberFormatter()
                numberFormatter.minimumIntegerDigits = 1
                numberFormatter.minimumFractionDigits = 2
                let formattedNumber = numberFormatter.string(from: NSNumber(value: index.totalTips ?? 0.00))
                totalLabel.text = "$\(formattedNumber ?? "0.00")"
                guard let totalTips = index.totalTips,
                    let hoursWorked = index.hoursWorked else {return}
                let average = totalTips / hoursWorked
                hourlyLabel.text = "\(numberFormatter.string(from: NSNumber(value: average)) ?? "0.00")"
                tableView.reloadData()
            }else{
                hoursLabel.isHidden = true
                hourlyLabel.isHidden = true
                totalLabel.isHidden = true
                tableView.reloadData()
            }
        }
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        configureCell(view: cell, cellState: cellState)
        updateLabels()
    }
    
    
    //handle the design of the cell
    func configureCell(view: JTAppleCell?, cellState: CellState) {
        guard let cell = view as? DateCell  else { return }
        cell.dateLabel.text = cellState.text
        handleCellTextColor(cell: cell, cellState: cellState)
        handleCellSelected(cell: cell, cellState: cellState)
        handleDataCells(cell: cell, cellState: cellState)
    }
    
    func handleCellTextColor(cell: DateCell, cellState: CellState) {
        if cellState.dateBelongsTo == .thisMonth {
            cell.dateLabel.isHidden = false
            cell.dateLabel.textColor = UIColor.white
        } else {
            cell.dateLabel.textColor = UIColor.gray
        }
    }
}


//extension for TableView
extension BreakdownViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        guard let safeDate = selectedDay else {return 0}
        for index in model.days{
            if(index.dateSubmitted == safeDate.dateSubmitted){
                return safeDate.tips.count
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BreakdownCell") as! BreakdownTableViewCell
        let formatter = NumberFormatter()
        formatter.minimumIntegerDigits = 1
        formatter.minimumFractionDigits = 2
        let formattedTips = formatter.string(from: NSNumber(value: (selectedDay?.tips[indexPath.row].tipAmount) ?? 0.00))
        cell.amountLabel.text = "$\(formattedTips ?? "0.00")"
        cell.dateLabel.text = selectedDay?.tips[indexPath.row].tipTime
        return cell
    }
    
    
}
