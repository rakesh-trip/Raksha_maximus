//
//  EDCardViewController.swift
//  Raksha
//
//  Created by Admin on 17/06/16.
//  Copyright © 2016 maximus. All rights reserved.
//

import UIKit
import Alamofire

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
        
        
        Alamofire.request(.POST, "http://125.99.113.202:8777/GetCustomerOperations", parameters: ["DeviceReferenceID":DeviceReferenceID,"PAN":edCard, "ServiceType":1])
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func submitEDCard(PAN: String, ATMValue : NSInteger, ServiceType: NSInteger)
    {
        Alamofire.request(.POST, "http://125.99.113.202:8777/SetCustomerOperations", parameters: ["DeviceReferenceID":DeviceReferenceID,"PAN":PAN, "ATMValue":switchState, "ServiceType":ServiceType])
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

    @IBAction func btnSubmitEDCardStatus(sender: AnyObject) {
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
   
}