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
import Firebase

class YeahFinishViewController: UIViewController
{
    var delivery: PFObject? = nil
    
    @IBOutlet weak var image: PFImageView!
    @IBOutlet weak var nameField: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var rating: UILabel!
    let root = Firebase(url: "https://pulsedeliver.firebaseio.com/deliveries")
    
    @IBAction func call()
    {
        let deliverer = delivery!["deliverer"]
        let number = deliverer["username"] as! String
        UIApplication.sharedApplication().openURL(NSURL(string: "tel://\(number)")!)
    }
    
    @IBAction func cancel()
    {
        delivery?.deleteInBackground()
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    override func viewWillAppear(animated: Bool)
    {
        let id = delivery?.objectId
        let q = PFQuery(className: "Delivery").whereKey("objectId", equalTo: id!).includeKey("deliverer")
        q.findObjectsInBackgroundWithBlock
        {
            (objects, err) -> Void in
            if objects != nil && err == nil
            {
                self.delivery = objects![0]
                let del = self.delivery!["deliverer"] as! PFUser
                self.image.file = del["profilePic"] as? PFFile
                self.image.loadInBackground()
            }
        }
        
        root.observeEventType(.Value, withBlock:
        {
            (snapshot) -> Void in
            print(snapshot.value)
            if let x = snapshot.value as? NSDictionary
            {
                if x[self.delivery!.objectId!] as! String == "Finished"
                {
                    self.performSegueWithIdentifier("pay", sender: self)
                    return
                }
            }
        })
        self.navigationController?.navigationBar.backItem?.hidesBackButton = true
        print(delivery)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "pay"
        {
            let dest = segue.destinationViewController as! PayChotuViewController
            dest.delivery = self.delivery
        }
    }
}
