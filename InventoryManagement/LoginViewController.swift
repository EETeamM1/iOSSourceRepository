//
//  LoginViewController.swift
//  InventoryManagement
//
//  Created by Himanshu Bapna on 31/05/16.
//  Copyright © 2016 Impetus. All rights reserved.
//

import CoreLocation
import UIKit

class LoginViewController : UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorFiled: UITextView!
    @IBOutlet weak var activityIndicator:UIActivityIndicatorView!
    var locationManager: CLLocationManager!
    var location:CLLocation = CLLocation()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTextFieldUI(loginTextField)
        setTextFieldUI(passwordTextField)
        self.activityIndicator.stopAnimating()
        self.activityIndicator.hidden = true

       
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
        
    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        
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
        
        
         let logon = Logon();
        let postData = logon.writeLogon(username, withPassword: password, AndWithLocation: location)
        let loginCompletionHandler: (Bool? , NSObject?) -> Void = { (success, data) in
            if (success == true) {
                self.successCallBack(data as? NSData)
            } else {
                self.failureCallBack(data as? NSError);
            }
            print(data);
            
            
        }
        
    
        let networkController:ProtocolNetworkController = NetworkController()
        networkController.sendPostRequest(postData, urlString: URLString, completion: loginCompletionHandler)
        

       
       }
    
    
    func successCallBack(data:NSData?) {
        self.enableUI()
//        self.performSegueWithIdentifier("segueHomeScreen", sender: nil)
    }
    
    func failureCallBack(error:NSError?) {
//        self.errorFiled.text = "Unable to contact server"
//        self.errorFiled.hidden = false
        self.enableUI()
    }
    
    func setTextFieldUI (textField : UITextField){
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor(red: 165.0/255.0, green: 0/255.0, blue: 93.0/255.0, alpha: 1).CGColor
        textField.layer.cornerRadius = 5.0
        
    }

    
//    func createPostDataString () ->NSString{
////        let username = loginTextField.text
////        let password = passwordTextField.text
////        let systemName = UIDevice.currentDevice().systemName
////        let systemModel = UIDevice.currentDevice().model
////        
////        let systemVersion = UIDevice.currentDevice().systemVersion;
////        
//////        let postData = "{\"parameters\": {\"userId\": \"\(username!)\",\"password\": \"\(password!)\", \"deviceId\": \"12345655474255\",\"latitude\": \"\(latitude)\", \"longitude\": \"\(longitude)\",\"osVersion\": \"\(systemVersion)\"}}"
////        return postData
//        return nil;
//    }

    

    
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
    
}