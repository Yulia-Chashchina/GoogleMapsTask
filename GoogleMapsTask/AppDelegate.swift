//
//  AppDelegate.swift
//  GoogleMapsTask
//
//  Created by Юлия Чащина on 09/04/2019.
//  Copyright © 2019 Yulia Chashchina. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        GMSServices.provideAPIKey("AIzaSyD56Spr8Ta3mOzOXXMh3bKUAXSQ3u-a-PE")
        GMSPlacesClient.provideAPIKey("AIzaSyD56Spr8Ta3mOzOXXMh3bKUAXSQ3u-a-PE")
        
        let frame = UIScreen.main.bounds
        window = UIWindow(frame: frame)
        window?.makeKeyAndVisible()
        
        window?.rootViewController = ViewController()
    
        return true
    }

}

