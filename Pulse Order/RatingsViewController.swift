//
//  FinishViewController.swift
//  ThirdEye Reporter
//
//  Created by Tanay Kothari on 09/04/16.
//  Copyright © 2016 Tanay Kothari. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class RatingsViewController: UIViewController, UITextFieldDelegate
{
    override func viewDidLoad() {
        comment.delegate = self
        let del = self.delivery!["deliverer"] as! PFUser
        self.image.file = del["profilePic"] as? PFFile
        self.image.loadInBackground()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBOutlet weak var image: PFImageView!
    var delivery: PFObject?
    
    @IBOutlet weak var comment: ProximityTextField!
    @IBOutlet var buttons: [UIButton]!
    
    var rank = 0
    @IBAction func rate(sender: AnyObject)
    {
        let t = sender.tag
        for i in 0..<5
        {
            buttons[i].selected = false
        }
        for i in 0..<t
        {
            buttons[i].selected = true
        }
        rank = t
    }
    
    @IBAction func submit()
    {
        let feedback = PFObject(className: "Feedback")
        feedback["delivery"] = delivery
        feedback["to"] = delivery!["deliverer"]
        feedback["rating"] = rank
        feedback["comment"] = comment.text
        feedback.saveInBackground()
        self.navigationController?.popToRootViewControllerAnimated(true)
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
