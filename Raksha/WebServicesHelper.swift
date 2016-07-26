//
//  WebServicesHelper.swift
//  Raksha
//
//  Created by Admin on 22/06/16.
//  Copyright © 2016 maximus. All rights reserved.
//

import Foundation
import UIKit
//This class is not used now in the project, will try later

@objc protocol webServiceDelegate
{
    
}


private let sharedKraken = WebserviceClass()


class WebserviceClass: NSObject
{
    
    let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
       var delegates : webServiceDelegate?
    var appdelegate:AppDelegate!
    
    class var sharedInstance: WebserviceClass {
        return sharedKraken
        
        
    }

}