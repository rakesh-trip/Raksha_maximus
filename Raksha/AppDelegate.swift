//
//  AppDelegate.swift
//  Raksha
//
//  Created by Admin on 14/06/16.
//  Copyright © 2016 maximus. All rights reserved.
//

import UIKit
import SwiftSpinner

var DeviceReferenceID = UIDevice.currentDevice().identifierForVendor!.UUIDString
var systemVersion = UIDevice.currentDevice().systemVersion
var systemName = UIDevice.currentDevice().systemName
var deviceName = UIDevice.currentDevice().name

let defaults = NSUserDefaults.standardUserDefaults()
let MyKeychain = KeychainWrapper()
let MyKeychain1 = KeychainWrapper()
var baseUrl = "http://125.99.113.202:8777/"

var timer = NSTimer()

class AppDelegate: UIResponder, UIApplicationDelegate {
    var isReachable:Bool!
    var window: UIWindow?
    

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
      
        print(systemVersion)
        print(systemName)
        print(deviceName)
        // alternatively: let output = CryptoSwift.Hash.md5(input).calculate()
        if deviceName == "iPhone Simulator"
        {
            DeviceReferenceID = "88B0BA86-8599-401D-9EEF-374D5BD4BCAD"
            print(DeviceReferenceID)
        }
        else{
            print("AppDelegate UUID is * * * * * * * * * * * " + DeviceReferenceID)
        }
        // Override point for customization after application launch.
        defaults.boolForKey("launchedBefore")
        if (defaults.boolForKey("launchedBefore"))  {
            print("Not first launch.")

        }
        else {
            print("First launch, setting NSUserDefault.")
        }
        
        if let mobileNo = defaults.stringForKey("mobileNo")
        {
            print("The user has a mobile number defined " + mobileNo)
        }
        if let hashPassword = defaults.stringForKey("hashPassword")
        {
            print("The user has a hashPassword defined " + hashPassword)
            
            self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyBoard.instantiateViewControllerWithIdentifier("LoginVC") as! LoginViewController
            self.window?.rootViewController = viewController
            self.window?.makeKeyAndVisible()
        }
        
        if Reachability.isConnectedToNetwork() == true
        {
            print("Internet Connection OK")
        }
        else
        {
            print("Internet connection FAILED")
            let alert = UIAlertView(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        print("in background")
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        print("active after background")
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

