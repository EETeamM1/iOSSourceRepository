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

    var logon: Logon!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let session = logon.sessionToken
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func logoutAction (){
        let logoutURL = "http://172.26.60.21:9000/InventoryManagement/api/user/logout"
        logon.writeLogout()
        
    }
}