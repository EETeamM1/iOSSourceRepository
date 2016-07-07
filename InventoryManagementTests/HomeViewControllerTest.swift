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
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

}
