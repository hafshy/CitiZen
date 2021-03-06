//
//  NotificationViewModel.swift
//  CitiZen
//
//  Created by Trevincen Tambunan on 23/06/22.
//

import SwiftUI
import MapKit
import UserNotifications
import CoreLocation

class NotificationManager:NSObject, ObservableObject{
    @State private var isNotificationalreadycreated = false
    @Published var showPopUp = false
    @Published var currentLocationId = -1
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
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
        for place in places {
            let content = UNMutableNotificationContent()
            content.title = "You arrive at"
            content.subtitle = place.name
            content.sound = .default
            content.badge = 1
            
            let region = CLCircularRegion(
                center: place.coordinate,
                radius: 5,
                identifier: String(place.id))
            region.notifyOnExit = false
            region.notifyOnEntry = true
            
            let trigger = UNLocationNotificationTrigger(region: region, repeats: true)
            let request = UNNotificationRequest(
                identifier: UUID().uuidString,
                content: content,
                trigger: trigger)
            
            UNUserNotificationCenter.current().add(request)
        }
    }
}
