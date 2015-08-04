//
//  ViewController.swift
//  OnTheMap
//
//  Created by Prajwal Kedilaya on 7/20/15.
//  Copyright (c) 2015 Prajwal Kedilaya. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    /* Udacity Sign Up URL */
    var signupURL: String = "https://www.udacity.com/account/auth#!/signin"
    
    var appDelegate: AppDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Get the app delegate */
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    }
    
    
    @IBAction func signUp(sender: AnyObject) {
        /* open safari to sign up for udacity */
        UIApplication.sharedApplication().openURL(NSURL(string:signupURL)!)
    }

    @IBAction func login(sender: AnyObject) {
        appDelegate.udacityClient!.authenticateWithCredentials(
            email.text,
            password: password.text,
            completionHandler: {
                (success, errorString) in
                if success {
                    /* go to primary screen */
                    self.completeLogin()
                } else {
                    /* show error */
                    self.displayError(errorString)
                }
        })
    }
    
    func completeLogin() {
        dispatch_async(dispatch_get_main_queue(), {
            self.performSegueWithIdentifier("login", sender: self)
        })
    }
    
    func displayError(errorString: String?) {
        dispatch_async(dispatch_get_main_queue(), {
            var alert = UIAlertView(title: "Error", message: errorString , delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        })
    }
    
    /* close keyboard on return key press */
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    /* show default text if no values were entered */
    func textFieldDidEndEditing(textField: UITextField) {
        if email.text == ""{
            email.text = "Email"
        }
        
        if password.text == "" {
            password.text = "Password"
        }
    }
}

