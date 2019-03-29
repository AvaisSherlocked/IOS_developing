//
//  AppDelegate.swift
//  CouponGo
//
//  Created by Ava on 3/2/19.
//  Copyright © 2019 CouponGo. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import StoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let localStorage = UserDefaults.standard
    let dateFormatter = DateFormatter()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        GMSServices.provideAPIKey("AIzaSyCBKkFLtdN2W3B_u77hRB6oBZRGeSS-iWg")
        GMSPlacesClient.provideAPIKey("AIzaSyCBKkFLtdN2W3B_u77hRB6oBZRGeSS-iWg")
        
        
        if !localStorage.bool(forKey: "setup") { // first time log in
            //set up default values for local storage
            localStorage.set([String](), forKey: "myCouponList") // set user collection of coupons to empty
            localStorage.set(true, forKey: "setup") // first time setup is done
            localStorage.set(1, forKey: "login_count") // first time login
            // set first time log in date
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yyyy"
            let result = formatter.string(from: date)
            localStorage.set(result, forKey: "firstTimeLoginDate")
            
        } else if localStorage.integer(forKey: "login_count") == 3 {
            // pop out review request for the third time log in
            SKStoreReviewController.requestReview()
            localStorage.set(localStorage.integer(forKey: "login_count") + 1, forKey: "login_count")
        } else {
            // increment login count
            localStorage.set(localStorage.integer(forKey: "login_count") + 1, forKey: "login_count")
        }
        
        Thread.sleep(forTimeInterval: 2.0)
        
        
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


}

