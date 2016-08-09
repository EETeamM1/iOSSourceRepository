//
//  HomeViewController.swift
//  InventoryManagement
//
//  Created by Himanshu Bapna on 20/06/16.
//  Copyright © 2016 Impetus. All rights reserved.
//

import UIKit

class HomeViewController : UIViewController{
    
    @IBOutlet weak var logout: UIButton!
    @IBOutlet weak var report: UIButton!
    @IBOutlet weak var activityIndicator:UIActivityIndicatorView!
    var logon: Logon!
    var reportParser:Report!
    var deviceRepotList:NSMutableArray!
    let serialKey = "Serial";
    override func viewDidLoad() {
        super.viewDidLoad()
        enableUI()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    
    }
    
    @IBAction func logoutAction (sender: AnyObject?){
     
        let networkController:ProtocolNetworkController = NetworkController()
        logon = Logon()
        networkController.sendPostRequest(logon.writeLogout(), urlString: "/user/logout", completion: { _ in })
        self.performSegueWithIdentifier("idSegueLogout", sender: self)
    }
    
   
    
    
    @IBAction func reportAction (sender: AnyObject?){
        disableUI()
        let networkController:ProtocolNetworkController = NetworkController()
        
        let reportCompletionHandler: (Bool? , NSObject?, Int?) -> Void = { (success, data, statusCode) in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.enableUI()
                if (success == true) {
                    self.successCallBack(data as? NSData)
                } else {
                    self.failureCallBack(data as? String, statusCode: statusCode!);
                }
            })
            
        }
        let deviceid =   NSUserDefaults.standardUserDefaults().objectForKey(serialKey) as! String
        networkController.sendGetRequest("/deviceReport?deviceId=\(deviceid)", completion: reportCompletionHandler)
        
    }

    
    func successCallBack(data:NSData?) {
        reportParser = Report()
         deviceRepotList = reportParser.parseDeviceReport(data)
        self.performSegueWithIdentifier("idSegueReport", sender: self)
        
           }
    
    func failureCallBack(error:String!, statusCode:Int) {
       
        
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "idSegueReport") {
        let svc = segue.destinationViewController as! ReportTableViewController
        svc.deviceReportList = deviceRepotList
        }
    }
    func disableUI (){
        logout.enabled = false
        report.enabled = false
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        
    }
    
    func enableUI (){
        logout.enabled = true
        report.enabled = true
        activityIndicator.hidden = true
        self.activityIndicator.stopAnimating()
    }
    
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
}