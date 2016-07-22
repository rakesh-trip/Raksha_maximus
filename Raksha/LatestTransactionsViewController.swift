//
//  LatestTransactionsViewController.swift
//  Raksha
//
//  Created by Admin on 18/06/16.
//  Copyright © 2016 maximus. All rights reserved.
//

import UIKit
import Alamofire

class LatestTransactionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let Response = NSMutableArray()
    var edCard:String!
    var expiryDate:String!
    var userName:String!
    
    @IBOutlet weak var lblCardNo: UILabel!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        lblCardNo.text = edCard
//        getJSON(edCard, ServiceType: 4)
        getJSON(lblCardNo.text!, ServiceType: 4)

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
        
        dispatch_async(dispatch_get_main_queue()) {
            self.tableView.reloadData()
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    func getJSON(PAN:String, ServiceType : NSInteger) {
        let urlStr = "http://125.99.113.202:8777/SetCustomerOperations"
        
     Alamofire.request(.POST, urlStr, parameters: ["PAN":PAN, "ServiceType":ServiceType]).responseJSON { response in
            print(response.request)  // original URL request
            print(response.response) // URL response
            print(response.data)     // server data
            print(response.result) // result of response serialization
            
            let JSON = response.result.value
            let string: String = JSON as! String
            print("string is " + string)
            
            let result = self.convertStringToDictionary(string)
            print(result)
            
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
        
        let transDate : NSString = Response[indexPath.row] .valueForKey("TransactionDateTime") as! NSString
        let transAmt : NSString=Response[indexPath.row] .valueForKey("STRRECORDS") as! NSString
        
        cell.lblTransDate.text = transDate as String
        
        cell.lblTransAmt.text = transAmt as String
        
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

    
    @IBAction func btnBackLatesTrans(sender: AnyObject) {
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
                else
                {
                    print("Logout failed")
                }
        }
    }

    @IBAction func btnLogoutLtstTrans(sender: AnyObject) {
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
