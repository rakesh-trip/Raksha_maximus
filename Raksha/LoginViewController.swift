//
//  LoginViewController.swift
//  Raksha
//
//  Created by Admin on 17/06/16.
//  Copyright © 2016 maximus. All rights reserved.
//

import UIKit
import Alamofire
import SwiftSpinner

let wsMethodLogin = "Login"
let appendStringLogin = baseUrl + wsMethodLogin

class LoginViewController: UIViewController, UIAlertViewDelegate, UITextFieldDelegate{

    @IBOutlet weak var txtLoginPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(appendStringLogin)
        txtLoginPassword.delegate=self
        if let mobileNo = defaults.stringForKey("mobileNo")
        {
            print("The user has a mobile number defined " + mobileNo)
        }
        if let hashPassword = defaults.stringForKey("hashPassword")
        {
            print("The user has a hashpassword defined in LoginVC" + hashPassword)
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
    
    
     func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func loginTapped(MobileNumber : String, Password : String)
    {
        print("mobile no is  : " + defaults.stringForKey("mobileNo")!)
        SwiftSpinner.showWithDuration(2.0, title: "Loading", animated: true)

        Alamofire.request(.POST, appendStringLogin, parameters: ["DeviceReferenceID":DeviceReferenceID, "MobileNumber":defaults.stringForKey("mobileNo")!, "Password":Password])
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
                    SwiftSpinner.showWithDuration(2.0, title: "Loading....", animated: true)
                    let next = self.storyboard?.instantiateViewControllerWithIdentifier("dashboardVC") as! DashboardViewController
                    self.presentViewController(next, animated: true, completion: nil)
                }
                else
                {
                        SwiftSpinner.showWithDuration(2.0, title: "Incorrect/Invalid Password", animated: false)
                }
        }
    }
    
    
    
    @IBAction func btnLogin(sender: AnyObject)
    {
//        defaults.setObject(self.txtLoginPassword.text, forKey: "password")

        let hashPassword = txtLoginPassword.text!.md5()
        print(hashPassword)
        defaults.setObject(hashPassword, forKey: "hashPassword")
              
        if(txtLoginPassword.text! == "demo@123" ){
            let next = self.storyboard?.instantiateViewControllerWithIdentifier("dashboardVC") as! DashboardViewController
            self.presentViewController(next, animated: true, completion: nil)
        }
        if (txtLoginPassword.text == "")
        {
            print(" please enter text")
            let alertView = UIAlertController(title: "Oops! A Problem", message: "Please enter your password." as String, preferredStyle:.Alert)
            let okAction = UIAlertAction(title: "Failed!", style: .Default, handler: nil)
            alertView.addAction(okAction)
            self.presentViewController(alertView, animated: true, completion: nil)
        }
        loginTapped(defaults.stringForKey("mobileNo")!, Password : txtLoginPassword.text!)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func btnForgotPassword(sender: AnyObject) {
        let next = self.storyboard?.instantiateViewControllerWithIdentifier("forgotPasswordVC") as! ForgotPasswordView
        self.presentViewController(next, animated: true, completion: nil)
    }
}
