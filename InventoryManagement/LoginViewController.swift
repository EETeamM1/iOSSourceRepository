//
//  LoginViewController.swift
//  InventoryManagement
//
//  Created by Himanshu Bapna on 31/05/16.
//  Copyright © 2016 Impetus. All rights reserved.
//

import UIKit

class LoginViewController : UIViewController {
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTextFieldUI(loginTextField)
        setTextFieldUI(passwordTextField)
    }
    
    @IBAction func login (){
        let logon = Logon();
        let str: NSString =  logon.writeLogon("user1", withPassword: "impetus", AndWithLocation: nil  )
    }
    
    func setTextFieldUI (textField : UITextField){
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor(red: 165.0/255.0, green: 0/255.0, blue: 93.0/255.0, alpha: 1).CGColor
        textField.layer.cornerRadius = 5.0
    }
    
}