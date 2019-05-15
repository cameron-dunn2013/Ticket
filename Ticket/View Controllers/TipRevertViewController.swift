//
//  TipRevertViewController.swift
//  Ticket
//
//  Created by Cameron Dunn on 5/5/19.
//  Copyright © 2019 Cameron Dunn. All rights reserved.
//

import UIKit

class TipRevertViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        
        // Do any additional setup after loading the view.
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == .delete){
            model.currentDay.tips.remove(at: indexPath.row)
            model.saveCurrentDay()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
    @IBAction func editButtonTapped(_ sender: Any) {
        tableView.setEditing(true, animated: true)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(stopEditingTable(_:)))
    }
    
    @objc func stopEditingTable(_ sender: Any) {
        tableView.setEditing(false, animated: true)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonTapped(_:)))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.currentDay.tips.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tipsCell") as! TipsTableViewCell
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 2
        
        let tip = model.currentDay.tips[indexPath.row]
        let numberString = formatter.string(from: NSNumber(value: tip.tipAmount))
        cell.amountLabel.text = "$\(numberString!)"
        cell.dateLabel.text = "\(tip.tipTime ?? "")"
        return cell
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
