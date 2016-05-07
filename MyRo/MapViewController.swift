//
//  MapViewController.swift
//  MyRo
//
//  Created by Aadesh Patel on 4/29/16.
//  Copyright © 2016 MyRo. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController {
    /*private var locationManager: CLLocationManager = {
        let lm = CLLocationManager()
        lm.distanceFilter = kCLDistanceFilterNone
        lm.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        return lm
    }()*/
    
    private var mapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()*/
        
        let camera = GMSCameraPosition.cameraWithLatitude(0.0, longitude: 0.0, zoom: 12)
        self.mapView = {
            let mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
            mapView.settings.scrollGestures = true
            mapView.settings.zoomGestures = true
            mapView.settings.compassButton = true
            mapView.addObserver(self, forKeyPath: "myLocation", options: [.New, .Old], context: nil)
            mapView.myLocationEnabled = true
            
            return mapView
        }()
        
        self.view = self.mapView
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        guard keyPath == "myLocation" else { return }
        
        let lat = self.mapView.myLocation?.coordinate.latitude
        let lon = self.mapView.myLocation?.coordinate.longitude
        let camera = GMSCameraPosition.cameraWithLatitude(lat!, longitude: lon!, zoom: 12)
        
        self.mapView.animateWithCameraUpdate(GMSCameraUpdate.setCamera(camera))
        
        PlacesService.getLandmarks(lat!, lon: lon!, radius: 10000).then { landmarks in
            print("Landmarks: \(landmarks)")
            for landmark in landmarks {
                print("Name: \(landmark.name)")
                print("Lat: \(landmark.lat)")
                print("Lat: \(landmark.lon)")
                let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: landmark.lat, longitude: landmark.lon))
                marker.title = landmark.name
                marker.map = self.mapView
            }
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        //self.mapView.removeObserver(self, forKeyPath: "myLocation")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}