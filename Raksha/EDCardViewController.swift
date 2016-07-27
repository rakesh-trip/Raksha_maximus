//
//  EDCardViewController.swift
//  Raksha
//
//  Created by Admin on 17/06/16.
//  Copyright © 2016 maximus. All rights reserved.
//

import UIKit
import Alamofire
import SwiftSpinner


let wsMethodGetCustomerOperations = "GetCustomerOperations"
let appendStringGetCustomerOperations = baseUrl + wsMethodGetCustomerOperations

let wsMethodSetCustomerOperations = "SetCustomerOperations"
let appendStringSetCustomerOperations = baseUrl + wsMethodSetCustomerOperations

class EDCardViewController: UIViewController {
    
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblexpDate: UILabel!
    @IBOutlet weak var lblCard: UILabel!
    @IBOutlet weak var switchEdCard: UISwitch!
    
    let Response = NSMutableArray()
    var edCard:String!
    var expiryDate:String!
    var userName:String!
    var switchState:NSInteger = NSInteger()
    var edCardback = ""

    override func viewDidLoad() {

        super.viewDidLoad()
        

        if Reachability.isConnectedToNetwork() == true
        {
            print("Internet Connection OK")
        }
        else
        {
            print("Internet connection FAILED")
            switchEdCard.enabled = false
            let alert = UIAlertView(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
        
        lblName.text =  userName
        lblCard.text = edCard
        lblexpDate.text = expiryDate
        // Do any additional setup after loading the view.
        
        if let mobileNo = defaults.stringForKey("mobileNo")
        {
            print("The user has a mobile number defined " + mobileNo)
        }
    }

    override func viewWillAppear(animated: Bool) {
        SwiftSpinner.showWithDuration(2.0, title: "Loading...", animated: true)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print("view did appear")
        Alamofire.request(.POST, appendStringGetCustomerOperations, parameters: ["DeviceReferenceID":DeviceReferenceID,"PAN":edCard, "ServiceType":1])
            .responseJSON { response in
                
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                let JSON = response.result.value
                let string: NSString = JSON as! NSString
                print("string is " + (string as String))
                
                if string.containsString("off")
                {
                    self.switchState = 0
                    self.switchEdCard.on = false
                }
                else
                {
                    self.switchState = 1
                    self.switchEdCard.on = true
                }
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func submitEDCard(PAN: String, ATMValue : NSInteger, ServiceType: NSInteger)
    {
        Alamofire.request(.POST, appendStringSetCustomerOperations, parameters: ["DeviceReferenceID":DeviceReferenceID,"PAN":PAN, "ATMValue":switchState, "ServiceType":ServiceType])
            .responseJSON { response in
                
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                let JSON = response.result.value
                let string: NSString = JSON as! NSString
                print("string is " + (string as String))
        }
    }
    func SwitchEdCard() {
        print("ATMValue is  :" ,switchState)
        submitEDCard(edCard, ATMValue: switchState, ServiceType: 1)
        if switchState == 0 {
            let Alert: UIAlertView = UIAlertView()
            Alert.delegate = self
            Alert.title = "Raksha"
            Alert.message = "Card Disabled successfully."
            Alert.addButtonWithTitle("OK")
            Alert.show()
        }
        else
        {
            let Alert: UIAlertView = UIAlertView()
            Alert.delegate = self
            Alert.title = "Raksha"
            Alert.message = "Card Enabled successfully."
            Alert.addButtonWithTitle("OK")
            Alert.show()
        }
    }
    func TransactionPwd() {
        let alert = UIAlertController(title: "Raksha", message: "Transaction Password", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Send", style: UIAlertActionStyle.Default, handler: {(actionSheetController) -> Void in
            self.SwitchEdCard()}))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        
        
        alert.addTextFieldWithConfigurationHandler({(TxtTansactionPwd: UITextField!) in
            TxtTansactionPwd.placeholder = "Enter your trnsaction Password"
            TxtTansactionPwd.minimumFontSize = 12
            TxtTansactionPwd.secureTextEntry = true
            TxtTansactionPwd.textColor = UIColor.blackColor()
            
        })
        
        alert.view.backgroundColor = UIColor.grayColor()
        alert.view.layer.cornerRadius = 10
        self.presentViewController(alert, animated: true, completion: nil)

        
    }

    @IBAction func btnSubmitEDCardStatus(sender: AnyObject) {
        TransactionPwd() 
           }

    @IBAction func switchEdCard(sender: AnyObject)
    {
        if(switchEdCard.on){
            print("ONNNNN")
            switchState = 1
            print(switchState)
            let alert = UIAlertController(title: "RAKSHA", message: "To Confirm, press SUBMIT to enable the card!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
            // show the alert
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else
        {
            print("OFFFFFF")
            switchState = 0
            print(switchState)
            let alert = UIAlertController(title: "RAKSHA", message: "To Confirm, press SUBMIT to disable the card!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
            // show the alert
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
   
    @IBAction func btnBackEDCar(sender: AnyObject) {
        let next = self.storyboard?.instantiateViewControllerWithIdentifier("dashboardVC") as! DashboardViewController
        self.presentViewController(next, animated: true, completion: nil)
    }
    
    
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

    @IBAction func btnLogOutEDCard(sender: AnyObject) {
        logOutTapped(defaults.stringForKey("mobileNo")!)
      
    }
    
}
