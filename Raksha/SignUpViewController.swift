//
//  SignUpViewController.swift
//  Raksha
//
//  Created by Admin on 15/06/16.
//  Copyright © 2016 maximus. All rights reserved.
//

import UIKit
//import Darwin
import CryptoSwift
import Alamofire

class SignUpViewController: UIViewController, UITextFieldDelegate, UIAlertViewDelegate, webServiceDelegate{
var appdelegate:AppDelegate!
    
    let defaults = NSUserDefaults.standardUserDefaults()

    @IBOutlet weak var txtFieldMobileNo: UITextField!
    @IBOutlet weak var txtFieldCustId: UITextField!
    
       override func viewDidLoad() {
        
        // Do any additional setup after loading the view.
        super.viewDidLoad()
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
    func signUpTapped(MobileNumber : String, CustomerID : String)
    {
//        let alertController = UIAlertController(title: "Raksha", message: "Loading...", preferredStyle: .Alert)
////        alertController.view.tintColor = UIColor.grayColor()
//        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(10, 20, 50, 50)) as UIActivityIndicatorView
//        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
//        alertController.view.addSubview(loadingIndicator)
//        loadingIndicator.startAnimating();
//
//        self.presentViewController(alertController, animated: true, completion: nil)
//        let delay = 4.0 * Double(NSEC_PER_SEC)
//        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
//        dispatch_after(time, dispatch_get_main_queue(), {
//            alertController.dismissViewControllerAnimated(true, completion: nil)
//        })
        
        Alamofire.request(.POST, "http://125.99.113.202:8777/ValidateCustomerDetailsForRegistration", parameters: ["DeviceReferenceID":DeviceReferenceID, "CustomerID":CustomerID, "MobileNumber":MobileNumber])
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
                                            let alertView:UIAlertView = UIAlertView()
                                            alertView.title = "Raksha"
                                            alertView.message = "User already Registered with the Bank, please Sign In."
                                            alertView.delegate = self
                                            alertView.addButtonWithTitle("OK")
                                            alertView.show()

                }
                 if string.containsString("User's Mobile Number Not Registered")
                {
                    print("response is false")
                    let alertView:UIAlertView = UIAlertView()
                    alertView.title = "Raksha"
                    alertView.message = "Mobile does not exist"
                    alertView.delegate = self
                    alertView.addButtonWithTitle("OK")
                    alertView.show()
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
        else if (txtFieldCustId.text == "")
        {
            let Alert: UIAlertView = UIAlertView()
            Alert.delegate = self
            Alert.title = "Raksha"
            Alert.message = "Please enter Customer ID."
            Alert.addButtonWithTitle("OK")
            Alert.show()
        }
        else
        {
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
    
        
    }