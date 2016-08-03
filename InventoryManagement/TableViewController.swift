//
//  ReportViewController.swift
//  InventoryManagement
//
//  Created by impadmin on 27/07/16.
//  Copyright © 2016 Impetus. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
     var deviceReportList: NSMutableArray!
    @IBOutlet weak var uppperView: UIView!
    
    @IBOutlet var homeButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        uppperView.layer.borderColor = UIColor.blackColor().CGColor
//        deviceReportList = NSMutableArray()
//        
//        let deviceReport = DeviceReport()
//        
//        deviceReport.inTime = "12:00 AM"
//        deviceReport.outTime = "12:30 AM"
//        
//        deviceReport.userName = "Raja Pateriya"
//        
//        deviceReportList.addObject(deviceReport)
//        
//        let deviceReport2 = DeviceReport()
//        
//        deviceReport2.inTime = "12:40 AM"
//        deviceReport2.outTime = "12:55 AM"
//        
//        deviceReport2.userName = "Himanshu"
//        
//        deviceReportList.addObject(deviceReport2)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return deviceReportList.count
    }
    
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ReportCell", forIndexPath: indexPath) as! ReportCell
        let reportData = deviceReportList.objectAtIndex(indexPath.row) as! DeviceReport
        
        cell.inLabel?.text = String(reportData.inTime!)
        cell.nameLabel?.text = reportData.userName!
        if(reportData.outTime == 0) {
             cell.ouLabel?.text = ""
        } else {
        cell.ouLabel?.text = String(reportData.outTime!)
        }
//            cell.textLabel?.text = "raja"
     
        return cell
    }
 
    
    @IBAction func homeButtonPressed(sender: AnyObject?) {
     self.performSegueWithIdentifier("idSegueHome", sender: self)
    }
}