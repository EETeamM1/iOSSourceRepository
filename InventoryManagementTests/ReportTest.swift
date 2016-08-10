//
//  ReportTest.swift
//  InventoryManagement
//
//  Created by Himanshu Bapna on 26/07/16.
//  Copyright © 2016 Impetus. All rights reserved.
//

import XCTest

@testable import InventoryManagement

class ReportTest: XCTestCase {
    
    var report: Report!

    override func setUp() {
        super.setUp()
        report = Report()
    }
    
    override func tearDown() {
        report = nil
        super.tearDown()
    }

    func testParseDeviceReport() {
        let reportJSON = "{\"result\": {\"timeout\": 0,\"deviceReportDtoList\": [{\"loginTIme\": 1470619824000,\"logOutTime\": 1470621624000,\"userId\": \"User0\",       \"userName\": \"Raja\"}, {\"loginTIme\": 1470619824000,\"logOutTime\": ,\"userId\": \"User0\",       \"userName\": \"Raja\"}]},\"responseCode\": {\"code\": 200}}"
        
        let data = (reportJSON as NSString).dataUsingEncoding(NSUTF8StringEncoding)

        report.parseDeviceReport(data)
        XCTAssertEqual(2 ,report.deviceReportList.count, "report list count is incorrect")
        
        let reportArray: NSArray = report.deviceReportList
        
        let deviceReport :DeviceReport = reportArray[0] as! DeviceReport
        XCTAssertEqual("7:00 AM", deviceReport.inTime, "Device in time is incorrect")
        XCTAssertEqual("7:30 AM", deviceReport.outTime, "Device out time is incorrect")
        XCTAssertEqual("User0", deviceReport.userId, "User id is incorrect")
        XCTAssertEqual("Raja", deviceReport.userName, "User name is incorrect")
         let deviceReportNoOut :DeviceReport = reportArray[1] as! DeviceReport
        XCTAssertEqual("", deviceReportNoOut.outTime, "Device out time is incorrect")
        
    }

    
//    func testconvertLongToString() {
//        
//        convertLongToString(time:NSNumber)
//        
//        XCTAssertEqual(3 ,report.deviceReportList.count, "report list count is incorrect")
//        
//        let reportArray: NSArray = report.deviceReportList
//        
//        let deviceReport :DeviceReport = reportArray[0] as! DeviceReport
//        XCTAssertEqual("7:00 AM", deviceReport.inTime, "Device in time is incorrect")
//        XCTAssertEqual("7:30 AM", deviceReport.outTime, "Device out time is incorrect")
//        XCTAssertEqual("User0", deviceReport.userId, "User id is incorrect")
//        XCTAssertEqual("Ankit", deviceReport.userName, "User name is incorrect")
//        
//    }
    
}
