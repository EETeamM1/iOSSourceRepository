//
//  NetwrokController.swift
//  Hello
//
//  Created by impadmin on 08/06/16.
//  Copyright © 2016 World. All rights reserved.
//

import Foundation

class NetworkController: ProtocolNetworkController {
    
    
    
    func sendPostRequest(postData: NSString,  urlString:String, completion: (bool:Bool?, object:NSObject?) -> Void) {

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
        session.dataTaskWithRequest(request, completionHandler: getCompletionHandler(completion)).resume()
    }
    
    func sendGetRequest(urlString:String, completion: (bool:Bool?, object:NSObject?) -> Void) {
        
        let url:NSURL? = NSURL(string: urlString )!
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let session = NSURLSession.sharedSession()
        session.dataTaskWithRequest(request, completionHandler: getCompletionHandler(completion)).resume()
    }
    
    func getCompletionHandler(completion:(bool:Bool?, object:NSObject?) ->Void) -> (NSData?, NSURLResponse?, NSError?) -> Void{
        
        let completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void = { (data, response, error) in
            // this is where the completion handler code goes
            
            if (response != nil) {
                
                let httpResponse:NSHTTPURLResponse = response as! NSHTTPURLResponse
                if (httpResponse.statusCode >= 200 && httpResponse.statusCode < 300) {
                    completion(bool:true, object:data)
                }else {
                    var errorStr : NSString = "Error on server"
                    if (httpResponse.statusCode == 401) {
                        errorStr = "Invalid user or password"
                    }
                    else if ( httpResponse.statusCode == 500) {
                        //TODO later we have to parse value
                        errorStr = "Internal server error"
                    }
                    else if (httpResponse.statusCode < 200) || (httpResponse.statusCode  > 299) {
                        errorStr = "Error occured on server"
                    }
                    completion(bool: false, object: errorStr)
                }
            }
            else{
                if (error?.domain == NSURLErrorDomain){
                    completion(bool: false, object: "Unable to contact server")
                }
            }
        }
        return completionHandler
    }
}
