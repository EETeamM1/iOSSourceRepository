//
//  ParseLogon.swift
//  InventoryManagement
//
//  Created by Himanshu Bapna on 10/06/16.
//  Copyright © 2016 Impetus. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

class Logon{
    
    var sessionToken : String = ""
    var timeout : Int = 30
    var masterPassword : String = ""
    
    func parseLogon (data: NSData?){
        
        do{
            let jsonObject = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! NSDictionary
            sessionToken = jsonObject["sessionToken"] as! String
            timeout = jsonObject["timeout"] as! Int
            masterPassword = jsonObject["masterPassword"] as! String
            
        }catch let error as NSError {
            print(error)
        }
    }
    
    func writeLogon (username :NSString?, withPassword password:NSString?, AndWithLocation location :CLLocation? ) -> NSString{

        let deviceId : NSString = "12345655474255"
        let osversion : NSString = UIDevice.currentDevice().systemVersion;
        var string: NSString = NSString(format: "{ \"parameters\": {\"userId\" :%@, \"password\": %@, \"deviceId\": %@, \"osVersion\": %@", username!, password!, deviceId, osversion)
        
        if location != nil {
            string = NSString(format: (string as String) + "\"latitude\" :%@, \"longitude\": %@,", (location?.coordinate.latitude)!, (location?.coordinate.longitude)!)
        }
        
        string = (string as String) + "}}"
        
        return NSString(string: string)
        
    }
}