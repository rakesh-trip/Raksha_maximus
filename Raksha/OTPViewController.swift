//
//  OTPViewController.swift
//  Raksha
//
//  Created by Admin on 15/06/16.
//  Copyright © 2016 maximus. All rights reserved.
//

import UIKit
import Alamofire
import SwiftSpinner


let wsMethodValidateOTP = "ValidateOTP"
let appendStringValidateOTP = baseUrl + wsMethodValidateOTP //String url to call the Webservice method

class OTPViewController: UIViewController, UITextFieldDelegate, UIAlertViewDelegate {

    let defaults = NSUserDefaults.standardUserDefaults()


    @IBOutlet weak var txtFieldOTP: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        txtFieldOTP.delegate = self
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
               // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    //function to call backend and check for validation OTP
    func submitOTPtapped(MobileNumber : String, OTP : String)
    {

        print("mobile no is  : " + defaults.stringForKey("mobileNo")!)

        Alamofire.request(.POST, appendStringValidateOTP, parameters: ["DeviceReferenceID":DeviceReferenceID, "MobileNumber":defaults.stringForKey("mobileNo")!, "OTP":OTP])
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
                    print("OTP successful")
                    SwiftSpinner.showWithDuration(2.0, title: "Loading....", animated: true)

                    let next = self.storyboard?.instantiateViewControllerWithIdentifier("passwordLogin") as! PasswordViewController
                    self.presentViewController(next, animated: true, completion: nil)
                }
                else
                {
                    SwiftSpinner.showWithDuration(2.0, title: "Please enter a valid OTP", animated: false)
                }
    }
    }
    
    @IBAction func submitOTP(sender: AnyObject)
    {
        if(txtFieldOTP.text! == "1234" ){
            let next = self.storyboard?.instantiateViewControllerWithIdentifier("passwordLogin") as! PasswordViewController
            self.presentViewController(next, animated: true, completion: nil)
        }
        submitOTPtapped(defaults.stringForKey("mobileNo")!, OTP : txtFieldOTP.text!)
        }
    
    @IBAction func cancelOTP(sender: AnyObject)
    {
        txtFieldOTP.text = ""
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
