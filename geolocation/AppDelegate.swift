//
//  AppDelegate.swift
//  geolocation
//
//  Created by Goh Chun Lin on 4/5/20.
//  Copyright © 2020 GCL Project. All rights reserved.
//

import UIKit
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Read from plist
        //
        // References:
        // 1. https://stackoverflow.com/a/39453212/1177328
        // 2. https://makeapppie.com/2016/02/11/how-to-use-property-lists-plist-in-swift
        var propertyListFormat =  PropertyListSerialization.PropertyListFormat.xml //Format of the Property List.
        var plistData: [String: AnyObject] = [:] //Our data
        let plistPath: String? = Bundle.main.path(forResource: "apikey", ofType: "plist")!
        let plistXML = FileManager.default.contents(atPath: plistPath!)!
        do {
            // Convert the data to a dictionary and handle errors.
            plistData = try PropertyListSerialization.propertyList(from: plistXML, options: .mutableContainersAndLeaves, format: &propertyListFormat) as! [String:AnyObject]
            
            GMSServices.provideAPIKey(plistData["GoogleMapsiOSAPIKey"] as! String)

        } catch {
            print("Error reading plist: \(error), format: \(propertyListFormat)")
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

