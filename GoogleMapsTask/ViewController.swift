//
//  ViewController.swift
//  GoogleMapsTask
//
//  Created by Юлия Чащина on 09/04/2019.
//  Copyright © 2019 Yulia Chashchina. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces


///отображает главный экран с гугл картой

class ViewController: UIViewController, CLLocationManagerDelegate {

    
    // MARK: - Properties
    
    var mapView: GMSMapView?
    var locationManager = CLLocationManager()

    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initiateMap()
        
    }
    
    
    // MARK: Functions
    
    func initiateMap() {

        let camera = GMSCameraPosition()
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        self.view = mapView
        mapView?.isMyLocationEnabled = true
        mapView?.settings.myLocationButton = true
        
        //Location Manager code to fetch current location
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
    }
    
    
    // MARK: - Location Manager delegates
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 17.0)
        
        self.mapView?.animate(to: camera)
        
        //Finally stop updating location otherwise it will come again and again in this delegate
        self.locationManager.stopUpdatingLocation()
        
    }


}

