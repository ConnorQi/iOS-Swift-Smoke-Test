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
        Analytics.trackEvent("\(UIDevice.current.name)")
    }
    
    
    @IBAction func eventwithproperties(_ sender: UIButton) {
        let target = getSystemVersionInfo()
        Analytics.trackEvent("\(UIDevice.current.name) with properties",
                             withProperties:
                                ["Category" : "Music",
                                 "FileName" : "favorite.avi",
                                 "DeviceInfo" : target])
    }
    
    
    @IBAction func crash(_ sender: UIButton) {
        Crashes.generateTestCrash()
    }

    
    func getSystemVersionInfo() -> String {
        let deviceName = UIDevice.current.name
        let sysName = UIDevice.current.systemName
        let sysVersion = UIDevice.current.systemVersion
        let result = "DeviceName: \(deviceName), SystemName: \(sysName), SystemVersion: \(sysVersion)"
        return result
    }
}

