//
//  SelectCardViewController.swift
//  Raksha
//
//  Created by Admin on 17/06/16.
//  Copyright © 2016 maximus. All rights reserved.
//

import UIKit
import Alamofire
import SwiftSpinner

class SelectCardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let Response = NSMutableArray()
    
    var sendSelectedCard = NSString()
    var sendexpDate = NSString()
    var sendUserName = NSString()
    
    //MARK: Variable Declaration
    var ButtonOptionClicked = ""
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SwiftSpinner.showWithDuration(5.0, title: "Loading....", animated: true)

        print("ButtonOptionClicked in viewDidLoad of SelectCard is  : " + ButtonOptionClicked)
        tableView.delegate = self
        tableView.dataSource = self
        if let mobileNo = defaults.stringForKey("mobileNo")
        {
            print("The user has a mobile number defined " + mobileNo)
        }
        getJSON(defaults.stringForKey("mobileNo")!)
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
            tap.cancelsTouchesInView=false
        
        dispatch_async(dispatch_get_main_queue()) {
            self.tableView.reloadData()
        }
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(animated: Bool) {
        SwiftSpinner.showWithDuration(3.0, title: "Loading....", animated: true)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    func convertStringToDictionary(text: String) -> NSDictionary? {
        if let data = text.dataUsingEncoding(NSUTF8StringEncoding) {
            do {
                return try NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSDictionary
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
    
    func getJSON(MobileNumber:String) {
        
        let urlStr = "http://125.99.113.202:8777/LoadCustomerData"

        Alamofire.request(.POST, urlStr, parameters: ["MobileNumber":MobileNumber]).responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
            
            let JSON = response.result.value
            let string: String = JSON as! String
            print("string is " + string)

            let result = self.convertStringToDictionary(string)
            print("resultedDict is  ", result)
            
            for i in 0  ..< (result!.valueForKey("Response") as! NSArray).count
            {
                self.Response.addObject((result!.valueForKey("Response") as! NSArray) .objectAtIndex(i))
            }
            self.tableView.reloadData()
            }
               // Do any additional setup after loading the view, typically from a nib.
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("numberOfRowsInSection gives * * * * * * * * ",  Response.count)
        return Response.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        print("cellForRowAtIndexPath gives  a good feeling")

        let cell : CustomCell! = tableView.dequeueReusableCellWithIdentifier("cell") as! CustomCell
        print("\(indexPath)")
    
        let strTitle : NSString = Response[indexPath.row] .valueForKey("CustomerName") as! NSString
        let strTitle2 : NSString=Response[indexPath.row] .valueForKey("CardNumber") as! NSString
        let strTitle3 : NSString = Response[indexPath.row] .valueForKey("CardExpiry") as! NSString
        
        cell.lblName.text = strTitle as String
        cell.lblCard.text = strTitle2.description
        cell.lblexpDate.text = strTitle3 as String
        
        cell.contentView.backgroundColor = UIColor.lightTextColor()
        
        let RoundedView : UIView = UIView(frame: CGRectMake(10, 8, self.view.frame.size.width - 20, 149))
        
        RoundedView.layer.backgroundColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [1.0, 1.0, 1.5, 0.2])

        RoundedView.layer.masksToBounds = false
        RoundedView.layer.cornerRadius = 2.0
        RoundedView.layer.shadowOffset = CGSizeMake(-1, 1)
        RoundedView.layer.shadowOpacity = 0.9
        
        cell.contentView.addSubview(RoundedView)
        cell.contentView.sendSubviewToBack(RoundedView)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //Add cases here to move to different segues
        print("didSelectRowAtIndexPath")
        let indexPath: NSIndexPath = self.tableView.indexPathForSelectedRow!
        
        let row = indexPath.row
        print("Row: \(row)")
        
        let currentCell = tableView.cellForRowAtIndexPath(indexPath) as! CustomCell!;
        
        //Storing the data to a string from the selected cell
        sendSelectedCard = currentCell.lblCard.text!
        sendexpDate = currentCell.lblexpDate.text!
        sendUserName = currentCell.lblName.text!
        
        if (ButtonOptionClicked == "EDCard"){
            performSegueWithIdentifier("edCard", sender: self)
        }
        else if (ButtonOptionClicked == "SpendLimit"){
            performSegueWithIdentifier("spendLimit", sender: self)
        }
            
        else if(ButtonOptionClicked == "LatestTransaction")
        {
            performSegueWithIdentifier("ltstTrans", sender: self)
        }
        else if(ButtonOptionClicked == "ChannelControl"){
            performSegueWithIdentifier("edChannel", sender: self)
        }
        else{
            print("test hello world!!!!!!")
        }
    }
    
        override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("buttonclicked is  : " + ButtonOptionClicked)
        if (ButtonOptionClicked == "EDCard")
        {
            let enDbCard = segue.destinationViewController as! EDCardViewController
            enDbCard.edCard = sendSelectedCard as String
            enDbCard.expiryDate = sendexpDate as String
            enDbCard.userName = sendUserName as String
        }
            
        else if ButtonOptionClicked == "SpendLimit" {
            let enDbCard = segue.destinationViewController as! SpendLimitViewController
            enDbCard.edCard = sendSelectedCard as String
            enDbCard.expiryDate = sendexpDate as String
            enDbCard.userName = sendUserName as String
        }
        else if ButtonOptionClicked == "LatestTransaction" {
            let enDbCard = segue.destinationViewController as! LatestTransactionsViewController
            enDbCard.edCard = sendSelectedCard as String
            enDbCard.expiryDate = sendexpDate as String
            enDbCard.userName = sendUserName as String
        }
            
        else if ButtonOptionClicked == "ChannelControl" {
            let enDbCard = segue.destinationViewController as! EDChannelViewController
            enDbCard.edCard = sendSelectedCard as String
            enDbCard.expiryDate = sendexpDate as String
            enDbCard.userName = sendUserName as String
        }

        else
        {
            print("please check your code")
        }
    }

    
}
