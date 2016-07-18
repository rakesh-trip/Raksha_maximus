//
//  SignInViewController.swift
//  Raksha
//
//  Created by Admin on 15/06/16.
//  Copyright © 2016 maximus. All rights reserved.
//

import UIKit
import Alamofire

class SignInViewController: UIViewController, UITextFieldDelegate, UIAlertViewDelegate {
   
    let defaults = NSUserDefaults.standardUserDefaults()
    
    @IBOutlet weak var textMobnumber: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let mobileNo = defaults.stringForKey("mobileNo")
        {
            print("The user has a mobile number ************* " + mobileNo)
        }
        textMobnumber.delegate = self
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
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        textMobnumber.resignFirstResponder()
        
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
    
    
    func signInTapped(MobileNumber : String)
    {
        Alamofire.request(.POST, "http://125.99.113.202:8777/ValidateMobileNumber", parameters: ["DeviceReferenceID":DeviceReferenceID, "MobileNumber":MobileNumber])
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                let JSON = response.result.value
                print("JSON: \(JSON)")
                let string: NSString = JSON as! NSString
                print("string is " + (string as String))
        
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
            print("Repeated user")
            
            let next = self.storyboard?.instantiateViewControllerWithIdentifier("otp_verify") as! OTPViewController
            self.presentViewController(next, animated: true, completion: nil)
        }
    }

    }

    @IBAction func sunsignin(sender: AnyObject)
    {
        defaults.setObject(self.textMobnumber.text, forKey: "mobileNo")

        
        signInTapped(textMobnumber.text!)
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
