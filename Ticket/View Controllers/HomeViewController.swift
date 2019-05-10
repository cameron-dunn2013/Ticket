//
//  HomeViewController.swift
//  Ticket
//
//  Created by Cameron Dunn on 5/5/19.
//  Copyright © 2019 Cameron Dunn. All rights reserved.
//

import UIKit
import SwiftyGif

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var clockedLabel: UILabel!
    @IBOutlet weak var animationImage: UIImageView!
    @IBOutlet weak var tipTextField: UITextField!
    @IBOutlet weak var closeKeyboardButton: UIButton!
    @IBOutlet weak var submitTipButton: UIButton!
    @IBOutlet weak var scrollViewMain: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lastTipAmountLabel: UILabel!
    @IBOutlet weak var totalTipAmountLabel: UILabel!
    @IBOutlet weak var animationBackground: UIView!
    
    var tipEntered : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model.loadCurrentDay()
        tipTextField.delegate = self
        tipTextField.addTarget(self, action: #selector(checkForDecimals), for: .editingChanged)
        clockedLabel.alpha = 0
        animationBackground.alpha = 0
        
        // Do any additional setup after loading the view.
    }
    
    @objc func checkForDecimals(){
        tipEntered = tipTextField.text!
        let numbersArray : [String] = ["1","2","3","4","5","6","7","8","9","0"]
        for x in numbersArray{
            for y in numbersArray{
                if((tipTextField.text?.contains(".\(x)\(y)"))!){
                    tipTextField.isUserInteractionEnabled = false
                    tipTextField.resignFirstResponder()
                }
            }
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        updateLabels()
        scrollViewMain.setContentOffset(CGPoint(x: 0,y: -20), animated: true)
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        closeKeyboardButton.isHidden = false
        submitTipButton.isHidden = false
    }
    
    
    @IBAction func closeKeyboardButton(_ sender: Any) {
        self.view.endEditing(true)
        tipTextField.text = ""
        tipTextField.isUserInteractionEnabled = true
        closeKeyboardButton.isHidden = true
        submitTipButton.isHidden = true
    }
    
    
    @IBAction func submitTipTapped(_ sender: Any) {
        if model.clockedIn{
            closeKeyboardButton.isHidden = true
            submitTipButton.isHidden = true
            model.createTip(amount: Double(tipEntered)!, tableView: self.tableView)
            tipTextField.text = ""
            lastTipAmountLabel.text = "$\(tipEntered)"
            updateLabels()
        }else{
            let alert = UIAlertController(title: "Not Clocked In", message: "You are not clocked in, in order to submit a tip please clock in.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
            self.present(alert,animated: true)
        }
        
        
    }
    
    func updateLabels(){
        let numberFormatter = NumberFormatter()
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.minimumIntegerDigits = 1
        if model.clockedIn{
            if(model.currentDay.tips.count != 0){
                let amountString = numberFormatter.string(from: NSNumber(value: model.currentDay.tips[0].tipAmount))
                lastTipAmountLabel.text = "$\(amountString ?? "0.00")"
            }
        }else{
            lastTipAmountLabel.text = "$0.00"
        }
        var totalTipAmount : Double = 0.00
        for index in model.currentDay.tips{
            totalTipAmount += index.tipAmount
        }
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 2
        let numberString = formatter.string(from: NSNumber(value: totalTipAmount))
        totalTipAmountLabel.text = "$\(numberString!)"
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRows = model.currentDay.tips.count
        return numberOfRows
    }
    
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Recent Tips:"
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TipsCell") as! HomeTipsTableViewCell
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 2
        
        let tip = model.currentDay.tips[indexPath.row]
        let numberString = formatter.string(from: NSNumber(value: tip.tipAmount))
        cell.amountLabel.text = "$\(numberString!)"
        cell.dateLabel.text = tip.tipTime ?? ""
        
        
        return cell
    }
    
    
    @objc func screenTapped(){
        self.view.endEditing(true)
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
        tableView.reloadData()
    }
    
    
    
    @IBAction func clockInButton(_ sender: Any) {
        let clockInVar = model.clockIn()
        if clockInVar.animation{
            do{
                let gif = try UIImage(gifName: "Checkmark.gif")
                animationImage.isHidden = false
                animationImage.setGifImage(gif)
                animationImage.loopCount = 1
                animationImage.startAnimatingGif()
            }catch{
                print(error)
            }
            UIView.animateKeyframes(withDuration: 1, delay: 0, options: [], animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
                    self.animationBackground.alpha = 1
                })
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1, animations: {
                    self.clockedLabel.text = "Clocked In!"
                    self.clockedLabel.alpha = 1
                })
            }, completion: {_ in
                UIView.animate(withDuration: 1, animations: {
                    self.clockedLabel.alpha = 0
                    self.animationBackground.alpha = 0
                })
            })
        }else{
            present(clockInVar.controller!, animated: true)
            
        }
    }
    
    
    
    @IBAction func clockOutButton(_ sender: Any) {
        let clockOutVar = model.clockOut()
        if clockOutVar.showAnimation{
            do{
                let gif = try UIImage(gifName: "Checkmark.gif")
                animationImage.isHidden = false
                animationImage.setGifImage(gif)
                animationImage.loopCount = 1
                animationImage.startAnimatingGif()
                updateLabels()
                tableView.reloadData()
            }catch{
                print(error)
            }
            UIView.animateKeyframes(withDuration: 1, delay: 0, options: [], animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
                    self.animationBackground.alpha = 1
                })
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1, animations: {
                    self.clockedLabel.text = "Clocked Out!"
                    self.clockedLabel.alpha = 1
                })
            }, completion: {_ in
                UIView.animate(withDuration: 1, animations: {
                    self.clockedLabel.alpha = 0
                    self.animationBackground.alpha = 0
                })
            })
        }else{
            present(clockOutVar.controller!, animated: true)
        }

    }
    
    
    
    func stopAnimation(){
        animationImage.stopAnimatingGif()
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
