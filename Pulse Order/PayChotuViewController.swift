//
//  PayChotuViewController.swift
//  ThirdEye Reporter
//
//  Created by Tanay Kothari on 12/06/16.
//  Copyright © 2016 Tanay Kothari. All rights reserved.
//

import UIKit
import Parse

class PayChotuViewController: UIViewController
{
    var delivery: PFObject? = nil
    
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var deliveryPrice: UILabel!
    @IBOutlet weak var orderPrice: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func payWithCash(sender: AnyObject)
    {
        pay()
    }
    
    @IBAction func payWithStripe(sender: AnyObject)
    {
        pay()
    }

    func pay ()
    {
        performSegueWithIdentifier("rate", sender: self)
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
