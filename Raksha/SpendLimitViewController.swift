
//
//  SpendLimitViewController.swift
//  Raksha
//
//  Created by Admin on 17/06/16.
//  Copyright © 2016 maximus. All rights reserved.
//

import UIKit
import Alamofire

class SpendLimitViewController: UIViewController, UITextFieldDelegate {
    
    let Response = NSMutableArray()
    let prefs = NSUserDefaults.standardUserDefaults()
    var edCard:String!
    var expiryDate:String!
    var userName:String!
    var switchStateATM:NSInteger = NSInteger()
    var switchStatePOS:NSInteger = NSInteger()
    var switchStateONLINE:NSInteger = NSInteger()

    let bounds = UIScreen.mainScreen().bounds

    
    @IBOutlet weak var txtATM: UITextField!
    @IBOutlet weak var txtPOS: UITextField!
    @IBOutlet weak var txtECM: UITextField!

    @IBOutlet weak var switchATMLimit: UISwitch!
    @IBOutlet weak var switchPOSLimit: UISwitch!
    @IBOutlet weak var switchOnlineLimit: UISwitch!

    @IBOutlet weak var lblCardNo: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtATM.delegate = self
        txtPOS.delegate = self
        txtECM.delegate = self
//        self.addDoneButtonOnKeyboard()

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
        
        Alamofire.request(.POST, "http://125.99.113.202:8777/GetWdlLimit", parameters: ["DeviceReferenceID":DeviceReferenceID,"PAN":edCard])
            .responseJSON { response in
                
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                let JSON = response.result.value
                let string: String = JSON as! String
                
                let result :NSDictionary = self.convertStringToDictionary(string)!
                print(result)
            
                for i in 0  ..< (result.valueForKey("Response") as! NSArray).count
                {
                    self.Response.addObject((result.valueForKey("Response") as! NSArray) .objectAtIndex(i))
                    let badchar: NSCharacterSet = NSCharacterSet(charactersInString:"()")

                    let atmValue = self.Response.valueForKey("ATM")
                    let cleanedstringATM: NSString = (atmValue.description.componentsSeparatedByCharactersInSet(badchar) as NSArray).componentsJoinedByString("")
                    print(cleanedstringATM)
                    self.txtATM.text = cleanedstringATM as String
                    self.txtATM.text = self.txtATM.text!.stringByReplacingOccurrencesOfString(" ", withString: "")
                    
                    let ecmValue = self.Response.valueForKey("ECM")
                    let cleanedstringECM: NSString = (ecmValue.description.componentsSeparatedByCharactersInSet(badchar) as NSArray).componentsJoinedByString("")
                    print(cleanedstringECM)
                    self.txtECM.text = cleanedstringECM as String
                    self.txtECM.text = self.txtECM.text!.stringByReplacingOccurrencesOfString(" ", withString: "")

                    let posValue = self.Response.valueForKey("POS")
                    let cleanedstringPOS: NSString = (posValue.description.componentsSeparatedByCharactersInSet(badchar) as NSArray).componentsJoinedByString("")
                    print(cleanedstringPOS)
                    self.txtPOS.text = cleanedstringPOS as String
                    self.txtPOS.text = self.txtPOS.text!.stringByReplacingOccurrencesOfString(" ", withString: "")
                }
        }
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        if let mobileNo = defaults.stringForKey("mobileNo")
        {
            print("The user has a mobile number defined " + mobileNo)
        }
        
        lblCardNo.text = edCard
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        txtATM.resignFirstResponder()
        txtPOS.resignFirstResponder()
        txtECM.resignFirstResponder()
        return true
    }
    
    func submitSpendLimit(PAN: String, ATMLimit : String, POSLimit : String, ECMLimit:String)
    {
        Alamofire.request(.POST, "http://125.99.113.202:8777/SetWdlLimit", parameters: ["DeviceReferenceID":DeviceReferenceID,"PAN":PAN, "ATMLimit":ATMLimit, "POSLimit":POSLimit, "ECMLimit":ECMLimit])
            .responseJSON { response in
                
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                let JSON = response.result.value
                print(JSON)
                let string: NSString = JSON as! NSString
                print("string is " + (string as String))
        }
    }

    
    @IBAction func limitATMSwitch(sender: AnyObject)
    {
        if(switchATMLimit.on){
            print("ONNNNN")
            switchStateATM = 1
            print(switchStateATM)
            let alert = UIAlertController(title: "RAKSHA", message: "To Confirm, press SUBMIT to enable this amount for your ATM transactions!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
            // show the alert
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else
        {
            print("OFFFFFF")
            switchStateATM = 0
            print(switchStateATM)
            txtATM.text = ""
            let alert = UIAlertController(title: "RAKSHA", message: "Transaction Amount will be set to default as regulated by the bank.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
            // show the alert
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
   
    
    
    @IBAction func limitPOSSwitch(sender: AnyObject) {
        if(switchPOSLimit.on){
            print("ONNNNN")
            switchStatePOS = 1
            print(switchStatePOS)
            let alert = UIAlertController(title: "RAKSHA", message: "To Confirm, press SUBMIT to set this amount for your POS transactions!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
            // show the alert
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else
        {
            print("OFFFFFF")
            switchStatePOS = 0
            print(switchStatePOS)
            txtPOS.text = ""
            print(txtPOS.text)
            let alert = UIAlertController(title: "RAKSHA", message: "Transaction Amount will be set to default as regulated by the bank.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
            // show the alert
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func limitOnlineSwitch(sender: AnyObject) {
        if(switchOnlineLimit.on){
            print("ONNNNN")
            switchStateONLINE = 1
            print(switchStateONLINE)
            let alert = UIAlertController(title: "RAKSHA", message: "To Confirm, press SUBMIT to set this amount for your Online transactions!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
            // show the alert
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else
        {
            print("OFFFFFF")
            switchStateONLINE = 0
            txtECM.text! = ""
            print(txtECM.text!)
            let alert = UIAlertController(title: "RAKSHA", message: "Transaction Amount will be set to default as regulated by the bank.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
            // show the alert
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnSubmitLimit(sender: AnyObject) {
       submitSpendLimit(edCard, ATMLimit: txtATM.text!, POSLimit:txtPOS.text!, ECMLimit: txtECM.text!)
        print(txtATM.text)
    }
    
    @IBAction func btnCancelLimit(sender: AnyObject) {
        txtECM.text = ""
        txtATM.text = ""
        txtPOS.text = ""
    }

    /*
       // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, self.view.frame.size.width, 40))
        doneToolbar.barStyle = UIBarStyle.Default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: #selector(SpendLimitViewController.doneButtonAction))
        
        var items: [UIBarButtonItem]? = [UIBarButtonItem]()
        items?.append(flexSpace)
        items?.append(done)
        
        
        doneToolbar.setItems(items, animated: true)
        doneToolbar.sizeToFit()
        txtATM.inputAccessoryView=doneToolbar
        txtPOS.inputAccessoryView=doneToolbar
        txtECM.inputAccessoryView=doneToolbar

    }
    
    func doneButtonAction()
    {
        let width = bounds.size.width
        if(width <= 320.0)
        {
            UIView.animateWithDuration(0.2, delay: 0, options: .CurveEaseOut, animations:
                {
                    self.view.frame = CGRectMake(self.view.frame.origin.x, 0 , self.view.frame.width, self.view.frame.height)
                }, completion: { finished in
            })
        }
        else
        {
        }
        txtATM.resignFirstResponder()
        txtPOS.resignFirstResponder()
        txtECM.resignFirstResponder()

    }

    
}
