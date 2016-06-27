//
//  MockLogon.swift
//  InventoryManagement
//
//  Created by Himanshu Bapna on 27/06/16.
//  Copyright © 2016 Impetus. All rights reserved.
//

import Foundation

class MockLogon: Logon{
    
    override func getOSversion () ->NSString{
        return "ios9"
    }
}