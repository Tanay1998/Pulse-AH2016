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

class OrderViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate, UITextFieldDelegate
{
    var delivery: PFObject? = nil
    var geo: PFGeoPoint? = nil
    @IBOutlet weak var pickupField: UITextField!
   
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
        delivery = PFObject(className: "Delivery")
        delivery!["vehicleType"] = "Bike"
        selectVehicle(bikeButton)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "next"
        {
            delivery!["dropLocation"] = PFGeoPoint(latitude: mapView!.camera.target.latitude, longitude: mapView!.camera.target.longitude)
            delivery!["dropAddress"] = pickupField.text!
            let dest = segue.destinationViewController as! PlaceOrderViewController
            print(delivery)
            dest.delivery = self.delivery
            print(dest.delivery)
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
        updateCars("Bike")
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
    
    @IBOutlet weak var footButton: UIButton!
    @IBOutlet weak var rickshawButton: UIButton!
    @IBOutlet weak var bikeButton: UIButton!
    @IBOutlet weak var autoButton: UIButton!
    @IBOutlet weak var carButton: UIButton!

    func clear ()
    {
        footButton.selected = false
        footButton.alpha = 0.6
        rickshawButton.selected = false
        rickshawButton.alpha = 0.6
        bikeButton.selected = false
        bikeButton.alpha = 0.6
        autoButton.selected = false
        autoButton.alpha = 0.6
        carButton.selected = false
        carButton.alpha = 0.6
    }
    
    var markerList: [GMSMarker] = []
    
    func updateCars(type: String)
    {
        if geo == nil
        {
            return
        }
        print(type)
        let q = PFUser.query()?.whereKey("vehicleType", equalTo: type).whereKey("geo", nearGeoPoint: geo!, withinKilometers: 10)
        
        q?.findObjectsInBackgroundWithBlock(
        {
            (objects, err) -> Void in
            if err != nil || objects == nil
            {
                return
            }
            print(objects)
            for marker in self.markerList
            {
                marker.map = nil
            }
            self.markerList = []
            for p in objects!
            {
                if let g = p["geo"] as? PFGeoPoint
                {
                    let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: g.latitude, longitude: g.longitude))
                    marker.map = self.mapView
                    marker.icon = UIImage(named: "Deliverer")
                }
            }
        })
    }
    
    @IBAction func selectVehicle(sender: AnyObject)
    {
        let button = sender as! UIButton
        if button.selected { return }
        
        clear()
        button.selected = true
        button.alpha = 1.0
        
        if button.tag == 1
        {
            delivery!["vehicleType"] = "Foot"
        }
        else if button.tag == 2
        {
            delivery!["vehicleType"] = "Rickshaw"
        }
        else if button.tag == 3
        {
            delivery!["vehicleType"] = "Bike"
        }
        else if button.tag == 4
        {
            delivery!["vehicleType"] = "Auto"
        }
        else
        {
            delivery!["vehicleType"] = "Car"
        }
        
        updateCars(delivery!["vehicleType"] as! String)
    }
}