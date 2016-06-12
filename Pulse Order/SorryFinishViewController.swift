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

class SorryFinishViewController: UIViewController
{
    var delivery: PFObject?
    
    @IBAction func retry()
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func cancel()
    {
        delivery?.deleteInBackground()
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
}
