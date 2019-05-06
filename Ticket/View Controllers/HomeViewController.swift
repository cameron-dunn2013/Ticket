//
//  HomeViewController.swift
//  Ticket
//
//  Created by Cameron Dunn on 5/5/19.
//  Copyright © 2019 Cameron Dunn. All rights reserved.
//

import UIKit
import SwiftyGif

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var animationImage: UIImageView!
    
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
            do{
                let gif = try UIImage(gifName: "Checkmark.gif")
                animationImage.loopCount = 1
                animationImage.isHidden = false
                animationImage.setGifImage(gif)
                animationImage.startAnimatingGif()
                _ = Timer.scheduledTimer(withTimeInterval: 1.7, repeats: false, block: {_ in
                    self.stopAnimation()
                })
            }catch{
                print(error)
            }
        }else{
            present(clockInVar.controller!, animated: true)
        }
    }
    @IBAction func clockOutButton(_ sender: Any) {
        let clockOutVar = model.clockOut()
        if clockOutVar.showAnimation{
            do{
                let gif = try UIImage(gifName: "Checkmark.gif")
                animationImage.loopCount = 1
                animationImage.isHidden = false
                animationImage.setGifImage(gif)
                animationImage.startAnimatingGif()
                _ = Timer.scheduledTimer(withTimeInterval: 1.7, repeats: false, block: {_ in
                    self.stopAnimation()
                })
            }catch{
                print(error)
            }
        }else{
            present(clockOutVar.controller!, animated: true)
        }

    }
    func stopAnimation(){
        animationImage.stopAnimatingGif()
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
