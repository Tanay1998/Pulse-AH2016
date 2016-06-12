//
//  DeliveryConfirmViewController.swift
//  ThirdEye Deliver
//
//  Created by Tanay Kothari on 12/06/16.
//  Copyright © 2016 Tanay Kothari. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import Firebase

class DeliveryConfirmViewController: UIViewController, UITextFieldDelegate
{
    
    @IBOutlet weak var image: PFImageView!
    @IBOutlet weak var name: UITextField!
    
    @IBOutlet weak var price: UITextField!
    @IBOutlet weak var products: UITextView!
    @IBOutlet weak var shop: UITextField!
    @IBOutlet weak var address: UILabel!
    
    var delivery: PFObject?
    
    override func  viewDidAppear(animated: Bool)
    {
        price.delegate = self
        price.text = delivery!["price"] as? String
        products.text = delivery!["productList"] as? String
        address.text = delivery!["dropAddress"] as? String
        shop.text = delivery!["shopName"] as? String
        let user = delivery!["orderer"] as! PFUser
        name.text = user["name"] as? String
        if let media = delivery!["price"] as? PFFile
        {
            image.file = media
            image.loadInBackground({ (img, error) -> Void in })
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    let root = Firebase(url:"https://pulsedeliver.firebaseio.com/deliveries")
    @IBAction func yes(sender: AnyObject)
    {
        delivery!["price"] = price.text
        delivery!["productList"] = products.text
        delivery?.saveInBackground()
        root.childByAppendingPath(self.delivery?.objectId).setValue("Finished")
        self.performSegueWithIdentifier("rate", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "rate"
        {
            let dest = segue.destinationViewController as! RatingsViewController
            dest.delivery = self.delivery
        }
    }
}
