//
//  ViewController.swift
//  ios-swift-release-test
//
//  Created by bys on 2019/8/27.
//  Copyright © 2019 bys. All rights reserved.
//

import UIKit
import AppCenter
import AppCenterAnalytics
import AppCenterCrashes


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


    @IBAction func event(_ sender: UIButton) {
        MSAnalytics.trackEvent("event")
    }
    
    
    @IBAction func eventwithproperties(_ sender: UIButton) {
        MSAnalytics.trackEvent("eventwithproperties", withProperties: ["Category" : "Music", "FileName" : "favorite.avi"])
    }
    
    
    @IBAction func crash(_ sender: UIButton) {
        MSCrashes.generateTestCrash()
    }
}

