//
//  NotificationViewModel.swift
//  CitiZen
//
//  Created by Trevincen Tambunan on 23/06/22.
//

import SwiftUI
import MapKit
import UserNotifications

class NotificationManager{
    @State private var isNotificationalreadycreated = false
    static let instance = NotificationManager()
    let locationManager = CLLocationManager()
    
    func requestAuthorization(places: [MapLocation]){
        let option:UNAuthorizationOptions = [.badge,.sound,.alert]
        
        UNUserNotificationCenter.current().requestAuthorization(options: option) { [self] success, error in
            if let error = error{
                print(error)
            }else{
                print("success")
                print(UserDefaults.standard.bool(forKey: "isNotificationalreadycreated"))
                if(UserDefaults.standard.bool(forKey: "isNotificationalreadycreated") == false){
                    UserDefaults.standard.set(true, forKey: "isNotificationalreadycreated")
                    self.scheduleNotification(places: places)
                }
            }
        }
    }
    
    func scheduleNotification(places: [MapLocation]){
        var counter:Int = 1
        
        for place in places {
            let content = UNMutableNotificationContent()
            content.title = "You arrive at"
            content.subtitle = place.name
            content.sound = .default
            content.badge = 1
            
            let region = CLCircularRegion(
                center: place.coordinate,
                radius: 5,
                identifier: UUID().uuidString)
            region.notifyOnExit = false
            region.notifyOnEntry = true
//            locationManager.startMonitoring(for: region)
            
            let trigger = UNLocationNotificationTrigger(region: region, repeats: true)
            
            let request = UNNotificationRequest(
                identifier: UUID().uuidString,
                content: content,
                trigger: trigger)
            
            UNUserNotificationCenter.current().add(request)
            
            counter+=1
        }
    }
    
//    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
//        print("masuk landmark")
//    }
}
