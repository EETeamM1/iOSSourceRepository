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
    
    var code : Int!
    var message : String = ""
    
    func parseLogon (data: NSData?){
        
        do{
            let jsonObject = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! NSDictionary
            let resultObject : NSDictionary = jsonObject["result"] as! NSDictionary
            sessionToken = resultObject["sessionToken"] as! String
            timeout = resultObject["timeout"] as! Int
            masterPassword = resultObject["masterPassword"] as! String
            
            let responseCodeObject : NSDictionary = jsonObject["responseCode"] as! NSDictionary
            code = responseCodeObject["code"] as! Int
            message = responseCodeObject["message"] as! String
            
            
        }catch let error as NSError {
            print(error)
        }
    }
    
    func writeLogon (username :NSString?, withPassword password:NSString?, withSerial serial:String, AndWithLocation location :CLLocation ) -> NSString{

        let deviceId : NSString = serial
        let osversion : NSString = getOSversion()
        var string: NSString = NSString(format: "{ \"parameters\": {\"userId\": \"%@\", \"password\": \"%@\", \"deviceId\": \"%@\", \"osVersion\": \"%@\"", username!, password!, deviceId, osversion)

        if (location.coordinate.longitude != 0 && location.coordinate.latitude != 0 ){
             string = NSString(format: (string as String) + ", \"latitude\": \"\(location.coordinate.latitude)\", \"longitude\": \"\(location.coordinate.longitude)\"" )
        }
        string = (string as String) + "}}"
        
        return NSString(string: string)
    }
    
    func writeLogout () -> NSString{
        return NSString(format: "{ \"parameters\": {\"sessionToken\" :\"%@\" }}", self.sessionToken)
    }
    
    func getOSversion () ->NSString{
        return UIDevice.currentDevice().systemVersion
    }

}