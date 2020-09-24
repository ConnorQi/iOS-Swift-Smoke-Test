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
import AppCenterPush
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MSCrashesDelegate, MSDistributeDelegate, MSPushDelegate, UNUserNotificationCenterDelegate, CLLocationManagerDelegate {

    var window: UIWindow?
    private var locationManager : CLLocationManager = CLLocationManager()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        MSCrashes.setDelegate(self)
        MSDistribute.setDelegate(self)
        MSPush.setDelegate(self)
        MSAppCenter.setLogLevel(MSLogLevel.verbose)
        MSAppCenter.start("b3466feb-d737-4a14-a60d-d4a4bb3c6bc2", withServices:[
            MSAnalytics.self,
            MSCrashes.self,
            MSPush.self,
            MSDistribute.self
            ])
        MSAppCenter.setLogUrl("https://in-integration.dev.avalanch.es");
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
        locationManager.requestWhenInUseAuthorization()
        MSCrashes.setUserConfirmationHandler({ (errorReports: [MSErrorReport]) in
            
            // Your code to present your UI to the user, e.g. an UIAlertController.
            let alertController = UIAlertController(title: "Sorry about that!",
                                                    message: "Do you want to send an anonymous crash report so we can fix the issue?",
                                                    preferredStyle:.alert)
            
            alertController.addAction(UIAlertAction(title: "Don't send", style: .cancel) {_ in
                MSCrashes.notify(with: .dontSend)
            })
            
            alertController.addAction(UIAlertAction(title: "Send", style: .default) {_ in
                MSCrashes.notify(with: .send)
            })
            
            alertController.addAction(UIAlertAction(title: "Always send", style: .default) {_ in
                MSCrashes.notify(with: .always)
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
    
    func crashes(_ crashes: MSCrashes!, shouldProcessErrorReport errorReport: MSErrorReport!) -> Bool {
        
        // return true if the crash report should be processed, otherwise false.
        return true
    }
    
    func crashes(_ crashes: MSCrashes!, willSend errorReport: MSErrorReport!) {
    }
    
    func crashes(_ crashes: MSCrashes!, didSucceedSending errorReport: MSErrorReport!) {
    }
    
    func crashes(_ crashes: MSCrashes!, didFailSending errorReport: MSErrorReport!, withError error: Error!) {
    }
    
    func attachments(with crashes: MSCrashes, for errorReport: MSErrorReport) -> [MSErrorAttachmentLog] {
        let attachment1 = MSErrorAttachmentLog.attachment(withText: "Hello world!", filename: "hello.txt")
        let attachment2 = MSErrorAttachmentLog.attachment(withBinary: "Fake image".data(using: String.Encoding.utf8), filename: nil, contentType: "image/jpeg")
        return [attachment1!, attachment2!]
    }

    func push(_ push: MSPush!, didReceive pushNotification: MSPushNotification!) {
        let title: String = pushNotification.title ?? ""
        var message: String = pushNotification.message ?? ""
        var customData: String = ""
        for item in pushNotification.customData {
            customData =  ((customData.isEmpty) ? "" : "\(customData), ") + "\(item.key): \(item.value)"
        }
        if (UIApplication.shared.applicationState == .background) {
            NSLog("Notification received in background, title: \"\(title)\", message: \"\(message)\", custom data: \"\(customData)\"");
        } else {
            message =  message + ((customData.isEmpty) ? "" : "\n\(customData)")
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel))
            
            // Show the alert controller.
            self.window?.rootViewController?.present(alertController, animated: true)
        }
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
                MSAppCenter.setCountryCode(placemarks?.first?.isoCountryCode)
            }
        }
    }
    
    func locationManager(_ Manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    func distribute(_ distribute: MSDistribute!, releaseAvailableWith details: MSReleaseDetails!) -> Bool {
        
        // Your code to present your UI to the user, e.g. an UIAlertController.
        let alertController = UIAlertController(title: "Update available.",
                                                message: "Do you want to update?",
                                                preferredStyle:.alert)
        
        alertController.addAction(UIAlertAction(title: "Update", style: .cancel) {_ in
            MSDistribute.notify(.update)
        })
        
        alertController.addAction(UIAlertAction(title: "Postpone", style: .default) {_ in
            MSDistribute.notify(.postpone)
        })
        
        // Show the alert controller.
        self.window?.rootViewController?.present(alertController, animated: true)
        return true;
    }

}

