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

    var logon: Logon!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.report.enabled = false
    }
    
    @IBAction func logoutAction (sender: AnyObject?){
     
        let networkController:ProtocolNetworkController = NetworkController()
        networkController.sendPostRequest(logon.writeLogout(), urlString: "/user/logout", completion: { _ in })
        self.performSegueWithIdentifier("idSegueLogout", sender: self)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
}