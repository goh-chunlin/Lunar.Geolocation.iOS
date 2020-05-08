//
//  ApiKey.swift
//  geolocation
//
//  Created by Goh Chun Lin on 8/5/20.
//  Copyright © 2020 GCL Project. All rights reserved.
//

import Foundation

class ApiKey {
    class func GetApiKey(key: String) -> String! {
        
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
            
            return plistData[key] as? String

        } catch {
            print("Error reading plist: \(error), format: \(propertyListFormat)")
        }
        
        return nil
    }
}
