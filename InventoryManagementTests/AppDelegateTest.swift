//
//  AppDelegateTest.swift
//  InventoryManagement
//
//  Created by Himanshu Bapna on 27/07/16.
//  Copyright © 2016 Impetus. All rights reserved.
//

import XCTest

@testable import InventoryManagement

class AppDelegateTest: XCTestCase {

    var delegate : AppDelegate!
    override func setUp() {
        super.setUp()
        delegate = AppDelegate()
    }
    
    override func tearDown() {
        delegate = nil
        super.tearDown()
    }

    func testDidRegisterForRemoteNotificationsWithDeviceToken() {
        let devicetoken = "<740f4707 bebcf74f 9b7c25d4 8e335894 5f6aa01d a5ddb387 462c7eaf 61bb78ad>"
        let data = toData(devicetoken)
        delegate.application(UIApplication.sharedApplication(), didRegisterForRemoteNotificationsWithDeviceToken: data!)
        
        let actualDeviceToken = NSUserDefaults.standardUserDefaults().objectForKey("deviceToken") as? String
        let expectedDeviceToken = "740f4707bebcf74f9b7c25d48e3358945f6aa01da5ddb387462c7eaf61bb78ad"

        XCTAssertEqual(expectedDeviceToken, actualDeviceToken, "Deveice token is incorrect register")
    }

//    func testDidReceiveRemoteNotification() {
//        let userInfo: [NSObject : AnyObject] = ["aps": [ "alert": "Please re-login on Inventory Management App","sound": "default"]]
//        delegate.application(UIApplication.sharedApplication(), didReceiveRemoteNotification: userInfo)
//
//        let rootVC = UIApplication.sharedApplication().keyWindow?.rootViewController?.presentedViewController
//        XCTAssertTrue(rootVC is UIAlertController, "Alert not appeared")
//        if let alert = rootVC as? UIAlertController{
//            XCTAssertEqual(alert.title, "")
//            XCTAssertEqual(alert.message, "Please re-login on Inventory Management App")
//            alert
//        }
//        else {
//            XCTFail("UIAlertController failed to be presented")
//            
//        }
//
//        
//    }
    
    private func toData(deviceToken: String) -> NSData? {
        let trim = deviceToken
            .stringByTrimmingCharactersInSet(
                NSCharacterSet(charactersInString: "<> "))
            .stringByReplacingOccurrencesOfString(" ", withString: "")
        
        let data = NSMutableData(capacity: trim.characters.count / 2)
        
        var i = trim.startIndex;
        
        for (; i < trim.endIndex; i = i.successor().successor()) {
            let byteString = trim.substringWithRange(
                Range<String.Index>(start: i, end: i.successor().successor()))
            
            var num = byteString.withCString { strtoul($0, nil, 16) } as UInt
            data!.appendBytes(&num, length: 1)
        }
        
        return data
    }
}
