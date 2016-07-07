//
//  NetwrokController.swift
//  Hello
//
//  Created by impadmin on 08/06/16.
//  Copyright © 2016 World. All rights reserved.
//

import Foundation

class NetworkController: ProtocolNetworkController {
    
    let serverURL: String = "http://172.26.60.21:9000/InventoryManagement/api"
    var session: NSURLSession?
    
    func sendPostRequest(postData: NSString,  urlString:String, completion: (bool:Bool?, object:NSObject?, status:Int?) -> Void) {
        self.sendRequest(postData, urlString: urlString, requestMethod: "POST", completion: completion)
    }
    
    func sendGetRequest(urlString:String, completion: (bool:Bool?, object:NSObject?,status:Int?) -> Void) {
        self.sendRequest(nil, urlString: urlString, requestMethod: "GET", completion: completion)
    }
    
    func sendRequest(postData:NSString?, urlString:String, requestMethod:String, completion: (bool:Bool?, object:NSObject?, status:Int?) -> Void){
        let urlString = serverURL + urlString
        let url:NSURL? = NSURL(string: urlString )!

        let urlconfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        urlconfig.timeoutIntervalForRequest = 30.0
        urlconfig.timeoutIntervalForResource = 60.0
        
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = requestMethod
        
        if requestMethod == "POST"{
            postData!.UTF8String
            let postDataEncoded:NSData = postData!.dataUsingEncoding(NSUTF8StringEncoding)!
            let postLength:NSString = String( postDataEncoded.length)
            request.HTTPBody = postDataEncoded
            request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
        }
       
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        self.session = NSURLSession(configuration: urlconfig)
        self.session!.dataTaskWithRequest(request, completionHandler: getCompletionHandler(completion)).resume()
    }
    
    func getCompletionHandler(completion:(bool:Bool?, object:NSObject?, status:Int?) ->Void) -> (NSData?, NSURLResponse?, NSError?) -> Void {
        
        let completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void = { (data, response, error) in
            // this is where the completion handler code goes
            if (response != nil) {
                let httpResponse:NSHTTPURLResponse = response as! NSHTTPURLResponse
                if (httpResponse.statusCode >= 200 && httpResponse.statusCode < 300) {
                    completion(bool:true, object:data, status: httpResponse.statusCode)
                }else {
                    var errorStr : NSString = "Error on server"
                    if (httpResponse.statusCode == 401) {
                        errorStr = "Invalid user or password"
                    }
                    else if ( httpResponse.statusCode == 404) {
                        //TODO later we have to parse value
                        errorStr = "IMEI No incorrect/Device not registered"

                    }
                    else if ( httpResponse.statusCode == 500) {
                        //TODO later we have to parse value
                        errorStr = "Internal server error"
                    }
                    else if (httpResponse.statusCode < 200) || (httpResponse.statusCode  > 299) {
                        errorStr = "Error occured on server"
                    }
                    completion(bool: false, object: errorStr, status:httpResponse.statusCode)
                }
            }
            else{
                if (error?.domain == NSURLErrorDomain){
                    completion(bool: false, object: "Unable to contact server", status:0)
                }
            }
        }
        return completionHandler
    }
}
