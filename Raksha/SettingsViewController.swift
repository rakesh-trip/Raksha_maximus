//
//  SettingsViewController.swift
//  Raksha
//
//  Created by Maximus Imac 2 on 21/07/16.
//  Copyright © 2016 maximus. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

class SettingsViewController: UIViewController, MFMailComposeViewControllerDelegate
 {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
            func configuredMailComposeViewController() -> MFMailComposeViewController {
            let mailComposerVC = MFMailComposeViewController()
            mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
            
            mailComposerVC.setToRecipients(["rakesh.tripathi@maximusinfoware.in"])
                mailComposerVC.setCcRecipients(["nidhi.tripathi@maximusinfoware.in"])
            mailComposerVC.setSubject("Sending you an in-app e-mail...")
            mailComposerVC.setMessageBody("Sending e-mail in-app is not so bad!", isHTML: false)
            
            return mailComposerVC
        }
        
        func showSendMailErrorAlert() {
            let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
            sendMailErrorAlert.show()
        }
        
        // MARK: MFMailComposeViewControllerDelegate Method
        func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
            controller.dismissViewControllerAnimated(true, completion: nil)
        }

    @IBAction func btnFeedbackClicked(sender: AnyObject)
    {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
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
  
    
}

