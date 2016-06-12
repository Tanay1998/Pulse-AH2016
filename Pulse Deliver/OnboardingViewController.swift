//
//  LoginViewController.swift
//  ThirdEye Reporter
//
//  Created by Tanay Kothari on 10/04/16.
//  Copyright © 2016 Tanay Kothari. All rights reserved.
//

import UIKit
import Parse

class OnboardingViewController: UIViewController
{
    override func viewWillAppear(animated: Bool)
    {
        navigationController?.navigationBarHidden = true
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: .Slide)
    }
}
