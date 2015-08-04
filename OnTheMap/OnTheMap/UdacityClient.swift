//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Prajwal Kedilaya on 7/29/15.
//  Copyright (c) 2015 Prajwal Kedilaya. All rights reserved.
//

import UIKit

class UdacityClient: NSObject {
    
    /* Session URL */
    var sessionURL: String = "https://www.udacity.com/api/session"
    
    /* Public User Data URL */
    var usersURL :String = "https://www.udacity.com/api/users/"
    
    /* Shared session */
    var session: NSURLSession
    
    /* Session variables */
    var sessionID : String = ""
    
    /* User Data variables */
    var userID : String = ""
    var firstName: String = ""
    var lastName: String = ""
    
    /* Query flags */
    var loginInProgress: Bool = false
    var logoutInProgress: Bool = false
    var userQueryInProgress: Bool = false
    
    override init() {
        /* intiate session */
        session = NSURLSession.sharedSession()
        
        super.init()
    }
    
    func authenticateWithCredentials(email:String, password:String, completionHandler: (success: Bool, errorString: String?) -> Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: sessionURL)!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        /* add parameters */
        request.HTTPBody = ("{\"udacity\": {\"username\": \""+email+"\", \"password\": \""+password+"\"}}").dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                /* network error */
                completionHandler(success: false, errorString: error.localizedDescription)
            }
            else{
                /* successful response */
                let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
                self.loginInProgress = true
                self.parseJSONWithCompletionHandler(newData, completionHandler: completionHandler)
            }
        }
        task.resume()
    }
    
    func getUserData(completionHandler: (success: Bool, errorString: String?) -> Void){
        let request = NSMutableURLRequest(URL: NSURL(string: usersURL+userID)!)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                /* network error */
                completionHandler(success: false, errorString: error.localizedDescription)
            }
            else{
                /* successful response */
                let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
                self.userQueryInProgress = true
                self.parseJSONWithCompletionHandler(newData, completionHandler: completionHandler)
            }
        }
        task.resume()
    }
    
    func endSession(completionHandler: (success: Bool, errorString: String?) -> Void){
        let request = NSMutableURLRequest(URL: NSURL(string: sessionURL)!)
        request.HTTPMethod = "DELETE"
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies as! [NSHTTPCookie] {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.addValue(xsrfCookie.value!, forHTTPHeaderField: "X-XSRF-Token")
        }
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                /* network error */
                completionHandler(success: false, errorString: error.localizedDescription)
            }
            else{
                /* successful response */
                let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
                self.logoutInProgress = true
                self.parseJSONWithCompletionHandler(newData, completionHandler: completionHandler)
            }
        }
        task.resume()
    }
    
    func parseJSONWithCompletionHandler(data: NSData, completionHandler: (success: Bool, errorString: String?) -> Void) {
        var parsingError: NSError? = nil
        
        /* convert data into JSON format */
        if let parsedResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &parsingError) as? NSDictionary {
            if parsedResult.objectForKey("error") == nil {
                /* save data based on different flags */
                if loginInProgress == true {
                    let account = parsedResult["account"] as! NSDictionary
                    let session = parsedResult["session"] as! NSDictionary
                    sessionID = (session["id"] as? String)!
                    userID = (account["key"] as? String)!
                    loginInProgress = false
                }
                else if logoutInProgress == true {
                    sessionID = ""
                    userID = ""
                    logoutInProgress = false
                }
                else if userQueryInProgress == true {
                    let userData = parsedResult["user"] as! NSDictionary
                    firstName = (userData["first_name"] as? String)!
                    lastName = (userData["last_name"] as? String)!
                    userQueryInProgress = false
                }
                
                completionHandler(success: true, errorString: nil)
            }
            else{
                /* server error */
                completionHandler(success: false, errorString: parsedResult["error"] as? String)
            }
        }
        else{
            /* JSON conversion error */
            completionHandler(success: false, errorString: parsingError?.localizedDescription)
        }
    }
}
