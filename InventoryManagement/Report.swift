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
    
    func parseDeviceReport (data: NSData?) -> NSMutableArray{
        deviceReportList = NSMutableArray() 
        do{
            let jsonObject = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! NSDictionary
            if(jsonObject["result"] != nil) {
            let resultObject : NSDictionary = jsonObject["result"] as! NSDictionary
            
            if let reportObjects  = resultObject["deviceReportDtoList"] as? [[String: AnyObject]]  {
                deviceReportList = NSMutableArray()
                for reportObj in reportObjects{
                    let deviceReport = DeviceReport()
                
                    
                    deviceReport.inTime = reportObj["loginTIme"] as? String
                    deviceReport.outTime = reportObj["logOutTime"] as? String
                    if(deviceReport.outTime == nil){
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
    }
        return deviceReportList
}
    
}
