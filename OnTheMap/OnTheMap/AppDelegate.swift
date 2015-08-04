//
//  AppDelegate.swift
//  OnTheMap
//
//  Created by Prajwal Kedilaya on 7/20/15.
//  Copyright (c) 2015 Prajwal Kedilaya. All rights reserved.
//

import UIKit
import CoreLocation

var pin:UIImage!

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var udacityClient: UdacityClient?
    var parseClient: ParseClient?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        /* set pin image blue, keep background clear */
        pin = makeBlue(UIImage(named: "pin")!)
        
        /* create client */
        udacityClient = UdacityClient()
        parseClient = ParseClient()
        
        return true
    }
    
    /* routine to color image blue, other than background */
    func makeBlue(image: UIImage)->UIImage{
        var rect:CGRect = CGRectMake(0, 0, image.size.width, image.size.height);
        UIGraphicsBeginImageContext(rect.size);
        var context:CGContextRef  = UIGraphicsGetCurrentContext();
        CGContextClipToMask(context, rect, image.CGImage);
        CGContextSetFillColorWithColor(context, UINavigationBar().tintColor.CGColor);
        CGContextFillRect(context, rect);
        var img:UIImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        var flippedImage: UIImage = UIImage(CGImage: img.CGImage, scale: 1.0, orientation: UIImageOrientation.DownMirrored)!
        return flippedImage
    }
}