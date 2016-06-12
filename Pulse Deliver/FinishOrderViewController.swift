//
//  ReportViewController.swift
//  ThirdEye Reporter
//
//  Created by Tanay Kothari on 09/04/16.
//  Copyright © 2016 Tanay Kothari. All rights reserved.
//

import UIKit
import Parse
import GoogleMaps
import CoreLocation

class FinishOrderViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate, UITextFieldDelegate
{
    var delivery: PFObject? = nil
    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var locationText: UITextField!
    
    var timer: NSTimer = NSTimer()
    var timeElapsed: Float = 0
    
    override func viewDidAppear(animated: Bool)
    {
        locationText.text = delivery!["dropAddress"] as! String
        let coord = delivery!["dropLocation"] as! PFGeoPoint
        loadMap(coord.latitude, lng: coord.longitude)
        UIApplication.sharedApplication().setStatusBarStyle(.Default, animated: true)
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: .Slide)
        self.navigationController?.navigationBar.hidden = true
    }
    
    func secondTick ()
    {
        timeElapsed++
        self.progressBar.progress = timeElapsed / Float(12000)
        
        if progressBar.progress > 0.2
        {
        //    accept()
        }
        
        if progressBar.progress > 0.99
        {
            self.performSegueWithIdentifier("sorry", sender: self)
            timer.invalidate()
        }
    }
    
    func accept()
    {
        timer.invalidate()
        self.performSegueWithIdentifier("yeah", sender: self)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        timeElapsed = 0
        timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: "secondTick", userInfo: nil, repeats: true)
    }
    
    @IBAction func cancel()
    {
        delivery?.deleteInBackground()
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
    }
    
    @IBOutlet weak var map: UIView!
    let locMarker = GMSMarker()
    var mapView: GMSMapView? = nil
    func loadMap (lat: Double, lng: Double)
    {
        let camera = GMSCameraPosition.cameraWithLatitude(lat, longitude: lng, zoom: 14)
        let rect = self.view.bounds
        mapView = GMSMapView.mapWithFrame(rect, camera:camera)
        
        locMarker.position = camera.target
        locMarker.map = mapView
        mapView!.delegate = self
        self.map.addSubview(mapView!)
        
        mapView?.settings.setAllGesturesEnabled(false)
        mapView?.myLocationEnabled = true
        mapView?.settings.myLocationButton = true
        mapView?.settings.compassButton = true
    }
}