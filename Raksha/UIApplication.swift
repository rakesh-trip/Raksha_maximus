//
//  UIApplication.swift
//  Raksha
//
//  Created by Maximus Imac on 06/07/16.
//  Copyright © 2016 maximus. All rights reserved.
//

import UIKit

@objc(MyApplication)

class MyApplication: UIApplication {
    
    override func sendEvent(event: UIEvent) {
        
        // Ignore .Motion and .RemoteControl event simply everything else then .Touches
        if event.type != .Touches {
            super.sendEvent(event)
            
            return
            
            
        }
        
        // .Touches only
        var restartTimer = true
        if let touches = event.allTouches() {
            // At least one touch in progress? Do not restart timer, just invalidate it
            for touch in touches.enumerate() {
                if touch.element.phase != .Cancelled && touch.element.phase != .Ended {
                    restartTimer = false
                    break
                }
                
            }
        }
        
        if restartTimer {
            // Touches ended || cancelled, restart timer
//            print("Touches ended. Restart timer")
        } else {
            // Touches in progress - !ended, !cancelled, just invalidate it
//            print("Touches in progress. Invalidate timer")
        }
        
        super.sendEvent(event)
    }
}