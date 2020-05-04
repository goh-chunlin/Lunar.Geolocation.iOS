//
//  ViewController.swift
//  geolocation
//
//  Created by Goh Chun Lin on 4/5/20.
//  Copyright © 2020 GCL Project. All rights reserved.
//

import UIKit
import GoogleMaps

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let singaporeLatitude =  1.368878
        let singaporeLongitude = 103.797873
        let mapZoomLevel: Float = 14.0
        
        let camera = GMSCameraPosition.camera(withLatitude: singaporeLatitude, longitude: singaporeLongitude, zoom: mapZoomLevel)
        let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        self.view.addSubview(mapView)

        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: singaporeLatitude, longitude: singaporeLongitude)
        marker.title = "Hello"
        marker.snippet = "Singapore"
        marker.map = mapView
    }


}

