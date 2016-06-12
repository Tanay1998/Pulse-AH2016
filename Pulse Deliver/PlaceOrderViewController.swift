//
//  ReportViewController.swift
//  ThirdEye Reporter
//
//  Created by Tanay Kothari on 09/04/16.
//  Copyright © 2016 Tanay Kothari. All rights reserved.
//

import UIKit
import Parse
import MobileCoreServices

class PlaceOrderViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate
{
    @IBOutlet weak var mediaImageView: UIImageView!
    @IBOutlet weak var categoryField: UITextField!
    @IBOutlet weak var shopName: UITextField!
    @IBOutlet weak var productListField: UITextView!
    @IBOutlet weak var priceField: UITextField!
    
    var delivery: PFObject? = nil
    var file: PFFile? = nil
    var geo: PFGeoPoint? = nil
    
    var categories = ["Restaurant Pickup", "Groceries", "Medecines", "Cosmetics", "Stationery & Books", "Clothes", "Accessories", "Electronics", "Other"]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        categoryField.delegate = self
        shopName.delegate = self
        priceField.delegate = self
        
        let pickerView = UIPickerView()
        pickerView.showsSelectionIndicator = true
        pickerView.delegate = self
        pickerView.dataSource = self
        
        categoryField.inputView = pickerView
        
        let toolbar = UIToolbar(frame: CGRectMake(0, 0, 320, 44))
        toolbar.barStyle = .Default
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "donePicker")
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "cancelPicker")
        
        toolbar.setItems([cancelButton, UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil), doneButton], animated: true)
        
        categoryField.inputAccessoryView = toolbar
    }
    
    func donePicker ()
    {
        categoryField.resignFirstResponder()
    }
    
    func cancelPicker ()
    {
        categoryField.text = ""
        delivery!["category"] = ""
        categoryField.resignFirstResponder()
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return categories.count
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return categories[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        categoryField.text = categories[row]
        delivery!["category"] = categories[row]
    }
    
    @IBOutlet weak var imageButton: UIButton!
    
    @IBAction func clickPhoto()
    {
        if mediaImageView.image != nil
        {
            mediaImageView.image = nil
            imageButton.setTitle("TAP TO ATTACH IMAGE", forState: .Normal)
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.mediaTypes = [kUTTypeImage as String]
        let action = UIAlertController(title: "Upload a picture", message: "Choose photo source", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let click = UIAlertAction(title: "Use camera", style: UIAlertActionStyle.Default)
            {
                (action) -> Void in
                imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
                UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.None)
                self.presentViewController(imagePicker, animated: true, completion: nil)
        }
        
        let gallery = UIAlertAction(title: "Choose from Library", style: UIAlertActionStyle.Default)
            {
                (action) -> Void in
                imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
                self.presentViewController(imagePicker, animated: true, completion: nil)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel)
            {
                (action) -> Void in
                self.dismissViewControllerAnimated(true, completion: nil)
        }
        if UIImagePickerController.isSourceTypeAvailable(.Camera)
        {
            action.addAction(click)
        }
        action.addAction(gallery)
        action.addAction(cancel)
        self.presentViewController(action, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        let mediaType = (info as NSDictionary).objectForKey(UIImagePickerControllerMediaType) as! String
        var data : NSData? = nil
        if mediaType == kUTTypeImage as String
        {
            var image : UIImage
            image = (info as NSDictionary).objectForKey(UIImagePickerControllerOriginalImage) as! UIImage
            if picker.sourceType == .Camera
            {
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.None)
            }
            image = HelperMethods().resizeImage(image, width: image.size.width / 3, height: image.size.height / 3)
            mediaImageView.image = image
            data = UIImagePNGRepresentation(image)
            imageButton.setTitle("TAP TO REMOVE", forState: .Normal)
        }
        
        if data != nil
        {
            if let d = data
            {
                file = PFFile(data: d)
                file?.saveInBackground()
                delivery!["media"] = file
            }
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func cancel()
    {
        clear(self)
        self.navigationController?.popToRootViewControllerAnimated(false)
    }
    
    @IBAction func clear(sender: AnyObject)
    {
        emptyFields()
        delivery = PFObject(className: "Delivery")
    }
    
    func emptyFields ()
    {
        mediaImageView.image = nil
        categoryField.text = ""
        shopName.text = ""
        productListField.text = ""
        priceField.text = ""
    }
    
    @IBAction func submit(sender: AnyObject)
    {
        if categoryField.text?.characters.count < 1
        {
            let alert = UIAlertController(title: "No Category", message: "Enter a category to report this complaint", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        if productListField.text.characters.count == 0
        {
            let alert = UIAlertController(title: "No Order", message: "Please provide an order ID or a list of products you would like to purchase", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        if priceField.text?.characters.count == 0
        {
            let alert = UIAlertController(title: "No Price estimate", message: "Please provide an extimate of the price", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        delivery!["shopName"] = shopName.text!
        delivery!["price"] = priceField.text!
        delivery!["category"] = categoryField.text!
        delivery!["productList"] = productListField.text
        delivery!["orderer"] = PFUser.currentUser()

        delivery?.saveInBackgroundWithBlock(
        {
            (succ, err) -> Void in
            self.performSegueWithIdentifier("next", sender: self)
            self.emptyFields()
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "next"
        {
            let dest = segue.destinationViewController as! FinishOrderViewController
            dest.delivery = self.delivery
        }
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
        if textField.tag == 3
        {
            submit(self)
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