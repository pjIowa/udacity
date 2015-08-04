//
//  MemeViewController.swift
//  MemeMe
//
//  Created by Prajwal Kedilaya on 6/29/15.
//  Copyright (c) 2015 Prajwal Kedilaya. All rights reserved.
//

import UIKit

class MemeViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var memeBackgroundView: UIImageView!
    @IBOutlet weak var camButton: UIBarButtonItem!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var bottomBar: UIToolbar!
    
    //keyboard height
    var kbHeight: CGFloat!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //disable camera button if not available
        camButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        setTextFieldAppearance(topText)
        setTextFieldAppearance(bottomText)
        
        //monitor when keyboard pulls up
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    @IBAction func showOptions(sender: AnyObject) {
        //create meme
        var meme = Meme(topText: topText.text, bottomText: bottomText.text, memeImage: generateMemedImage() )
        
        //create activity controller
        let activityViewController = UIActivityViewController(
            activityItems: [generateMemedImage()],
            applicationActivities: nil)
        activityViewController.completionWithItemsHandler = {
            activity, success, items, error in
            
            //save meme if user performs anything other than cancel
            if success {
                self.save(meme)
            }
            return
        }
        
        //present modally
        presentViewController(activityViewController,
            animated: true,
            completion: nil)
    }
    
    @IBAction func dismissMeme(sender: AnyObject) {
        //dismiss modal controller
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func pickFromAlbum(sender: AnyObject) {
        //pull up photo library for selection
        let pc = UIImagePickerController()
        pc.delegate = self
        pc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(pc, animated: true, completion: nil)
        
    }
    @IBAction func pickFromCamera(sender: AnyObject) {
        //activate camera to use
        let pc = UIImagePickerController()
        pc.delegate = self
        pc.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(pc, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]){
        //set meme background if valid picture selected
        if let image = info[ UIImagePickerControllerOriginalImage] as? UIImage {
            memeBackgroundView.image = image
        }
        
        //dismiss image picker
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func save(meme:Meme) {
        //add meme to app delegate storage
        let del = UIApplication.sharedApplication().delegate as! AppDelegate
        del.memes.append(meme)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        //stop monitoring keyboard
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func generateMemedImage() -> UIImage {
        //capture image of screen
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //vertical offset of nav bar and status bar
        let yOffset = navBar.bounds.height+UIApplication.sharedApplication().statusBarFrame.size.height
        
        //crop out nav bar, toolbar, and status bar
        let rect: CGRect = CGRectMake(0, yOffset, navBar.bounds.width, memedImage.size.height-bottomBar.bounds.height-yOffset)
        
        //necessary type conversions
        let imageRef: CGImageRef = CGImageCreateWithImageInRect(memedImage.CGImage, rect)
        let image: UIImage = UIImage(CGImage: imageRef, scale: memedImage.scale, orientation: memedImage.imageOrientation)!
        
        return image
    }
    
    func animateTextField(up:Bool){
        //determine whether to move background up or down
        var movement = (up ? -kbHeight : kbHeight)
        
        //animate background in direction
        UIView.animateWithDuration(0.3, animations:
            {self.view.frame = CGRectOffset(self.view.frame, 0, movement)}
        )
    }
    
    func setTextFieldAppearance(textfield:UITextField){
        //create meme font
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -5
        ]
        
        textfield.defaultTextAttributes = memeTextAttributes
        textfield.textAlignment = .Center
        
    }
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        //dismiss even if user cancels
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func keyboardWillShow(not: NSNotification){
        //check for user information
        if let userInfo = not.userInfo {
            
            //check for keyboard size
            if let keyboardSize =  (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                
                //check if bottom text field
                if bottomText.isFirstResponder() == true{
                    
                    //store keyboard height
                    kbHeight = keyboardSize.height
                    
                    //move up background
                    animateTextField(true)
                }
                else{
                    kbHeight = 0
                }
            }
        }
    }
    
    func keyboardWillHide(not: NSNotification){
        //move down background
        animateTextField(false)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        //clear text field when intially selected
        if textField.text == "TOP" || textField.text == "BOTTOM"{
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        //drop keyboard
        textField.resignFirstResponder()
        return true
    }

}
