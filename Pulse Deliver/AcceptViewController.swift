//
//  AcceptViewController.swift
//  ThirdEye Deliver
//
//  Created by Tanay Kothari on 12/06/16.
//  Copyright © 2016 Tanay Kothari. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import Firebase

class AcceptViewController: UIViewController
{
    @IBOutlet weak var image: PFImageView!
    @IBOutlet weak var name: UITextField!

    @IBOutlet weak var price: UITextField!
    @IBOutlet weak var products: UITextView!
    @IBOutlet weak var shop: UITextField!
    @IBOutlet weak var category: UITextField!
    @IBOutlet weak var address: UILabel!
    
    var delivery: PFObject?
    
    override func viewDidAppear(animated: Bool)
    {
        price.text = delivery!["price"] as? String
        products.text = delivery!["productList"] as? String
        address.text = delivery!["dropAddress"] as? String
        category.text = delivery!["category"] as? String
        shop.text = delivery!["shopName"] as? String
        let user = delivery!["orderer"] as! PFUser
        name.text = user["name"] as? String
        if let media = delivery!["price"] as? PFFile
        {
            image.file = media
            image.loadInBackground({ (img, error) -> Void in })
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    let root = Firebase(url:"https://pulsedeliver.firebaseio.com/deliveries")
    @IBAction func yes(sender: AnyObject)
    {
        delivery!["deliverer"] = PFUser.currentUser()
        delivery?.saveInBackground()
        root.childByAppendingPath(self.delivery?.objectId).setValue("In Progress")
        self.performSegueWithIdentifier("accepted", sender: self)
    }
    
    @IBAction func no(sender: AnyObject)
    {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "accepted"
        {
            let dest = segue.destinationViewController as! DeliveryDoingViewController
            dest.delivery = self.delivery
        }
    }
}
