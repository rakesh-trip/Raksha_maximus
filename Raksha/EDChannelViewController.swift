//
//  EDChannelViewController.swift
//  Raksha
//
//  Created by Admin on 17/06/16.
//  Copyright © 2016 maximus. All rights reserved.
//

import UIKit
import Alamofire
import SwiftSpinner


let wsMethodGetCustomerOperationsEDChannel = "GetCustomerOperations"
let appendStringGetCustomerOperationsEDChannel = baseUrl + wsMethodGetCustomerOperationsEDChannel

let wsMethodSetCustomerOperationsEDChannel = "SetCustomerOperations"
let appendStringSetCustomerOperationsEDChannel = baseUrl + wsMethodSetCustomerOperationsEDChannel


class EDChannelViewController: UIViewController {

    let Response = NSMutableArray()
    var edCard:String!
    var expiryDate:String!
    var userName:String!
    var switchState:NSInteger = NSInteger()
    
    var switchStateATM:NSInteger = NSInteger()
    var switchStatePOS:NSInteger = NSInteger()
    var switchStateECM:NSInteger = NSInteger()

    
    @IBOutlet weak var lblCardno: UILabel!
    
    @IBOutlet weak var lblATM: UILabel!
    @IBOutlet weak var lblPOS: UILabel!
    @IBOutlet weak var lblOnline: UILabel!
    
    
    @IBOutlet weak var switchATM: UISwitch!
    @IBOutlet weak var switchPOS: UISwitch!
    @IBOutlet weak var switchOnline: UISwitch!
    
        override func viewDidLoad()
    {
        super.viewDidLoad()
        
        Alamofire.request(.POST, appendStringGetCustomerOperationsEDChannel, parameters: ["DeviceReferenceID":DeviceReferenceID,"PAN":edCard, "ServiceType":2])
            .responseJSON { response in
                
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                let JSON = response.result.value
                let string: NSString = JSON as! NSString
                print("string is " + (string as String))
                let result :NSDictionary = self.convertStringToDictionary(string as String)!
                print(result)
                
                for i in 0  ..< (result.valueForKey("Response") as! NSArray).count
                {
                    self.Response.addObject((result.valueForKey("Response") as! NSArray) .objectAtIndex(i))

//                {"Response":[{"ATM":"on","POS":"on","ECM":"on"}]}
                
           let ATMstatus = self.Response.valueForKey("ATM")
     
                    if ATMstatus.description.containsString("on")
                {
                    self.switchStateATM = 1
                    self.switchATM.on = true
                }
                else
                {
                    self.switchStateATM = 0
                    self.switchATM.on = false
                }
                    
                    let POSStatus = self.Response.valueForKey("POS")
                    
                    if POSStatus.description.containsString("on")
                    {
                        self.switchStatePOS = 1
                        self.switchPOS.on = true
                    }
                    else
                    {
                        self.switchStatePOS = 0
                        self.switchPOS.on = false
                    }
                    
                    let ECMStatus = self.Response.valueForKey("ECM")
                    
                    if ECMStatus.description.containsString("on")
                    {
                        self.switchStateECM = 1
                        self.switchOnline.on = true
                    }
                    else
                    {
                        self.switchStateECM = 0
                        self.switchOnline.on = false
                    }
            }

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
    
        
        if let mobileNo = defaults.stringForKey("mobileNo")
        {
            print("The user has a mobile number defined " + mobileNo)
        }
        lblCardno.text=edCard
        // Do any additional setup after loading the view.
    }

    func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.dataUsingEncoding(NSUTF8StringEncoding) {
            do {
                return try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String:AnyObject]
            } catch let error as NSError {
                print("error is " , error)
            }
        }
        return nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func switchATMClicked(sender: AnyObject)
    {
        if(switchATM.on == true){
            print("ONNNNN")
            switchStateATM = 1
            print(switchStateATM)
           
        }
        else
        {
            print("OFFFFFF")
            switchStateATM = 0
        }

    }
    
    @IBAction func switchPOSClicked(sender: AnyObject) {
        if(switchPOS.on == true){
            print("ONNNNN")
            switchStatePOS = 1
            print(switchStatePOS)
            
        }
        else
        {
            print("OFFFFFF")
            switchStatePOS = 0
        }

    }
    
    @IBAction func switchOnlineClicked(sender: AnyObject) {
        if(switchOnline.on == true){
            print("ONNNNN")
            switchStateECM = 1
            print(switchStateECM)
            
        }
        else
        {
            print("OFFFFFF")
            switchStateECM = 0
        }
    }
    
    func submitEDChannel(PAN: String, ATMValue : NSInteger, POSValue:NSInteger, ECMvalue:NSInteger, ServiceType: NSInteger)
    {
        Alamofire.request(.POST, appendStringSetCustomerOperationsEDChannel, parameters: ["DeviceReferenceID":DeviceReferenceID,"PAN":PAN, "ATMValue":switchStateATM, "POSValue":switchStatePOS, "ECMValue":switchStateECM, "ServiceType":ServiceType])
            .responseJSON { response in
                
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                let JSON = response.result.value
                let string: NSString = JSON as! NSString
                print("string is " + (string as String))
                if string.containsString("Successful")
                {
                    let alert = UIAlertController(title: "RAKSHA", message: "Request succesful", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
                    // show the alert
                    self.presentViewController(alert, animated: true, completion: nil)
//                    SwiftSpinner.showWithDuration(2.0, title: "Request Sent.", animated: false)
                }
                else
                {
                    let alert = UIAlertController(title: "RAKSHA", message: "Failed, please try again later.", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
                    // show the alert
                    self.presentViewController(alert, animated: true, completion: nil)
                }
        }
    }
    
    
    func TransactionPwd() {
        let alert = UIAlertController(title: "Raksha", message: "Transaction Password", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Send", style: UIAlertActionStyle.Default, handler: {(actionSheetController) -> Void in
            self.submitEDChannel(self.edCard, ATMValue: self.switchStateATM, POSValue: self.switchStatePOS, ECMvalue: self.switchStateECM, ServiceType: 2)
            switch actionSheetController.style{
            case .Default:
                print("Send")
            default : print("Default")
            }
        }))
        
        alert.addAction(UIAlertAction (title: "Cancel", style: .Destructive, handler: nil))
        
        //        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: {(actionSheetController) -> Void in self.submitEDCard(self.edCard, ATMValue: self.switchState, ServiceType: 1)}))
        
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
    
    @IBAction func btnSubmitEDChannel(sender: AnyObject)
    {
        TransactionPwd()
            }
    
    @IBAction func btnCancelEDChannel(sender: AnyObject)
    {
        switchATM.on = false
        switchPOS.on = false
        switchOnline.on = false
    }

    @IBAction func btnBackEDChannel(sender: AnyObject) {
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

    
    @IBAction func btnLogoutEDchannel(sender: AnyObject) {
        logOutTapped(defaults.stringForKey("mobileNo")!)
     
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
