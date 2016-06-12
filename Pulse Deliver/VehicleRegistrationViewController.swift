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
import MobileCoreServices

class VehicleRegistrationViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate
{
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var vehicleType: UITextField!
    @IBOutlet weak var vehicleNumber: UITextField!
    @IBOutlet weak var imageButton: UIButton!
    
    var categories = ["Foot", "Rickshaw", "Bike", "Auto", "Car"]
    
    var user: PFUser?
    
    override func viewDidLoad()
    {
        navigationController?.navigationBarHidden = true
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: .Slide)
        
        user = PFUser.currentUser()
        vehicleType.delegate = self
        vehicleNumber.delegate = self
        
        let pickerView = UIPickerView()
        pickerView.showsSelectionIndicator = true
        pickerView.delegate = self
        pickerView.dataSource = self
        
        vehicleType.inputView = pickerView
        
        let toolbar = UIToolbar(frame: CGRectMake(0, 0, 320, 44))
        toolbar.barStyle = .Default
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "donePicker")
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "cancelPicker")
        
        toolbar.setItems([cancelButton, UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil), doneButton], animated: true)
        
        vehicleType.inputAccessoryView = toolbar
    }
    
    func donePicker ()
    {
        vehicleType.resignFirstResponder()
    }
    
    func cancelPicker ()
    {
        vehicleType.text = ""
        user!["vehicleType"] = ""
        vehicleType.resignFirstResponder()
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
        vehicleType.text = categories[row]
        user!["vehicleType"] = categories[row]
        if row == 0 || row == 1
        {
            vehicleType.enabled = false
        }
        else
        {
            vehicleType.enabled = true
        }
    }

    
    @IBAction func clickPhoto()
    {
        if image.image != nil
        {
            image.image = nil
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
            var img : UIImage
            img = (info as NSDictionary).objectForKey(UIImagePickerControllerOriginalImage) as! UIImage
            if picker.sourceType == .Camera
            {
                UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil)
                UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.None)
            }
            img = ImageMethods().resizeImage(img, width: 200.0, height: 200.0)
            image.image = img
            data = UIImagePNGRepresentation(img)
        }
        
        if data != nil
        {
            if let d = data
            {
                let file = PFFile(data: d)
                file?.saveInBackground()
                user!["profilePic"] = file
            }
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func register()
    {
        user!["vehicleNumber"] = vehicleNumber.text!
        user?.saveInBackground()
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
}
