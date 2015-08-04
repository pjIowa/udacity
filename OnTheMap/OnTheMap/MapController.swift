//
//  LocationController.swift
//  OnTheMap
//
//  Created by Prajwal Kedilaya on 7/21/15.
//  Copyright (c) 2015 Prajwal Kedilaya. All rights reserved.
//

import UIKit
import MapKit

class MapController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var map: MKMapView!
    
    var appDelegate: AppDelegate!
    
    /* Student Location endpoint */
    var parseURL = "https://api.parse.com/1/classes/StudentLocation"
    
    /* API credentials */
    var appID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    var apiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Get the app delegate */
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        /* add buttons to navigation bar */
        configureUI()
        getLocations()
    }
    
    func configureUI(){
        /* button to add custom points */
        var tempBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        tempBtn.setImage(pin, forState: UIControlState.Normal)
        tempBtn.addTarget(self, action: "addCustomPoint", forControlEvents: UIControlEvents.TouchUpInside)
        var mapButton = UIBarButtonItem(customView: tempBtn)
        
        /* button to refresh data*/
        var refreshButton:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: "refreshPoints")
        
        /* add refresh & new point buttons to top right on nav bar */
        parentViewController!.navigationItem.setRightBarButtonItems([refreshButton,mapButton], animated: true)
        
        /* button to log out */
        var button = UIBarButtonItem(title: "Log Out", style: UIBarButtonItemStyle.Plain, target: self, action: "logOut")
        parentViewController!.navigationItem.leftBarButtonItem = button
    }
    
    override func viewDidAppear(animated: Bool) {
        /* remove old annotations */
        map.removeAnnotations(map.annotations)
        
        /* show stored points */
        showLocations()
    }
    
    /* get all student locations from Parse Endpoint */
    func getLocations(){
        appDelegate.parseClient?.getResults({
            (success, errorString) in
            if success == false {
                /* show error */
                self.displayError(errorString)
            }})
    }
    
    func showLocations(){
        if let results = appDelegate.parseClient?.storedPoints{
            for result in results {
                /* add each point */
                showClassmate(result.name, url: result.url, latitude: result.latitude, longitude: result.longitude)
            }
        }
    }
    
    func refreshPoints(){
        if tabBarController?.selectedIndex == 0{
            /* get locations from Parse Endpoint */
            getLocations()
            
            /* remove annotations on map */
            map.removeAnnotations(map.annotations)
            
            /* show stored points */
            showLocations()
        }
        else{
            if let vcs = self.tabBarController!.viewControllers{
                /* reload data from table */
                var tableView:ListController = vcs[1] as! ListController
                tableView.table.reloadData()
            }
        }
    }
    
    func showClassmate(name:String, url:String, latitude:CLLocationDegrees, longitude:CLLocationDegrees) {
        dispatch_async(dispatch_get_main_queue(),{
            /*  drop a pin on the map */
            let location = CLLocationCoordinate2DMake(latitude, longitude)
            let dropPin = MKPointAnnotation()
            dropPin.coordinate = location
            dropPin.title = name
            dropPin.subtitle = url
            self.map.addAnnotation(dropPin)
        })
    }
    
    func displayError(errorString: String?) {
        dispatch_async(dispatch_get_main_queue(), {
            var alert = UIAlertView(title: "Error", message: errorString , delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        })
    }
    
    func logOut(){
        /* clear session */
        appDelegate.udacityClient!.endSession({
            (success, errorString) in
            if success {
                /* revert to login page */
                self.completeLogOut()
            } else {
                /* show error */
                self.displayError(errorString)
            }})
    }
    
    func completeLogOut(){
        dispatch_async(dispatch_get_main_queue(),{
            self.navigationController?.popViewControllerAnimated(true)
        })
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        let identifier = "pointID"
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
        
        if annotationView == nil {
            /* new annotation view w/ detail button */
            annotationView = MKPinAnnotationView(annotation:annotation, reuseIdentifier:identifier)
            annotationView.canShowCallout = true
            let btn = UIButton.buttonWithType(.DetailDisclosure) as! UIButton
            annotationView.rightCalloutAccessoryView = btn
        } else {
            /* reuse view and change the annotation */
            annotationView.annotation = annotation
        }
        
        return annotationView
    }
    
    func mapView(mapView: MKMapView!, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if annotationView.annotation.subtitle! != nil{
            /* open safari to student's link */
            UIApplication.sharedApplication().openURL(NSURL(string:annotationView.annotation.subtitle!)!)
        }
    }
    
    func addCustomPoint(){
        /* start process to add custom point */
        performSegueWithIdentifier("addCustomPoint", sender: self)
    }
}
