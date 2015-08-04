//
//  MakerController.swift
//  OnTheMap
//
//  Created by Prajwal Kedilaya on 7/22/15.
//  Copyright (c) 2015 Prajwal Kedilaya. All rights reserved.
//

import UIKit
import CoreLocation

class MakerController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var locationText: UITextField!
    var appDelegate: AppDelegate!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        /* hide activity indicator until view appears */
        activityIndicator.hidden = true
    }
    
    /* close keyboard on return key press */
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func cancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func findOnMap(sender: AnyObject) {
        
        /* start animating activity indicator */
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        
        /* store address query */
        var locationStr = locationText.text
        appDelegate.parseClient?.mapString = locationStr
        
        /* get latitude and longitude from address */
        var geocoder = CLGeocoder()
        geocoder.geocodeAddressString(locationStr, completionHandler: {(placemarks: [AnyObject]!, error: NSError!) -> Void in
            if let placemark = placemarks?[0] as? CLPlacemark {
                /* successful geocode */
                dispatch_async(dispatch_get_main_queue(),{
                    /* save placemark from geocoding */
                    self.appDelegate.parseClient?.customLocation = placemark
                    
                    /* stop activity indicator after map is done loading */
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.hidden = true
                    
                    /* next step to create student location */
                    self.performSegueWithIdentifier("addLink", sender: self)
                })
            }
            else{
                /* show why geocoding failed */
                var alert = UIAlertView(title: "Error", message: error.localizedDescription, delegate: nil, cancelButtonTitle: "OK")
                alert.show()
            }
        })
        
    }
}
