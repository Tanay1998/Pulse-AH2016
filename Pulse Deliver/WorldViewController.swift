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
import Firebase

class WorldViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate, UITextFieldDelegate
{
    var geo: PFGeoPoint? = nil
    @IBOutlet weak var pickupField: UITextField!
    let root = Firebase(url: "https://pulsedeliver.firebaseio.com/deliveries")
    var rejects = Set([""])
    override func viewWillAppear(animated: Bool)
    {
        if PFUser.currentUser() == nil
        {
            return
        }
        root.observeEventType(.Value, withBlock:
        {
            (snapshot) -> Void in
            print(snapshot.value)
            if let x = snapshot.value as? NSDictionary
            {
                for (key, value) in x
                {
                    print(key)
                    print(value)
                    if value as! String == "Open" && !self.rejects.contains(key as! String)
                    {
                        self.queryFor(key as! String)
                    }
                }
            }
        })
    }
    
    var delivery: PFObject? = nil
    
    func queryFor (id: String)
    {
        let q = PFQuery(className: "Delivery").whereKey("objectId", equalTo: id).includeKey("orderer")
        print(id)
        q.findObjectsInBackgroundWithBlock
        {
            (objects, error) -> Void in
            print (error)
            print(objects)
            if objects!.count > 0
            {
                let t = objects![0]
                self.delivery = t
                let text = "Delivery for around \(t["price"]) for '\(t["category"]) to be delivered to \(t["dropAddress"])"
                print(text)
                let action = UIAlertController(title: "New trip in your locality", message: text, preferredStyle: .Alert)
                
                let click = UIAlertAction(title: "View", style: UIAlertActionStyle.Default)
                {
                    (action) -> Void in
                    self.dismissViewControllerAnimated(true, completion:nil)
                    self.performSegueWithIdentifier("accept", sender: self)
                }
                
                let cancel = UIAlertAction(title: "Reject", style: UIAlertActionStyle.Cancel)
                    {
                        (action) -> Void in
                        self.rejects.insert(id)
                        self.dismissViewControllerAnimated(true, completion: nil)
                }
                action.addAction(click)
                action.addAction(cancel)
                self.presentViewController(action, animated: true, completion: nil)
            }
        }
    }
    
    override func viewDidAppear(animated: Bool)
    {
        UIApplication.sharedApplication().setStatusBarStyle(.Default, animated: true)
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: .Slide)
        self.navigationController?.navigationBar.hidden = true
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        pickupField.delegate = self
        
        if PFUser.currentUser() == nil
        {
            self.performSegueWithIdentifier("onboard", sender: self)
            return
        }
        self.getLocation()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        // Send over delivery to the next page
        if segue.identifier == "accept"
        {
            let dest = segue.destinationViewController as! AcceptViewController
            dest.delivery = self.delivery
        }
    }
    
    @IBOutlet weak var map: UIView!
    let locMarker = GMSMarker()
    var mapView: GMSMapView? = nil
    
    func loadMap (lat: Double, lng: Double)
    {
        let camera = GMSCameraPosition.cameraWithLatitude(lat, longitude: lng, zoom: 14)
        let rect = self.map.bounds
        mapView = GMSMapView.mapWithFrame(rect, camera:camera)
        
        locMarker.position = camera.target
        locMarker.map = mapView
        locMarker.icon = UIImage(named: "Pin")
        mapView!.delegate = self
        self.map.addSubview(mapView!)
        
        mapView?.myLocationEnabled = true
        mapView?.settings.myLocationButton = true
        mapView?.settings.compassButton = true
    }
    
    let loc = CLLocationManager()
    
    func getLocation ()
    {
        loc.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled()
        {
            loc.delegate = self
            loc.desiredAccuracy = kCLLocationAccuracyBest
            loc.startUpdatingLocation()
            print("Start updating")
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation)
    {
        print("Got location")
        geo = PFGeoPoint(latitude: newLocation.coordinate.latitude, longitude: newLocation.coordinate.longitude)
        loadMap(geo!.latitude, lng: geo!.longitude)
        print(newLocation)
        manager.stopUpdatingLocation()
    }
    
    func mapView(mapView: GMSMapView!, didTapAtCoordinate coordinate: CLLocationCoordinate2D)
    {
        mapView.camera = GMSCameraPosition.cameraWithLatitude(coordinate.latitude, longitude: coordinate.longitude, zoom: 14)
        locMarker.position = coordinate
        updateLocation(coordinate)
    }
    
    func mapView(mapView: GMSMapView!, didChangeCameraPosition position: GMSCameraPosition!)
    {
        print("New location")
        locMarker.position = position.target
        updateLocation(position.target)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        searchCoordintesForCity(textField.text!)
        return true
    }
    
    func searchCoordintesForCity(city: String)
    {
        var urlString = "https://maps.googleapis.com/maps/api/geocode/json?address=\(city)&key=AIzaSyDkruldmCmmE7x0mWDtVnzCmZMJF8foG0U" as NSString
        urlString = urlString.stringByReplacingOccurrencesOfString(" ", withString: "+")
        let url = NSURL(string: urlString as String)
        
        let jsonData = NSData(contentsOfURL: url!)
        let temp = (try! NSJSONSerialization.JSONObjectWithData(jsonData!, options: [])) as! NSDictionary
        let results = (temp["results"] as! NSArray)[0] as! NSDictionary
        
        pickupField.text = results["formatted_address"] as? String
        
        let location = (results["geometry"] as! NSDictionary)["location"] as! NSDictionary
        print(location)
        
        let latitude = location.objectForKey("lat")?.doubleValue
        let longitude = location.objectForKey("lng")?.doubleValue
        
        let camera = GMSCameraPosition.cameraWithLatitude(latitude!, longitude: longitude!, zoom: 14)
        mapView?.camera = camera
    }
    
    func addressFromArray (s: [String]) -> String
    {
        var add = ""
        for i in 0..<(s.count - 1)
        {
            add = add + s[i] + ", "
        }
        add += s[s.count - 1]
        return add
    }
    
    func updateLocation (loc: CLLocationCoordinate2D)
    {
        geo = PFGeoPoint(latitude: loc.latitude, longitude: loc.longitude)
        PFUser.currentUser()!["geo"] = geo
        PFUser.currentUser()!.saveInBackground()
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: loc.latitude, longitude: loc.longitude))
            {
                (placemarks, err) -> Void in
                if (err != nil) || (placemarks?.count == 0)
                {
                    self.pickupField.text = "Could not get location"
                }
                else
                {
                    self.pickupField.text = self.addressFromArray(placemarks![0].addressDictionary!["FormattedAddressLines"] as! [String])
                }
        }
    }
}