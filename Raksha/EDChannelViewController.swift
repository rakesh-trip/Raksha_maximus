//
//  EDChannelViewController.swift
//  Raksha
//
//  Created by Admin on 17/06/16.
//  Copyright © 2016 maximus. All rights reserved.
//

import UIKit
import Alamofire

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
        
        Alamofire.request(.POST, "http://125.99.113.202:8777/GetCustomerOperations", parameters: ["DeviceReferenceID":DeviceReferenceID,"PAN":edCard, "ServiceType":2])
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
        Alamofire.request(.POST, "http://125.99.113.202:8777/SetCustomerOperations", parameters: ["DeviceReferenceID":DeviceReferenceID,"PAN":PAN, "ATMValue":switchStateATM, "POSValue":switchStatePOS, "ECMValue":switchStateECM, "ServiceType":ServiceType])
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

    
    @IBAction func btnSubmitEDChannel(sender: AnyObject)
    {
        submitEDChannel(edCard, ATMValue: switchStateATM, POSValue: switchStatePOS, ECMvalue: switchStateECM, ServiceType: 2)
    }
    
    @IBAction func btnCancelEDChannel(sender: AnyObject)
    {
        switchATM.on = false
        switchPOS.on = false
        switchOnline.on = false
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
