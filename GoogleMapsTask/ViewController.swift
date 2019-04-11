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

class ViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {

    
    // MARK: - Properties
    
    var mapView: GMSMapView?
    var locationManager = CLLocationManager()
    var centerMapCoordinate: CLLocationCoordinate2D!
    var marker: GMSMarker!
    
    let addressLabel: UILabel = {
        let lbl = UILabel()
        lbl.frame = CGRect(x: 16, y: 50, width: UIScreen.main.bounds.width - 32, height: 50)
        lbl.backgroundColor = .white
        lbl.numberOfLines = 0
        lbl.layer.cornerRadius = 7
        lbl.layer.borderWidth = 0.5
        lbl.layer.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        lbl.textAlignment = .center
        lbl.font = UIFont.systemFont(ofSize: 14)
        
        return lbl
    }()

    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initiateMap()
    
        mapView?.delegate = self
        mapView?.addSubview(addressLabel)
    }
    
    
    // MARK: Functions
    
    private func initiateMap() {

        let camera = GMSCameraPosition()
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        self.view = mapView
        mapView?.isMyLocationEnabled = true
        mapView?.settings.myLocationButton = true
        
        //Location Manager code to fetch current location
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
    }
    
    
    private func getAdress(position: CLLocationCoordinate2D){
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(position) { response, error in
            if error != nil {
                print("reverse geodcode fail: \(error!.localizedDescription)")
                
            } else {
                if let places = response?.results() {
                    if let place = places.first {
                        if let lines = place.lines {
                            print("GEOCODE: Formatted Address: \(lines)")
                            guard let text = lines.first else { return }
                            self.setAddress(text: "\(text)")
                        }
                        
                    } else {
                        print("GEOCODE: nil first in places")
                        
                    }
                    
                } else {
                    print("GEOCODE: nil in places")
                    
                }
            }
        }
    }
    
    private func setAddress(text: String) {
       self.addressLabel.text = text
    }
    
    
    // MARK: - Location Manager delegates
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 17.0)
        
        self.mapView?.animate(to: camera)
        
        //Finally stop updating location otherwise it will come again and again in this delegate
        self.locationManager.stopUpdatingLocation()
        
        getAdress(position: location.coordinate)
        print(location.coordinate)
    }
    
    
    // MARK: GMS Map View Delegate
    
    // Implemented to know the center position.
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        let latitude = mapView.camera.target.latitude
        let longitude = mapView.camera.target.longitude
        
        centerMapCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.placeMarkerOnCenter(centerMapCoordinate:centerMapCoordinate)
    }
    

    // Function to place a marker on center point
    func placeMarkerOnCenter(centerMapCoordinate:CLLocationCoordinate2D) {
        if marker == nil {
            marker = GMSMarker()
        }
        marker.position = centerMapCoordinate
        marker.map = self.mapView
    }
    
    
    //called when the map is idle
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        print("idleAt")
        
        returnPostionOfMapView(mapView: mapView)
        
    }
    
    // returns adress for new positoin
    func returnPostionOfMapView(mapView: GMSMapView) {
        let latitute = mapView.camera.target.latitude
        let longitude = mapView.camera.target.longitude
        let position = CLLocationCoordinate2DMake(latitute, longitude)
        print("new position: \(position)")
        getAdress(position: position)
    }
}
