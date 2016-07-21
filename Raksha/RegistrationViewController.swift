//
//  ViewController.swift
//  Raksha
//
//  Created by Admin on 14/06/16.
//  Copyright © 2016 maximus. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController{

    @IBOutlet weak var lblSignUp: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let string1 = "This is ";
        let string2 = "Swift Language";
        let appendString = string1 + string2;
        print("APPEND STRING: \(appendString)");
        // Do any additional setup after loading the view, typically from a nib.
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
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
         }

  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func btnSignUp(sender: AnyObject) {
//        lblSignUp.backgroundColor = UIColor .greenColor()
    
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

    @IBAction func btnSignIn(sender: AnyObject) {
        
//        lblSignUp.backgroundColor = UIColor .greenColor()
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
}


