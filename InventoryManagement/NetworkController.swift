//
//  NetwrokController.swift
//  Hello
//
//  Created by impadmin on 08/06/16.
//  Copyright © 2016 World. All rights reserved.
//

import Foundation

class NetworkController: ProtocolNetworkController {
    
    
    
    func sendPostRequest(postData: NSString, urlString:String, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) {
        
        
        
        let url:NSURL? = NSURL(string: urlString )!
        
        
        let postDataEncoded:NSData = postData.dataUsingEncoding(NSASCIIStringEncoding)!
        
        let postLength:NSString = String( postDataEncoded.length )
        
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        request.HTTPBody = postDataEncoded
        request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let session = NSURLSession.sharedSession()
        
        session.dataTaskWithRequest(request, completionHandler: completionHandler).resume()
        
        
    }
    
    func sendGetRequest(urlString:String, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) {
        
        let url:NSURL? = NSURL(string: urlString )!
        
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let session = NSURLSession.sharedSession()
        
        session.dataTaskWithRequest(request, completionHandler: completionHandler).resume()
        
        
    }
    
    
}
