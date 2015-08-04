//
//  LinkController.swift
//  OnTheMap
//
//  Created by Prajwal Kedilaya on 7/23/15.
//  Copyright (c) 2015 Prajwal Kedilaya. All rights reserved.
//

import UIKit
import MapKit

class LinkController: UIViewController, MKMapViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var customLink: UITextField!
    @IBOutlet weak var previewMap: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var appDelegate: AppDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        /* add custom point to map */
        previewMap.addAnnotation(MKPlacemark(placemark: appDelegate.parseClient!.customLocation))
        
        /* zoom into custom point */
        let pmCircularRegion = appDelegate.parseClient!.customLocation!.region as! CLCircularRegion
        let region = MKCoordinateRegionMakeWithDistance(
            pmCircularRegion.center,
            pmCircularRegion.radius,
            pmCircularRegion.radius) as MKCoordinateRegion
        previewMap.setRegion(region, animated: true)
        
        /* pull GPS point from student location */
        appDelegate.parseClient?.latitude = "\(pmCircularRegion.center.latitude)"
        appDelegate.parseClient?.longitude = "\(pmCircularRegion.center.longitude)"
        
        /* hide activity indicator until view appears */
        activityIndicator.hidden = true
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        /* start animating activity indicator */
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
    }
    
    func mapViewDidFinishLoadingMap(mapView: MKMapView!) {
        /* stop activity indicator after map is done loading */
        activityIndicator.stopAnimating()
        activityIndicator.hidden = true
    }
    
    @IBAction func cancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func submitPoint(sender: AnyObject) {
        /* check url for valid prefix */
        if (customLink.text.hasPrefix("http://")||customLink.text.hasPrefix("https://")){
            /* start web request chain to submit point */
            getUserData()
        }
        else{
            /* invalid url format, only http://www or https://www */
            var alert = UIAlertView(title: "Error", message: "Invalid link. Needs to start with http or https://", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
    }
    
    func getUserData(){
        /* perform request to get user's name on Udacity*/
        appDelegate.udacityClient!.getUserData({
            (success, errorString) in
            if success {
                /* post data to Parse Endpoint */
                self.postCustomPoint()
            } else {
                /* show error */
                self.displayError(errorString)
            }
        })
    }
    
    func postCustomPoint(){
        /* submit custom location */
        appDelegate.parseClient!.postCustomPoint(
            self.customLink.text,
            completionHandler:{
                (success, errorString) in
                if success {
                    /* update stored points in Parse Client */
                    self.getLocations()
                } else {
                    /* show error */
                    self.displayError(errorString)
                }
            }
        )
    }
    
    func getLocations(){
        appDelegate.parseClient?.getResults({
            (success, errorString) in
            if success {
                /* revert to map of student locations */
                self.revertToMap()
            }
            else{
                /* show error */
                self.displayError(errorString)
            }
        })
    }
    
    func revertToMap(){
        dispatch_async(dispatch_get_main_queue(), {
            /* dismiss two modal views */
            presentingViewController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        })
    }
    
    func displayError(errorString: String?) {
        dispatch_async(dispatch_get_main_queue(), {
            var alert = UIAlertView(title: "Error", message: errorString , delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        })
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
