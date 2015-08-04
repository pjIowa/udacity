//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Prajwal Kedilaya on 7/29/15.
//  Copyright (c) 2015 Prajwal Kedilaya. All rights reserved.
//

import Foundation
import CoreLocation

struct StudentLocation {
    
    var name = ""
    var latitude:CLLocationDegrees = 0
    var longitude:CLLocationDegrees = 0
    var url = ""
    
    init(){}
    
    /* Construct a StudentLocation from a dictionary */
    init(dictionary: [String : AnyObject]) {
        let fname = dictionary["firstName"]! as! String
        let lname = dictionary["lastName"]! as! String
        name = fname + " " + lname
        latitude = dictionary["latitude"]! as! CLLocationDegrees
        longitude = dictionary["longitude"]! as! CLLocationDegrees
        url = dictionary["mediaURL"]! as! String
    }
    
    /* Helper: Given an array of dictionaries, convert them to an array of StudentLocation objects */
    static func locationsFromResults(results: NSArray) -> [StudentLocation] {
        var locations = [StudentLocation]()
        
        for result in results {
            locations.append(StudentLocation(dictionary: result as! [String : AnyObject]))
        }
        
        return locations
    }
}