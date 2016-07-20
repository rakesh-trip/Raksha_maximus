//
//  DashboardViewController.swift
//  Raksha
//
//  Created by Admin on 17/06/16.
//  Copyright © 2016 maximus. All rights reserved.
//

import UIKit
import Alamofire
import SwiftSpinner

class DashboardViewController: UIViewController , UITextViewDelegate {

    var PassValue = ""
    
    @IBOutlet weak var edCardBtn: UIButton!
    
    @IBOutlet weak var spendLimitBtn: UIButton!
    
    @IBOutlet weak var latestTransBtn: UIButton!
    
    @IBOutlet weak var edChannelBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

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
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        
        if let mobileNo = defaults.stringForKey("mobileNo")
        {
            print("The user has a mobile number defined " + mobileNo)
        }
          
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    

    
    // MARK: - NSXMLParserDelegate methods
    @IBAction func EDCard(sender: AnyObject) {
        PassValue = "EDCard"
        print("passvalue : " + PassValue)

       edCardBtn.backgroundColor = UIColor(red: 0, green: 255, blue: 0, alpha: 1.0 )

    }
    
    
    @IBAction func btnSpendLimitClick(sender: AnyObject) {
        PassValue = "SpendLimit"
        print("passvalue : " + PassValue)
//        spendLimitBtn.backgroundColor = UIColor.greenColor()

//    performSegueWithIdentifier("spendLimit", sender: self)
    }
    
    // MARK: - NSXMLParserDelegate methods
    
    @IBAction func btnLatestTrans(sender: AnyObject) {
        PassValue = "LatestTransaction"
        print("passvalue : " + PassValue)
//            performSegueWithIdentifier("ltstTrans", sender: self)
//        latestTransBtn.backgroundColor = UIColor.greenColor()
    }
    
    // MARK: - NSXMLParserDelegate methods
    
    @IBAction func btnChannelControl(sender: AnyObject) {
        PassValue = "ChannelControl"
        print("passvalue : " + PassValue)
//            performSegueWithIdentifier("edChannel", sender: self)
//        edChannelBtn.backgroundColor = UIColor.greenColor()
        
    }
    
    @IBAction func btnSettings(sender: AnyObject)
    {
        let next = self.storyboard?.instantiateViewControllerWithIdentifier("forgotPassword") as! ForgotPasswordView
        self.presentViewController(next, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let abcd = segue.destinationViewController as! SelectCardViewController
        abcd.ButtonOptionClicked=PassValue
    }
    

        /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    func logOutTapped(MobileNumber : String)
    {
        
        Alamofire.request(.POST, "http://125.99.113.202:8777/LogOut", parameters: ["DeviceReferenceID":DeviceReferenceID, "MobileNumber":defaults.stringForKey("mobileNo")!])
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                let JSON = response.result.value
                print("JSON: \(JSON)")
                let string: NSString = JSON as! NSString
                print("string is " + (string as String))
                
                if string.containsString("Successful")
                {
                    print("Logout successful")
                    let Alert: UIAlertView = UIAlertView()
                    Alert.delegate = self
                    Alert.title = "Raksha"
                    Alert.message = "You have been logged out of Raksha."
                    Alert.addButtonWithTitle("OK")
                    Alert.show()
                    
                    let next = self.storyboard?.instantiateViewControllerWithIdentifier("LoginVC") as! LoginViewController
                    self.presentViewController(next, animated: true, completion: nil)
                }
                
                }
    }

    
                
    @IBAction func btnLogout(sender: AnyObject)
    {
        logOutTapped(defaults.stringForKey("mobileNo")!)
    }
}
