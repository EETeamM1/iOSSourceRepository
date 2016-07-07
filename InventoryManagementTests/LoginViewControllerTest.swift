//
//  LoginViewControllerTest.swift
//  InventoryManagement
//
//  Created by Himanshu Bapna on 27/06/16.
//  Copyright © 2016 Impetus. All rights reserved.
//

import XCTest
import UIKit
@testable import InventoryManagement

class LoginViewControllerTest: XCTestCase {

    var loginViewController: LoginViewController!
    
    override func setUp() {
        super.setUp()
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        loginViewController = storyboard.instantiateViewControllerWithIdentifier("Login") as! LoginViewController
        loginViewController.loadView()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    //Test method

    func testSetTextFieldUI() {
        checkSetTextFieldUI(loginViewController.usernameTextField)
        checkSetTextFieldUI(loginViewController.passwordTextField)
    }

    func testDisableUI() {
        loginViewController.disableUI()
        XCTAssertFalse(loginViewController.usernameTextField.enabled, "Username field is not disable")
        XCTAssertFalse(loginViewController.passwordTextField.enabled, "Password field is not disable")
        XCTAssertFalse(loginViewController.loginButton.enabled, "Login Button is not disable")
        XCTAssertFalse(loginViewController.activityIndicator.hidden, "Activity Indicator is hidden")
        XCTAssertTrue(loginViewController.activityIndicator.isAnimating(), "Activity Indicator is not animating")
        XCTAssertTrue(loginViewController.errorFiled.hidden, "Error field is not hidden")
    }
    
    func testEnableUI() {
        loginViewController.enableUI()
        XCTAssertTrue(loginViewController.usernameTextField.enabled, "Username field is not enable")
        XCTAssertTrue(loginViewController.passwordTextField.enabled, "Password field is not enable")
        XCTAssertTrue(loginViewController.loginButton.enabled, "Login Button is not enable")
        XCTAssertTrue(loginViewController.activityIndicator.hidden, "Activity Indicator is showning")
        XCTAssertFalse(loginViewController.activityIndicator.isAnimating(), "Activity Indicator is animating")
    }
    
    func testLogin(){
        loginViewController.passwordTextField.text = ""
        loginViewController.preferences.setObject("12345655474255", forKey: loginViewController.IMEIKey)
        loginViewController.login(nil)
        XCTAssertEqual("Username/Password is required", loginViewController.errorFiled.text, "Error message is incorrect")
        XCTAssertEqual("12345655474255", loginViewController.preferences.objectForKey(loginViewController.IMEIKey) as! String, "Error message is incorrect")
        XCTAssertFalse(loginViewController.errorFiled.hidden, "Error field is hidden")
        
        loginViewController.passwordTextField.text = "impetus"
        loginViewController.usernameTextField.text = "user1"
        loginViewController.login(nil)
        
        
    }
    
    func testKeyboardWillShow(){
       loginViewController.passwordTextField.frame = CGRect(x: 209, y: 350, width: 350, height: 40)
        let notification = NSNotification.init(name: UIKeyboardWillShowNotification, object: nil, userInfo: [UIKeyboardFrameBeginUserInfoKey: NSValue(CGRect: CGRect(x: 0,y: 768,width: 1024,height: 398))])
        
        loginViewController.keyboardWillShow(notification)
       
        XCTAssertTrue(loginViewController.yOffsetDifference > 0, "Y offeset diff is not greater than zero")
        XCTAssertTrue(loginViewController.isKeyboardOverlap, "Keyboard is not overlap")
        XCTAssertTrue(loginViewController.isKeyboardShown, "Keyboard is not shown")
    }
    
    func testKeyboardWillHide(){
        loginViewController.isKeyboardOverlap = true
        loginViewController.isKeyboardShown = true
        loginViewController.initialScrollViewYOffset = 0.0
        
        let notification = NSNotification.init(name: UIKeyboardWillHideNotification, object: nil)
        loginViewController.keyboardWillHide(notification)
        XCTAssertFalse(loginViewController.isKeyboardShown, "Keyboard is shown")
    }
    
    func testSuccessCallBack(){
        let logonResponseJSON = "{\"result\": { \"sessionToken\": \"user11465378323910\",\"masterPassword\":\"test123\", \"timeout\": 30 }, \"responseCode\": {\"code\": 200, \"message\": \"Success\" }}"
        
        let data = (logonResponseJSON as NSString).dataUsingEncoding(NSUTF8StringEncoding)
        
        loginViewController.logon = Logon()
        loginViewController.successCallBack(data)
        XCTAssertEqual("user11465378323910", loginViewController.logon.sessionToken, "After Succes login parsing failed")
        XCTAssertTrue(loginViewController.passwordTextField.text == "","After success call back password field does not get empty")
        
    }
    
    func testfailureCallBack(){
        let errorString = "Unable to contact server"
        loginViewController.failureCallBack(errorString, statusCode: 400)
        XCTAssertFalse(loginViewController.errorFiled.hidden, "Error message is hidden on login failure")
        XCTAssertEqual(errorString, loginViewController.errorFiled.text, "Error message is incorrect")        
    }
    
    func testTextFieldShouldReturn(){
        XCTAssertTrue(loginViewController.textFieldShouldReturn(loginViewController.usernameTextField), "Text field delegate does not return")
    }
    
    //Helper method
    
    func checkSetTextFieldUI(textField: UITextField){
        loginViewController.setTextFieldUI(textField)
        XCTAssertEqual(1.0, textField.layer.borderWidth, " Text field border width is incorrect")
        XCTAssertEqual(5.0, textField.layer.cornerRadius, "Text field corner radius is incorrect")
    }

}
