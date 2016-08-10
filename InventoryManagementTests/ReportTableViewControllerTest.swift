//
//  ReportTableViewControllerTest.swift
//  InventoryManagement
//
//  Created by raja.pateriya on 04/08/16.
//  Copyright © 2016 Impetus. All rights reserved.
//

import XCTest
import UIKit
@testable import InventoryManagement

class ReportTableViewControllerTest: XCTestCase {
    
    var reportTableViewController: ReportTableViewController!
    
    override func setUp() {
        super.setUp()
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        reportTableViewController = storyboard.instantiateViewControllerWithIdentifier("Report") as! ReportTableViewController
        reportTableViewController.loadView()
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    
    
    
    func testTableViewCell() {
        reportTableViewController.deviceReportList = NSMutableArray();
        let deviceReport = DeviceReport();
        deviceReport.inTime = "7.30 AM"
        deviceReport.outTime = "7.45 AM"
        deviceReport.userName = "Raja"
        reportTableViewController.deviceReportList.addObject(deviceReport)
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        let cell = reportTableViewController.tableView(reportTableViewController.tableView, cellForRowAtIndexPath: indexPath) as! ReportCell
        XCTAssertEqual(cell.nameLabel.text, "Raja", "Cell name label is not correct")
        XCTAssertEqual(cell.inLabel.text, "7.30 AM", "Cell name label is not correct")
        XCTAssertEqual(cell.ouLabel.text, "7.45 AM", "Cell name label is not correct")
    }
    
        
}
