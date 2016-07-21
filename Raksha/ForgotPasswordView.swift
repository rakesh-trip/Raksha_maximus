//
//  ForgotPasswordView.swift
//  Raksha
//
//  Created by Admin on 17/06/16.
//  Copyright © 2016 maximus. All rights reserved.
//

import UIKit
import Alamofire
import SwiftSpinner

class ForgotPasswordView: UIViewController, UITextFieldDelegate, UIAlertViewDelegate {
    let defaults = NSUserDefaults.standardUserDefaults()

    @IBOutlet weak var txtpassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtpassword.delegate = self
        txtConfirmPassword.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        print("UUID is * * * * * * * * * * * " + DeviceReferenceID)
        
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
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        txtpassword.resignFirstResponder()
        txtConfirmPassword.resignFirstResponder()
        return true
    }
    func submitNewPasswordTapped(MobileNumber : String, NewPassword : String)
    {

        Alamofire.request(.POST, "http://125.99.113.202:8777/ChangePassword", parameters: ["DeviceReferenceID":DeviceReferenceID, "MobileNumber":defaults.stringForKey("mobileNo")!, "NewPassword":NewPassword])
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
                    let next = self.storyboard?.instantiateViewControllerWithIdentifier("LoginVC") as! LoginViewController
                    self.presentViewController(next, animated: true, completion: nil)
                    let alertView = UIAlertController(title: "RAKSHA", message: "Passwords changed successfuly." as String, preferredStyle:.Alert)
                                let okAction = UIAlertAction(title: "Success!", style: .Default, handler: nil)
                                alertView.addAction(okAction)
                                self.presentViewController(alertView, animated: true, completion: nil)

                }
                else
                {
                    SwiftSpinner.showWithDuration(2.0, title: "Error, please try again!!", animated: false)

                }
                
        }
    }

    
    @IBAction func btnSubmitPassword(sender: AnyObject)
    {
        submitNewPasswordTapped(defaults.stringForKey("mobileNo")!, NewPassword: txtpassword.text!)
        
        if (txtpassword.text == "" || txtConfirmPassword.text == "")
        {
            print(" please enter text")
            let alertView = UIAlertController(title: "Oops! A Problem", message: "Please enter some text." as String, preferredStyle:.Alert)
            let okAction = UIAlertAction(title: "Failed!", style: .Default, handler: nil)
            alertView.addAction(okAction)
            self.presentViewController(alertView, animated: true, completion: nil)
        }
        
        if (txtpassword.text?.characters.count != 4) {
            print("please enter atleast 4 characters as your password.")
        }
        
        if (txtpassword.text == txtConfirmPassword.text)
        {
            print("passwords match")
           
        }
        else
        {
            print("passwords don't match")
            
            let alertView = UIAlertController(title: "Oops! A Problem", message: "Please ensure that the passwords match." as String, preferredStyle:.Alert)
            let okAction = UIAlertAction(title: "Failed!", style: .Default, handler: nil)
            alertView.addAction(okAction)
            self.presentViewController(alertView, animated: true, completion: nil)
            
            return;
        }
    }
    
    @IBAction func btnCancelPassword(sender: AnyObject)
    {
        txtpassword.text = ""
        txtConfirmPassword.text = ""
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
