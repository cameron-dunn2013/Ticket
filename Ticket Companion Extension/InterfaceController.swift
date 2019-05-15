//
//  InterfaceController.swift
//  Ticket Companion Extension
//
//  Created by Cameron Dunn on 5/14/19.
//  Copyright © 2019 Cameron Dunn. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController, WCSessionDelegate, WKCrownDelegate {
    
    enum ButtonActiveStates{
        case dollars
        case cents
    }
    
    var buttonActive : ButtonActiveStates = .dollars
    @IBOutlet weak var imageView: WKInterfaceImage!
    @IBOutlet weak var dollarsButton: WKInterfaceButton!
    @IBOutlet weak var centsButton: WKInterfaceButton!
    
    var session: WCSession!
    var centsInt: Double = 0.00
    var dollarsInt : Double = 0.00
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        session = WCSession.default
        session.delegate = self
        session.activate()
        crownSequencer.delegate = self
        crownSequencer.isHapticFeedbackEnabled = true
        crownSequencer.focus()
        dollarsButton.setBackgroundColor(UIColor.lightGray)
        centsButton.setBackgroundColor(UIColor.darkGray)
    }
    @IBAction func centsButtonTapped() {
        buttonActive = .cents
        centsButton.setBackgroundColor(UIColor.lightGray)
        dollarsButton.setBackgroundColor(UIColor.darkGray)
    }
    @IBAction func dollarsButtonTapped() {
        buttonActive = .dollars
        centsButton.setBackgroundColor(UIColor.darkGray)
        dollarsButton.setBackgroundColor(UIColor.lightGray)
    }
    
    //handle the crown rotating
    func crownDidRotate(_ crownSequencer: WKCrownSequencer?, rotationalDelta: Double) {
        let formatter = NumberFormatter()
        if(buttonActive == .cents){
            if(centsInt >= 0 && centsInt <= 0.99){
                formatter.minimumFractionDigits = 2
                formatter.maximumIntegerDigits = 0
                if(rotationalDelta >= 0){
                    centsInt += 0.002
                }else{
                    centsInt -= 0.002
                }
                if(centsInt < 0){
                    centsInt = 0.00
                }else if(centsInt > 0.99){
                    centsInt = 0.99
                }
            }
            centsButton.setTitle(formatter.string(from: NSNumber(value: centsInt)) ?? ".00")
        }else{
            if(dollarsInt >= 0 && dollarsInt <= 100){
                formatter.maximumFractionDigits = 0
                formatter.minimumIntegerDigits = 1
                if(rotationalDelta >= 0){
                    dollarsInt += 0.2
                }else{
                    dollarsInt -= 0.2
                    
                }
                if(dollarsInt < 0){
                    dollarsInt = 0
                }else if(dollarsInt > 100){
                    dollarsInt = 100
                }
            }
            dollarsButton.setTitle(formatter.string(from: NSNumber(value: Double(Int(dollarsInt)))) ?? "0")
        }
        
    }
    @IBAction func sendTip() {
        let tip = Tip(tipAmount: (Double(Int(dollarsInt)) + centsInt), longDate: Date())
        var data = ""
        do{
            let jsonEncoder = JSONEncoder()
            data = try jsonEncoder.encode(tip).base64EncodedString()
        }catch{
            print(error)
        }
        session.sendMessage(["Tip": data], replyHandler: nil) { (error) in
            print(error)
        }
        self.dollarsInt = 0.00
        self.centsInt = 0.00
        self.dollarsButton.setTitle("0")
        self.centsButton.setTitle(".00")
        
    }
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
