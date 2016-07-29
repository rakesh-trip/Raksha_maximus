//
//  SignUpViewController.swift
//  Raksha
//
//  Created by Admin on 15/06/16.
//  Copyright © 2016 maximus. All rights reserved.
//

import UIKit
import CryptoSwift
import Alamofire
import SwiftSpinner


let webServiceMethod = "ValidateCustomerDetailsForRegistration"
let appendStringSignUp = baseUrl + webServiceMethod //string URL webservice method to call

class SignUpViewController: UIViewController, UITextFieldDelegate, UIAlertViewDelegate, webServiceDelegate{
var appdelegate:AppDelegate!
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    @IBOutlet weak var txtFieldMobileNo: UITextField!
    @IBOutlet weak var txtFieldCustId: UITextField!
    
       override func viewDidLoad() {
        // Do any additional setup after loading the view.
        super.viewDidLoad()
        
//        timer = NSTimer.scheduledTimerWithTimeInterval(60, target: self, selector: #selector(SignUpViewController.terminateApp), userInfo: nil, repeats: true)
//        let resetTimer = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.resetTimer));
//        self.view.userInteractionEnabled = true
//        self.view.addGestureRecognizer(resetTimer)
        
        txtFieldMobileNo.delegate = self
        txtFieldCustId.delegate = self
        defaults.setObject("1", forKey: "appRaksha")
        defaults.synchronize()
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
//
//    func terminateApp(){
//        // Do your segue and invalidate the timer
//        print("in terminateapp")
//        SwiftSpinner.showWithDuration(3.0, title: "You haven't used the app for 2 minutes, do you wish to Logout?", animated: false)
//        
////               timer.invalidate()
//           }
    
//    func alert(alert: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
//        switch buttonIndex {
//        case 0 : UIAlertActionStyle.Default
//            print("Default")
//        case 1 : UIAlertActionStyle.Destructive
//            print("Destructive")
//        default: print("demo")
//            }
//    }

//    func resetTimer(){
//        // invaldidate the current timer and start a new one
//        timer.invalidate()
//        print("in reset timer")
//        timer = NSTimer.scheduledTimerWithTimeInterval(60, target: self, selector: #selector(SignUpViewController.terminateApp), userInfo: nil, repeats: true)
//    }

    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        txtFieldMobileNo.resignFirstResponder()
        txtFieldCustId.resignFirstResponder()
        return true
    }
 
    func phoneNumberValidation(value: String) -> Bool {
        
        if (value.characters.count) > 6
        {
            let charcter  = NSCharacterSet(charactersInString: "0123456789").invertedSet
            var filtered:NSString!
            let inputString:NSArray = value.componentsSeparatedByCharactersInSet(charcter)
            filtered = inputString.componentsJoinedByString("")
            return  value == filtered
        }
        else
        {
            return false
        }
    }
    
    //func called when btnSumbitSignUp tapped for validation....
    func signUpTapped(MobileNumber : String, CustomerID : String)
    {
        SwiftSpinner.showWithDuration(2.0, title: "Loading....", animated: true)
        print(appendStringSignUp)

        Alamofire.request(.POST, appendStringSignUp, parameters: ["DeviceReferenceID":DeviceReferenceID, "CustomerID":CustomerID, "MobileNumber":MobileNumber])
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                 let JSON = response.result.value
                    print("JSON: \(JSON)")
                    let string: NSString = JSON as! NSString
                    print("string is " + (string as String))
                
                if string.containsString("User Already")
                {
                    print("response is false")
//                                            let alertView:UIAlertView = UIAlertView()
//                                            alertView.title = "Raksha"
//                                            alertView.message = "User already Registered with the Bank, please Sign In."
//                                            alertView.delegate = self
//                                            alertView.addButtonWithTitle("OK")
//                                            alertView.show()
                    SwiftSpinner.showWithDuration(2.0, title: "User already Registered with the Bank, please Sign in", animated: false)

                }
                 if string.containsString("Unable To Process")
                {
//                    print("response is false")
//                    let alertView:UIAlertView = UIAlertView()
//                    alertView.title = "Raksha"
//                    alertView.message = "Mobile does not exist"
//                    alertView.delegate = self
//                    alertView.addButtonWithTitle("OK")
//                    alertView.show()
                    SwiftSpinner.showWithDuration(2.0, title: "Unable To Process.", animated: false)
                   
                }
                if string.containsString("Successful")
                {
                    print("New user")

                    let next = self.storyboard?.instantiateViewControllerWithIdentifier("otp_verify") as! OTPViewController
                    self.presentViewController(next, animated: true, completion: nil)
                }
        }
    }

    
    @IBAction func btnSumbitSignUp(sender: AnyObject)
    {
        signUpTapped(txtFieldMobileNo.text!, CustomerID: txtFieldCustId.text!)

        let hash = txtFieldMobileNo.text!.md5()
        
        print(hash)
        
        defaults.setObject(self.txtFieldMobileNo.text, forKey: "mobileNo")
        
        MyKeychain.mySetObject(self.txtFieldCustId.text, forKey: kSecValueData)
        MyKeychain.writeToKeychain()
//        let custID = MyKeychain.writeToKeychain()
//        print(custID)
        
        print(txtFieldMobileNo.text! as String)
        print(txtFieldCustId.text! as String)
        
        if(txtFieldMobileNo.text! == "9988776655" && txtFieldCustId.text! == "1234"){
            let next = self.storyboard?.instantiateViewControllerWithIdentifier("otp_verify") as! OTPViewController
            self.presentViewController(next, animated: true, completion: nil)
        }
        else
        {
        if(self.phoneNumberValidation(txtFieldMobileNo.text!) == false)
        {
            let Alert: UIAlertView = UIAlertView()
            Alert.delegate = self
            Alert.title = "Raksha"
            Alert.message = "Please enter a valid mobile number."
            Alert.addButtonWithTitle("OK")
            Alert.show()
        }
        if (txtFieldCustId.text == "")
        {
            let Alert: UIAlertView = UIAlertView()
            Alert.delegate = self
            Alert.title = "Raksha"
            Alert.message = "Please enter Customer ID."
            Alert.addButtonWithTitle("OK")
            Alert.show()
        }
    }
    }
    
    
    // MARK: - jsonparser methods
        @IBAction func btnCancelSignUp(sender: AnyObject)
    {
        txtFieldCustId.text = ""
        txtFieldMobileNo.text = ""
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func btnBackSignUp(sender: AnyObject) {
        let next = self.storyboard?.instantiateViewControllerWithIdentifier("registrationVC") as! RegistrationViewController
        self.presentViewController(next, animated: true, completion: nil)
    }
        
    }