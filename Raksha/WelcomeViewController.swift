//
//  WelcomeViewController.swift
//  Raksha
//
//  Created by Admin on 17/06/16.
//  Copyright © 2016 maximus. All rights reserved.
//

import UIKit
import SwiftSpinner

class WelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        SwiftSpinner.showWithDuration(2.0, title: "Loading....", animated: false)

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
    

    @IBAction func btnProceedClicked(sender: AnyObject) {
        SwiftSpinner.showWithDuration(2.0, title: "Loading....", animated: true)
        let next = self.storyboard?.instantiateViewControllerWithIdentifier("LoginVC") as! LoginViewController
        self.presentViewController(next, animated: true, completion: nil)
    }
    
    @IBAction func btnExitClicked(sender: AnyObject) {
        let next = self.storyboard?.instantiateViewControllerWithIdentifier("registrationVC") as! RegistrationViewController
        self.presentViewController(next, animated: true, completion: nil)

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
