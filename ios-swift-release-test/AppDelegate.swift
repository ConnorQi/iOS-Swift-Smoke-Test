//
//  AppDelegate.swift
//  ios-swift-release-test
//
//  Created by bys on 2019/8/27.
//  Copyright © 2019 bys. All rights reserved.
//

import UIKit
import CoreLocation
import AppCenter
import AppCenterAnalytics
import AppCenterCrashes
import AppCenterDistribute
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CrashesDelegate, DistributeDelegate, UNUserNotificationCenterDelegate, CLLocationManagerDelegate {

    var window: UIWindow?
    private var locationManager : CLLocationManager = CLLocationManager()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        Crashes.delegate = self
        Distribute.delegate = self
        AppCenter.logLevel = .verbose
        AppCenter.start(withAppSecret: "f75926f7-47d1-46a9-8940-b2c06729ddf7", services:[
            Analytics.self,
            Crashes.self,
            Distribute.self
            ])
        AppCenter.logUrl = "https://in-integration.dev.avalanch.es"
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
        locationManager.requestWhenInUseAuthorization()
        Crashes.userConfirmationHandler = ({ (errorReports: [ErrorReport]) in
            
            // Your code to present your UI to the user, e.g. an UIAlertController.
            let alertController = UIAlertController(title: "Sorry about that!",
                                                    message: "Do you want to send an anonymous crash report so we can fix the issue?",
                                                    preferredStyle:.alert)
            
            alertController.addAction(UIAlertAction(title: "Don't send", style: .cancel) {_ in
                Crashes.notify(with: .dontSend)
            })
            
            alertController.addAction(UIAlertAction(title: "Send", style: .default) {_ in
                Crashes.notify(with: .send)
            })
            
            alertController.addAction(UIAlertAction(title: "Always send", style: .default) {_ in
                Crashes.notify(with: .always)
            })
            
            // Show the alert controller.
            self.window?.rootViewController?.present(alertController, animated: true)
            return true // Return true if the SDK should await user confirmation, otherwise return false.
        })
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func crashes(_ crashes: Crashes, shouldProcess errorReport: ErrorReport) -> Bool {
        
        // return true if the crash report should be processed, otherwise false.
        return true
    }
    
    func crashes(_ crashes: Crashes, willSend errorReport: ErrorReport) {
    }
    
    func crashes(_ crashes: Crashes, didSucceedSending errorReport: ErrorReport) {
    }
    
    func crashes(_ crashes: Crashes, didFailSending errorReport: ErrorReport, withError error: Error?) {
    }
    
    func attachments(with crashes: Crashes, for errorReport: ErrorReport) -> [ErrorAttachmentLog]? {
        let attachment1 = ErrorAttachmentLog.attachment(withText: "\(UIDevice.current.name)", filename: "hello.txt")
        let attachment2 = ErrorAttachmentLog.attachment(withBinary: "Fake image".data(using: String.Encoding.utf8), filename: nil, contentType: "image/jpeg")
        return [attachment1!, attachment2!]
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            manager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        CLGeocoder().reverseGeocodeLocation(userLocation) { (placemarks, error) in
            if error == nil {
                AppCenter.countryCode = placemarks?.first?.isoCountryCode ?? ""
            }
        }
    }
    
    func locationManager(_ Manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
    func distribute(_ distribute: Distribute, releaseAvailableWith details: ReleaseDetails) -> Bool {
        
        // Your code to present your UI to the user, e.g. an UIAlertController.
        let alertController = UIAlertController(title: "Update available.",
                                                message: "Do you want to update?",
                                                preferredStyle:.alert)
        
        alertController.addAction(UIAlertAction(title: "Update", style: .cancel) {_ in
            Distribute.notify(.update)
        })
        
        alertController.addAction(UIAlertAction(title: "Postpone", style: .default) {_ in
            Distribute.notify(.postpone)
        })
        
        // Show the alert controller.
        self.window?.rootViewController?.present(alertController, animated: true)
        return true;
    }

}
