//
//  INetworkController.swift
//  Hello
//
//  Created by impadmin on 09/06/16.
//  Copyright © 2016 World. All rights reserved.
//

import Foundation
protocol ProtocolNetworkController {
    
    func sendPostRequest(postData: NSString, urlString:String, completion: (bool:Bool?, object:NSObject?) -> Void)
    
    func sendGetRequest(urlString:String, completion: (bool:Bool?, object:NSObject?) -> Void)
    
}