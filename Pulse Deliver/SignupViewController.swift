//
//  SignupViewController.swift
//  ThirdEye Reporter
//
//  Created by Tanay Kothari on 10/04/16.
//  Copyright © 2016 Tanay Kothari. All rights reserved.
//

import UIKit
import Parse

class SignupViewController: UIViewController, UITextFieldDelegate
{
    @IBOutlet weak var nameTextbox: UITextField!
    @IBOutlet weak var handleTextbox: UITextField!
    @IBOutlet weak var emailTextbox: UITextField!
    @IBOutlet weak var passwordTextbox: UITextField!
    @IBOutlet weak var confirmTextbox: UITextField!
    
    var signingUp = false
    override func viewWillAppear(animated: Bool)
    {
        nameTextbox.delegate = self
        handleTextbox.delegate = self
        emailTextbox.delegate = self
        passwordTextbox.delegate = self
        confirmTextbox.delegate = self
    }
    
    override func viewDidAppear(animated: Bool)
    {
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.Slide)
        self.navigationController?.navigationBar.hidden = true
    }
    
    @IBAction func back()
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func signup()
    {
        if (signingUp)
        {
            return
        }
        
        let charSet =   NSCharacterSet.whitespaceAndNewlineCharacterSet()
        let username =  handleTextbox.text!.stringByTrimmingCharactersInSet(charSet)
        let password =  passwordTextbox.text!.stringByTrimmingCharactersInSet(charSet)
        let name =      nameTextbox.text!.stringByTrimmingCharactersInSet(charSet)
        let email =     emailTextbox.text!.stringByTrimmingCharactersInSet(charSet)
        let confirm = confirmTextbox.text!.stringByTrimmingCharactersInSet(charSet)
        
        if (username.characters.count > 15)
        {
            let alert = UIAlertController(title: "Oops!", message: "Your username needs to be smaller than 15 characters" , preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else if (username.characters.count == 0 || password.characters.count == 0)
        {
            let alert = UIAlertController(title: "Oops", message: "Make sure you have entered your phone number and password" ,
                preferredStyle:UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil));
            self.presentViewController(alert, animated: true, completion: nil);
        }
        else if (username.rangeOfString(" ") != nil)
        {
            let alert = UIAlertController(title: "Oops", message: "Your phone number cannot contain spaces" ,
                preferredStyle:UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil));
            self.presentViewController(alert, animated: true, completion: nil);
        }
        else if (name.characters.count == 0)
        {
            let alert = UIAlertController(title: "Oops", message: "Make sure you have entered your name" ,
                preferredStyle:UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil));
            self.presentViewController(alert, animated: true, completion: nil);
        }
        else if (confirm != password)
        {
            let alert = UIAlertController(title: "Oops", message: "Your passwords do not match" ,
                preferredStyle:UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil));
            self.presentViewController(alert, animated: true, completion: nil);
        }
        else
        {
            signingUp = true
            let user = PFUser()
            user.username = username
            user.password = password
            user["email"] = ""
            user["address"] = ""
            user["vehicleType"] = ""
            user["vehicleNumber"] = ""
            user["userType"] = "Deliverer"
            user["name"] = name
            
            if email.characters.count > 5
            {
                user.email = email
            }
            
            user["profilePic"] = PFFile(name: "profilePicture", data: UIImagePNGRepresentation(UIImage(named: "dummy")!)!)
            user.signUpInBackgroundWithBlock(
            {
                (user, error) -> Void in
                self.signingUp = false
                if error != nil
                {
                    let alert = UIAlertController(title: "Sorry!", message: error!.localizedDescription, preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil));
                    self.presentViewController(alert, animated: true, completion: nil)
                }
                else
                {
                    self.navigationController?.navigationBarHidden = false
                    self.performSegueWithIdentifier("vehicle", sender: self)
                }
                    
            })
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    var KEYBOARD_ANIMATION_DURATION = 0.3 as NSTimeInterval
    var MINIMUM_SCROLL_FRACTION = 0.2 as CGFloat
    var MAXIMUM_SCROLL_FRACTION = 0.8 as CGFloat
    var PORTRAIT_KEYBOARD_HEIGHT = 216 as CGFloat
    var animatedDistance: CGFloat = 0.0
    
    func textFieldDidBeginEditing(textField: UITextField)
    {
        let textFieldRect = self.view.window?.convertRect(textField.bounds, fromView: textField)
        let viewRect = self.view.window?.convertRect(self.view.bounds, fromView: self.view)
        
        let midline: CGFloat = textFieldRect!.origin.y + 0.5 * textFieldRect!.size.height as CGFloat
        let numerator: CGFloat = midline - viewRect!.origin.y - MINIMUM_SCROLL_FRACTION * viewRect!.size.height as CGFloat
        let denominator: CGFloat = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect!.size.height as CGFloat
        var heightFrac: CGFloat = numerator / denominator as CGFloat
        if heightFrac < 0 { heightFrac = 0 }
        if heightFrac > 1 { heightFrac = 1 }
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFrac);
        var viewFrame: CGRect = self.view.frame
        viewFrame.origin.y -= animatedDistance
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(KEYBOARD_ANIMATION_DURATION)
        
        self.view.frame = viewFrame
        UIView.commitAnimations()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        if textField.tag == 5
        {
            signup()
        }
        else
        {
            let nextField = textField.superview?.viewWithTag(textField.tag + 1) as! UITextField
            nextField.becomeFirstResponder()
        }
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField)
    {
        var viewFrame: CGRect = self.view.frame
        viewFrame.origin.y += animatedDistance
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(KEYBOARD_ANIMATION_DURATION)
        
        self.view.frame = viewFrame
        UIView.commitAnimations()
    }
}
