//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Prajwal Kedilaya on 7/29/15.
//  Copyright (c) 2015 Prajwal Kedilaya. All rights reserved.
//

import UIKit
import CoreLocation

class ParseClient: NSObject {
   
    /* Shared session */
    var session: NSURLSession
    
    /* Stored Points */
    var storedPoints = [StudentLocation]()
    
    /* Custom Point Variables*/
    var customLocation:CLPlacemark?
    var mediaURL: String!
    var mapString: String!
    var latitude: String!
    var longitude:String!
    
    var appDelegate: AppDelegate!
    
    /* Query flags */
    var getResultsInProgress:Bool = false
    var postPointInProgress:Bool = false
    
    override init() {
        session = NSURLSession.sharedSession()
        
        /* Get the app delegate */
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        super.init()
    }
    
    func getResults(completionHandler: (success: Bool, errorString: String?) -> Void){
        /* get 100 latest student locations */
        let request = NSMutableURLRequest(URL: NSURL(string: Constants.parseURL+"?limit=100")!)
        
        /* pass credentials */
        request.addValue(Constants.appID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.apiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                /* network error */
                completionHandler(success: false, errorString: error.localizedDescription)
            }
            else{
                /* successful response */
                self.getResultsInProgress = true
                self.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
            }
        }
        task.resume()
    }
    
    func postCustomPoint(linkURL: String, completionHandler: (success: Bool, errorString: String?) -> Void){
        let request = NSMutableURLRequest(URL: NSURL(string: Constants.parseURL)!)
        request.HTTPMethod = "POST"
        
        /* pass credentials */
        request.addValue(Constants.appID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.apiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        /* Unwrap Optionals */
        if let lastName = appDelegate.udacityClient?.lastName {
            if let firstName = appDelegate.udacityClient?.firstName {
                if let userID = appDelegate.udacityClient?.userID {
                    
                    /* pass parameters for custom locations */
                    var bodyText = "{\"uniqueKey\": \"\(userID)\", \"firstName\": \"\(firstName)\", \"lastName\": \"\(lastName)\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(linkURL)\",\"latitude\": \(latitude), \"longitude\": \(longitude)}"
                    request.HTTPBody = bodyText.dataUsingEncoding(NSUTF8StringEncoding)
                    let task = session.dataTaskWithRequest(request) { data, response, error in
                        if error != nil {
                            /* network error  */
                            completionHandler(success: false, errorString: error.localizedDescription)
                        }
                        else{
                            /* successful response */
                            self.postPointInProgress = true
                            self.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
                        }
                    }
                    task.resume()
                }
            }
        }
    }
    
    func parseJSONWithCompletionHandler(data: NSData, completionHandler: ( success: Bool, errorString: String?) -> Void) {
        
        var parsingError: NSError? = nil
        
        /* convert data into JSON format */
        if let parsedResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &parsingError) as? NSDictionary{
            if parsedResult.objectForKey("error") == nil {
                /* saved data based on flags */
                if getResultsInProgress == true {
                    storedPoints = StudentLocation.locationsFromResults(parsedResult["results"] as! NSArray)
                    getResultsInProgress = false
                }
                else if postPointInProgress == true {
                    postPointInProgress = false
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
