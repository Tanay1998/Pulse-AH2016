//
//  DeliveryDoingViewController.swift
//  ThirdEye Deliver
//
//  Created by Tanay Kothari on 12/06/16.
//  Copyright © 2016 Tanay Kothari. All rights reserved.
//

import UIKit
import Parse
import GoogleMaps

class DeliveryDoingViewController: UIViewController
{
    var delivery: PFObject?
    @IBOutlet weak var map: UIView!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var products: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        address.text = delivery!["dropAddress"] as? String
        products.text = delivery!["productList"] as? String
        print(delivery!["productList"] as? String)
        let geo = delivery!["dropLocation"] as! PFGeoPoint
        loadMap(geo.latitude, lng: geo.longitude)
    }
    
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
        self.map.addSubview(mapView!)
        
        mapView?.myLocationEnabled = true
        mapView?.settings.myLocationButton = true
        mapView?.settings.compassButton = true
    }
    
    @IBAction func done(sender: AnyObject)
    {
        self.performSegueWithIdentifier("done", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "done"
        {
            let dest = segue.destinationViewController as! DeliveryConfirmViewController
            dest.delivery = self.delivery
        }
    }
}
