//
//  LoginViewController.swift
//  InventoryManagement
//
//  Created by Himanshu Bapna on 31/05/16.
//  Copyright © 2016 Impetus. All rights reserved.
//

import CoreLocation
import UIKit

class LoginViewController : UIViewController, CLLocationManagerDelegate, UITextFieldDelegate {
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorFiled: UITextView!
    @IBOutlet weak var activityIndicator:UIActivityIndicatorView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    let invHomeSegue = "segueHomeScreen"
    
    var locationManager: CLLocationManager!
    var location:CLLocation = CLLocation()
    
    var isKeyboardShown: Bool = false
    var isKeyboardOverlap: Bool = false
    var yOffsetDifference: CGFloat!
    var initialScrollViewYOffset: CGFloat!
    
    var logon: Logon!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginTextField.delegate = self
        passwordTextField.delegate = self
        setTextFieldUI(loginTextField)
        setTextFieldUI(passwordTextField)
        self.activityIndicator.stopAnimating()
        self.activityIndicator.hidden = true

        if (CLLocationManager.locationServicesEnabled()){
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
        
        //Add observer for keyboard
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardDidHideNotification, object: nil)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        initialScrollViewYOffset = scrollView.contentOffset.y
    }
    
    // ==================================
    // prepareForSegue
    // ==================================
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == invHomeSegue {
            let homeViewController = segue.destinationViewController as? HomeViewController
            homeViewController!.logon = self.logon as Logon
        }
    }
    
    func disableUI (){
        loginTextField.enabled = false
        passwordTextField.enabled = false
        loginButton.enabled = false
        activityIndicator.hidden = false;
        activityIndicator.startAnimating()
        errorFiled.hidden = true
    }
    
    func enableUI (){
        loginTextField.enabled = true
        passwordTextField.enabled = true
        loginButton.enabled = true
        self.activityIndicator.hidden = true;
        self.activityIndicator.stopAnimating()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
         location = locations.last! as CLLocation
    }
    
    
    @IBAction func login (){
        disableUI ()

        let URLString = "http://172.26.60.21:9000/InventoryManagement/api/user/login"
        let username = loginTextField.text
        let password = passwordTextField.text
        
        if (username!.characters.count == 0  || password!.characters.count == 0){
            errorFiled.text = "Username/Password is required"
            errorFiled.hidden = false
            enableUI()
            return
        }
        
        logon = Logon();
        let postData = logon.writeLogon(username, withPassword: password, AndWithLocation: location)
        let loginCompletionHandler: (Bool? , NSObject?) -> Void = { (success, data) in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.enableUI()
                if (success == true) {
                    self.successCallBack(data as? NSData)
                } else {
                    self.failureCallBack(data as? String);
                }
            })
            
        }
        let networkController:ProtocolNetworkController = NetworkController()
        networkController.sendPostRequest(postData, urlString: URLString, completion: loginCompletionHandler)
        
       }
    
    
    func successCallBack(data:NSData?) {
        logon.parseLogon(data)
        self.performSegueWithIdentifier(invHomeSegue, sender: self)
    }
    
    func failureCallBack(error:String!) {
        errorFiled.text = error
        errorFiled.hidden = false
    }
    
    func setTextFieldUI (textField : UITextField){
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor(red: 165.0/255.0, green: 0/255.0, blue: 93.0/255.0, alpha: 1).CGColor
        textField.layer.cornerRadius = 5.0
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    func keyboardWillShow (notification: NSNotification) {
        if isKeyboardShown{
            return;
        }
        
        let keyboardInfo: NSDictionary = notification.userInfo!
        let keyboardFrameBegin:NSValue = keyboardInfo.valueForKey(UIKeyboardFrameBeginUserInfoKey) as! NSValue
        let keyboardFrameBeginRect = keyboardFrameBegin.CGRectValue()
        
        //Calculate y-position difference value between bootom of passwordField & top edge of keyboard.
        //This will check keyboard is overlapping on password field or not.
        yOffsetDifference = (passwordTextField.frame.origin.y + passwordTextField.frame.size.height + 35) - (keyboardFrameBeginRect.origin.y - keyboardFrameBeginRect.height)  ;
        isKeyboardOverlap = (self.yOffsetDifference>=0.0);
    
        if isKeyboardOverlap {
            moveScrollViewOnYOffset(yOffsetDifference)
        }
    
        self.isKeyboardShown = true;
    }
    
    func keyboardWillHide (notification: NSNotification) {
        if isKeyboardOverlap {
            moveScrollViewOnYOffset(initialScrollViewYOffset);
        }
        self.isKeyboardShown = false;
    }
    
    func moveScrollViewOnYOffset (yOffset:CGFloat) {
        scrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x, y: yOffset), animated: true)
    }
    

    
}