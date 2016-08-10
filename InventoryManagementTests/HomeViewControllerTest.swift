//
//  HomeViewControllerTest.swift
//  InventoryManagement
//
//  Created by Himanshu Bapna on 30/06/16.
//  Copyright © 2016 Impetus. All rights reserved.
//

import XCTest
import UIKit
@testable import InventoryManagement

class HomeViewControllerTest: XCTestCase {
    
    var homeViewController: HomeViewController!
    
    override func setUp() {
        super.setUp()
       
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        homeViewController = storyboard.instantiateViewControllerWithIdentifier("Home") as! HomeViewController
        homeViewController.loadView()

    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample() {
        homeViewController.viewDidLoad()
        
        homeViewController.reportAction(nil)
        
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    
    func testSuccessCallBack(){
        let reportJSON = "{\"result\": {\"timeout\": 0,\"deviceReportDtoList\": [{\"loginTIme\": 1470619824000,\"logOutTime\": 1470621624000,\"userId\": \"User0\",       \"userName\": \"Raja\"}]},\"responseCode\": {\"code\": 200}}"
        
        let data = (reportJSON as NSString).dataUsingEncoding(NSUTF8StringEncoding)
        
  
        homeViewController.successCallBack(data)
        
        XCTAssertTrue(homeViewController.deviceRepotList.count == 1,"Sucess call back of report actin failed")
        
    }
    
    func testDisableUI() {
        homeViewController.disableUI()
        XCTAssertFalse(homeViewController.report.enabled, "Report button is not disable")
        XCTAssertFalse(homeViewController.logout.enabled, "Logout button is not disable")
     
        XCTAssertTrue(homeViewController.activityIndicator.isAnimating(), "Activity Indicator is not animating")

    }
    
    func testEnableUI() {
        homeViewController.enableUI()
        XCTAssertTrue(homeViewController.report.enabled, "Report button is not enable")
        XCTAssertTrue(homeViewController.logout.enabled, "Logout button is not enable")
        
        XCTAssertFalse(homeViewController.activityIndicator.isAnimating(), "Activity Indicator not stopped animating")
       
    }

    
    func testprefersStatusBarHidden() {
        
     
        XCTAssertFalse(homeViewController.prefersStatusBarHidden(), "Prefrence Staus bar is true")
        
    }
    
}
