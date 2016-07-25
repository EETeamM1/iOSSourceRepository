    //
//  LoginViewController.swift
//  InventoryManagement
//
//  Created by Himanshu Bapna on 31/05/16.
//  Copyright © 2016 Impetus. All rights reserved.
//

import CoreLocation
import UIKit

class LoginViewController : UIViewController, CLLocationManagerDelegate, UITextFieldDelegate, UITextInputTraits {
    @IBOutlet weak var usernameTextField: UITextField!
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
    var isOrientationChange: Bool = false
    let preferences = NSUserDefaults.standardUserDefaults()
    let IMEIKey = "IMEI";
    var logon: Logon!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        setTextFieldUI(usernameTextField)
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
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onOrientationChange", name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        if preferences.objectForKey(IMEIKey) == nil {
             showAlertForIMEI ("Enter IMEI No. of this device");
        }
        checkForAlertDisplay()
        super.viewDidAppear(animated)
        initialScrollViewYOffset = scrollView.contentOffset.y
        self.isOrientationChange = false
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
    
    @IBAction func unwindToHomeViewController(unwindSegue: UIStoryboardSegue){}
    
    func disableUI (){
        usernameTextField.enabled = false
        
        passwordTextField.enabled = false
        loginButton.enabled = false
        activityIndicator.hidden = false;
        activityIndicator.startAnimating()
        errorFiled.hidden = true
    }
    
    func enableUI (){
        usernameTextField.enabled = true
        passwordTextField.enabled = true
        loginButton.enabled = true
        self.activityIndicator.hidden = true;
        self.activityIndicator.stopAnimating()
    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
         location = locations.last! as CLLocation
    }

    
    @IBAction func login (sender: AnyObject?){
        disableUI ()

        let username = usernameTextField.text
        let password = passwordTextField.text
      
        let imeiNo = preferences.objectForKey(IMEIKey) as! String
        
        
        if (username!.characters.count == 0  || password!.characters.count == 0){
            errorFiled.text = "Username/Password is required"
            errorFiled.hidden = false
            enableUI()
            return
        }
        
        logon = Logon();
        let postData = logon.writeLogon(username, withPassword: password,withIMEI: imeiNo, AndWithLocation: location)
        let loginCompletionHandler: (Bool? , NSObject?, Int?) -> Void = { (success, data, statusCode) in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.enableUI()
                if (success == true) {
                    self.successCallBack(data as? NSData)
                } else {
                    self.failureCallBack(data as? String, statusCode: statusCode!);
                }
            })
            
        }
        let networkController:ProtocolNetworkController = NetworkController()
        networkController.sendPostRequest(postData, urlString: "/user/login", completion: loginCompletionHandler)
    }
    
    func successCallBack(data:NSData?) {
        logon.parseLogon(data)
        NSUserDefaults.standardUserDefaults().setObject(logon.sessionToken, forKey: Logon.sessionTokenKey)
        passwordTextField.text = ""
        self.performSegueWithIdentifier(invHomeSegue, sender: self)
    }
    
    func failureCallBack(error:String!, statusCode:Int) {
        if (statusCode == 404 ) {
            self.showAlertForIMEI("Wrong IMEI No. Entered")
        }
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
        if self.isKeyboardShown{
            return
        }
        
        let keyboardInfo: NSDictionary = notification.userInfo!
        let keyboardFrameBegin:NSValue = keyboardInfo.valueForKey(UIKeyboardFrameBeginUserInfoKey) as! NSValue
        let keyboardFrameBeginRect = keyboardFrameBegin.CGRectValue()
        
        //Calculate y-position difference value between bootom of passwordField & top edge of keyboard.
        //This will check keyboard is overlapping on password field or not.
        self.yOffsetDifference = (self.passwordTextField.frame.origin.y + self.passwordTextField.frame.size.height + 35) - (keyboardFrameBeginRect.origin.y - keyboardFrameBeginRect.height)  ;
        self.isKeyboardOverlap = (self.yOffsetDifference>=0.0);
    
        if self.isKeyboardOverlap {
            moveScrollViewOnYOffset(self.yOffsetDifference)
        }
    
        self.isKeyboardShown = true
    }
    
    func keyboardWillHide (notification: NSNotification) {
        if self.isKeyboardOverlap {
            moveScrollViewOnYOffset(self.initialScrollViewYOffset);
        }
        
        self.isKeyboardShown = false;
    }
    
    func moveScrollViewOnYOffset (yOffset:CGFloat) {
        scrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x, y: yOffset), animated: true)
    }
    
    func onOrientationChange (){
        self.isOrientationChange = true
    }
    
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone{
            return [.Portrait, .PortraitUpsideDown]
        }
        else {
            return .All
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    func checkForAlertDisplay() {
        if preferences.objectForKey(IMEIKey) == nil {
            showAlertForIMEI ("Enter IMEI No. of this device");
        }
    }
    
    func showAlertForIMEI (errorString:String) {
        let alert = UIAlertController(title: "IMEI no.", message: errorString, preferredStyle: .Alert)
        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
           
           textField.keyboardType = UIKeyboardType.NumberPad
        })
      
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            if (alert.textFields?.first?.text?.characters.count <= 10) {
                alert.message = "Enter atlest 10 digits";
                self.presentViewController(alert, animated: true, completion: nil)
            } else {
                self.preferences.setObject((alert.textFields?.first?.text)!, forKey: self.IMEIKey)
            }
            
        }))
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
}