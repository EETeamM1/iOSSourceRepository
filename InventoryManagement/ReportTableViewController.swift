//
//  ReportViewController.swift
//  InventoryManagement
//
//  Created by impadmin on 27/07/16.
//  Copyright © 2016 Impetus. All rights reserved.
//

import UIKit

class ReportTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
     var deviceReportList: NSMutableArray!
    @IBOutlet weak var uppperView: UIView!
   
    
    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        uppperView.layer.borderColor = UIColor.blackColor().CGColor
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
        
        cell.inLabel?.text = reportData.inTime
        cell.nameLabel?.text = reportData.userName
        cell.ouLabel?.text = reportData.outTime;
     
        return cell
    }
 
    
    @IBAction func homeButtonPressed(sender: AnyObject?) {
     self.performSegueWithIdentifier("idSegueHome", sender: self)
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone{
            return [.Portrait, .PortraitUpsideDown]
        }
        else {
            return .All
        }
    }
}