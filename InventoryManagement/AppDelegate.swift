//
//  AppDelegate.swift
//  InventoryManagement
//
//  Created by Himanshu Bapna on 24/05/16.
//  Copyright © 2016 Impetus. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    static let device_token_key = "deviceToken"
    
    /*
    * Application is ready to launch and here we initiate LoginViewController as 1st view controller of app
    */
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let controllerId = "Login";
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let initViewController: UIViewController = storyboard.instantiateViewControllerWithIdentifier(controllerId) as UIViewController
        self.window?.rootViewController = initViewController

        let notificationTypes: UIUserNotificationType = [UIUserNotificationType.Alert, UIUserNotificationType.Sound]
        let pushNotificationSettings = UIUserNotificationSettings(forTypes: notificationTypes, categories: nil)
        
        application.registerUserNotificationSettings(pushNotificationSettings)
        application.registerForRemoteNotifications()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    /**
    * Method called when application failed to register Remote Notification
    */
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        NSLog("Did fail to register for remote notifications with error %@", error);
    }
    
    /**
    * Menthod called application successfully registered with Apple Push Notification service (APNs).
    */
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let deviceTokenStr = convertDeviceTokenToString(deviceToken)
        NSUserDefaults.standardUserDefaults().setObject(deviceTokenStr, forKey: AppDelegate.device_token_key)
        
    }
    
    /**
    * Called when your app has received a remote notification.The app object that received the remote notification.
    * And display Alert dialog or notification on the basis of app setting, for navigate back to login screen
    */
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
    
        var rootVC = UIApplication.sharedApplication().keyWindow?.rootViewController?.presentedViewController
        
        while ((rootVC?.presentedViewController) != nil)
        {
            rootVC = rootVC?.presentedViewController;
        }
        //Parsing userinfo:
        if let info = userInfo["aps"] as? Dictionary<String, AnyObject>
        {
            let alertMsg = info["alert"] as! String
            let alert = UIAlertController(title: "", message: alertMsg, preferredStyle: .Alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
                //handle action on "ok" button
                if NSUserDefaults.standardUserDefaults().objectForKey(Logon.sessionTokenKey)?.length > 0{
                    let networkController:ProtocolNetworkController = NetworkController()
                    let logon = Logon()
                    logon.sessionToken = NSUserDefaults.standardUserDefaults().objectForKey(Logon.sessionTokenKey) as! String
                    networkController.sendPostRequest(logon.writeLogout(), urlString: "/user/logout", completion: { _ in })
                    self.window?.rootViewController?.dismissViewControllerAnimated(true, completion: nil)
                }
            }))
           
            rootVC!.presentViewController(alert, animated: true, completion: nil)
        }
    }

    /**
    * @discussion Method to convert device token received from APNS server into valid string without any special character or space
    * @param deviceToken as NSData which is convert to string
    * @return conversion value
    */
     func convertDeviceTokenToString(deviceToken:NSData) -> String {
        //  Convert binary Device Token to a String (and remove the <,> and white space charaters).
        let validToken = deviceToken.description.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "<>"))
       return validToken.stringByReplacingOccurrencesOfString(" ", withString: "")
    }


}

