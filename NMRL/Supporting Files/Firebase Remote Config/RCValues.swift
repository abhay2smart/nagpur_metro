//
//  RCValues.swift
//  NMRL
//
//  Created by Akhil Johny on 16/05/19.
//  Copyright © 2019 SC Soft Technologies. All rights reserved.
//

import Foundation

import Firebase

class RCValues {
    
    static let sharedInstance = RCValues()
    
    private init() {
        loadDefaultValues()
        
        fetchCloudValues()

    }
    
    func loadDefaultValues() {
        let appDefaults: [String: Any?] = [
            "banner_data" : "#FBB03B"
        ]
        RemoteConfig.remoteConfig().setDefaults(appDefaults as? [String: NSObject])
    }
    
    func fetchCloudValues() {
        // 1
        // WARNING: Don't actually do this in production!
        let fetchDuration: TimeInterval = 0
        
        activateDebugMode()

        RemoteConfig.remoteConfig().fetch(withExpirationDuration: fetchDuration) { status, error in
            
            if let error = error {
                print("Uh-oh. Got an error fetching remote values \(error)")
                return
            }
            
            // 2
            RemoteConfig.remoteConfig().activateFetched()
            print("Retrieved values from the cloud!")
            
            let appPrimaryColorString = RemoteConfig.remoteConfig()
                .configValue(forKey: "banner_data")
                .stringValue ?? "undefined"
           // print("Our app's primary color is \(appPrimaryColorString)")

            let DictValues = self.convertToArray(text: appPrimaryColorString)
            
            print("DictValues : \(DictValues)")
            
            PublicBannerImages = DictValues

            NotificationCenter.default.post(name: Notification.Name("GotBannerImages"), object: nil)
        }
    }
    
    func convertToArray(text: String) -> NSArray {
        if let data = text.data(using: .utf8) {
            do {
                return try (JSONSerialization.jsonObject(with: data, options: []) as? NSArray)!
            } catch {
                print(error.localizedDescription)
            }
        }
        
        let dict = NSArray()
        
        return dict
    }
    
    func activateDebugMode() {
//        if let debugSettings = RemoteConfigSettings(developerModeEnabled: true) {
//            RemoteConfig.remoteConfig().configSettings = debugSettings
//        }
        
         let debugSettings = RemoteConfigSettings(developerModeEnabled: true)
            RemoteConfig.remoteConfig().configSettings = debugSettings
        
    }


}
