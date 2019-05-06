//
//  HomeViewController.swift
//  Ticket
//
//  Created by Cameron Dunn on 5/5/19.
//  Copyright © 2019 Cameron Dunn. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.tips.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Recent Tips:"
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TipsCell") as! HomeTipsTableViewCell
        cell.amountLabel.text = "$\(model.tips[indexPath.row].tipAmount)"
        cell.dateLabel.text = model.tips[indexPath.row].tipTime
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        model.loadCurrentDay()

        // Do any additional setup after loading the view.
    }
    @IBAction func clockInButton(_ sender: Any) {
        let clockInVar = model.clockIn()
        if clockInVar.animation{
            
        }
    }
    @IBAction func clockOutButton(_ sender: Any) {
    }
    @IBAction func undoButton(_ sender: Any) {
    }
    @IBAction func clearAllButton(_ sender: Any) {
    }
    @IBAction func submitDayButton(_ sender: Any) {
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
