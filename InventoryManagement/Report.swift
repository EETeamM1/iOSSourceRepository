//
//  Report.swift
//  InventoryManagement
//
//  Created by Himanshu Bapna on 26/07/16.
//  Copyright © 2016 Impetus. All rights reserved.
//

import Foundation

class Report{
    
    var deviceReportList: NSMutableArray!
    
    func parseDeviceReport (data: NSData?)  throws -> NSMutableArray {
        deviceReportList = NSMutableArray() 
        do{
            let jsonObject = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! NSDictionary
            if(jsonObject["result"] != nil) {
            let resultObject : NSDictionary = jsonObject["result"] as! NSDictionary
            
            if let reportObjects  = resultObject["deviceReportDtoList"] as? [[String: AnyObject]]  {
                deviceReportList = NSMutableArray()
                for reportObj in reportObjects{
                    let deviceReport = DeviceReport()
                
                    
                    let inTimeLong = reportObj["loginTIme"] as? NSNumber
                    
                    
                    deviceReport.inTime = convertLongToString(inTimeLong!)
                    if (reportObj["logOutTime"] != nil) {
                    let outTimeLong = reportObj["logOutTime"] as? NSNumber
                        deviceReport.outTime = convertLongToString(outTimeLong!)
                    } else {
                        
                        deviceReport.outTime = ""
                    }
                    deviceReport.userId = reportObj["userId"] as? String
                    deviceReport.userName = reportObj["userName"] as? String
                    deviceReportList.addObject(deviceReport)
                }
            }
         }
            
        }catch let error as NSError {
             NSLog("Did fail to parse device report with error %@", error);
            throw error
    }
        return deviceReportList
}
    
    
    
    func  convertLongToString(time:NSNumber) -> String {
        let inTimeMilliSec = NSTimeInterval(time)/1000
        let formatter = NSDateFormatter()
        formatter.dateFormat = "h:mm a"
        formatter.AMSymbol = "AM"
        formatter.PMSymbol = "PM"
        let date = NSDate(timeIntervalSince1970: inTimeMilliSec)
        return formatter.stringFromDate(date);
        
        
    }
    
}
