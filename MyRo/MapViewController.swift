//
//  MapViewController.swift
//  MyRo
//
//  Created by Shreyas Hirday on 4/29/16.
//  Copyright © 2016 MyRo. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {
    
    
    @IBOutlet var mapView: GMSMapView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        
        
        
    }
    
    
    
    

}

// MARK: - CLLocationManagerDelegate
extension MapViewController: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
            mapView.myLocationEnabled = true
            mapView.settings.myLocationButton = true
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            locationManager.stopUpdatingLocation()
            
        }
    }
}
