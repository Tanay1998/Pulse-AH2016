//
//  LoginViewController.swift
//  ThirdEye Reporter
//
//  Created by Tanay Kothari on 10/04/16.
//  Copyright © 2016 Tanay Kothari. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController, UITextFieldDelegate
{
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewWillAppear(animated: Bool)
    {
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.Slide)
        self.navigationController?.navigationBar.hidden = true
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        emailField.delegate = self
        passwordField.delegate = self
    }
    
    @IBAction func back()
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func login()
    {
        let username = emailField.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let password = passwordField.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        if (username.characters.count == 0 || password.characters.count == 0)
        {
            if (username.characters.count + password.characters.count > 0)
            {
                let alert = UIAlertController(title: "Oops", message: "Make sure you have entered your username and password" , preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil));
                self.presentViewController(alert, animated: true, completion: nil);
            }
        }
        else
        {
            PFUser.logInWithUsernameInBackground(username, password: password, block:
                {
                    (user, error) -> Void in
                    if (error != nil)
                    {
                        let alert = UIAlertController(title: "Error", message: error!.userInfo["error"] as? String , preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil));
                        self.presentViewController(alert, animated: true, completion: nil);
                    }
                    else
                    {
                        self.navigationController?.navigationBarHidden = false
                        self.navigationController?.popToRootViewControllerAnimated(true);
                    }
            })
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        if textField.tag == 1
        {
            let nextField = textField.superview?.viewWithTag(2) as! UITextField
            nextField.becomeFirstResponder()
        }
        else
        {
            textField.resignFirstResponder()
            login()
        }
        return true
    }
}
