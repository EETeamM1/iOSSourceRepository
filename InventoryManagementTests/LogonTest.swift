//
//  LogonTest.swift
//  InventoryManagement
//
//  Created by Himanshu Bapna on 27/06/16.
//  Copyright © 2016 Impetus. All rights reserved.
//

import XCTest
import CoreLocation

class LogonTest: XCTestCase {
    
    var logon: MockLogon!

    override func setUp() {
        super.setUp()
        logon =  MockLogon()
    }
    
    override func tearDown() {
        logon = nil
        super.tearDown()
    }

    func testParseLogon(){
        let logonResponseJSON = "{\"result\": { \"sessionToken\": \"user11465378323910\",\"masterPassword\":\"test123\", \"timeout\": 30 }, \"responseCode\": {\"code\": 200, \"message\": \"Success\" }}"
        
        let data = (logonResponseJSON as NSString).dataUsingEncoding(NSUTF8StringEncoding)
        
        logon.parseLogon(data)
        XCTAssertEqual("user11465378323910" ,logon.sessionToken, "Logon session value is incorrect")
        XCTAssertEqual("test123" ,logon.masterPassword, "Logon master password value is incorrect")
        XCTAssertEqual(30 ,logon.timeout, "Logon timeout value is incorrect")
        
        XCTAssertEqual(200 ,logon.code, "Logon response code value is incorrect")
        XCTAssertEqual("Success" ,logon.message, "Logon response message value is incorrect")
    }
    
    func testWriteLogon(){
        let location = CLLocation(latitude: 22.684780, longitude: 75.870673)
        let logonPostbody = logon.writeLogon("aryan.arora", withPassword: "impetus", AndWithLocation: location)
        let expectedJSON = "{ \"parameters\": {\"userId\": \"aryan.arora\", \"password\": \"impetus\", \"deviceId\": \"12345655474255\", \"osVersion\": \"ios9\", \"latitude\": \"22.68478\", \"longitude\": \"75.870673\"}}"
        
        XCTAssertEqual(expectedJSON, logonPostbody, "Logon post json is invalid")
    }
    
    func testWriteLogout(){
        logon.sessionToken = "user11465378323910"
        let expectedJSON = "{ \"parameters\": {\"sessionToken\" :\"user11465378323910\" }}"
        XCTAssertEqual(expectedJSON, logon.writeLogout(), "Logout post json is invalid")
    }
}
