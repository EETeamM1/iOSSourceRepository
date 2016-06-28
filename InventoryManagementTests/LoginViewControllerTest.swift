//
//  LoginViewControllerTest.swift
//  InventoryManagement
//
//  Created by Himanshu Bapna on 27/06/16.
//  Copyright © 2016 Impetus. All rights reserved.
//

import XCTest
import UIKit

class LoginViewControllerTest: XCTestCase {

    var loginViewController: LoginViewController!
    
    override func setUp() {
        super.setUp()
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle(forClass: self.dynamicType))
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
        loginViewController.login(nil)
        XCTAssertEqual("Username/Password is required", loginViewController.errorFiled.text, "Error message is incorrect")
        XCTAssertFalse(loginViewController.errorFiled.hidden, "Error field is hidden")
        
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
        XCTAssertFalse(loginViewController.isKeyboardShown, "Keyboard is shown")
        
    }
    
    //Helper method
    
    func checkSetTextFieldUI(textField: UITextField){
        loginViewController.setTextFieldUI(textField)
        XCTAssertEqual(1.0, textField.layer.borderWidth, " Text field border width is incorrect")
        XCTAssertEqual(5.0, textField.layer.cornerRadius, "Text field corner radius is incorrect")
    }

}
