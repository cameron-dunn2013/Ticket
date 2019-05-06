//
//  ViewController.swift
//  TicketV2
//
//  Created by Cameron Dunn on 5/4/19.
//  Copyright © 2019 Cameron Dunn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var ticketImage: UIImageView!
    @IBOutlet weak var background: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        UIView.animateKeyframes(withDuration: 1, delay: 0, options: [], animations: {
            self.ticketImage.alpha = 0
            self.background.alpha = 0
        }, completion: {_ in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "TabBarController")
            self.present(viewController, animated: false)
        })
    }


}

