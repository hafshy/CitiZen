//
//  NotificationViewModel.swift
//  CitiZen
//
//  Created by Trevincen Tambunan on 23/06/22.
//

import SwiftUI
import UserNotifications

class NotificationManager{
    static let instance = NotificationManager()
    
    func requestAuthorization(){
        let option:UNAuthorizationOptions = [.badge,.sound,.alert]
        
        UNUserNotificationCenter.current().requestAuthorization(options: option) { success, error in
            if let error = error{
                print(error)
            }else{
                print("success")
            }
        }
    }
    
    func scheduleNotification(places: [MapLocation]){
        for place in places {
            let content = UNMutableNotificationContent()
            content.title = "You almost arrive at"
            content.subtitle = place.name
            content.sound = .default
            content.badge = 1
            
            let contentArrive = UNMutableNotificationContent()
            content.title = "You arrive at"
            content.subtitle = place.name
            content.sound = .default
            content.badge = 1
            
            place.region.notifyOnEntry = true
            place.regionArrive.notifyOnEntry = true
            let trigger = UNLocationNotificationTrigger(region: place.region, repeats: true)
            let triggerArrive = UNLocationNotificationTrigger(region: place.regionArrive, repeats: true)
            let request = UNNotificationRequest(
                identifier: UUID().uuidString,
                content: content,
                trigger: trigger)
            let requestArrive = UNNotificationRequest(
                identifier: UUID().uuidString,
                content: contentArrive,
                trigger: triggerArrive)
            
            UNUserNotificationCenter.current().add(request)
            UNUserNotificationCenter.current().add(requestArrive)
        }
    }
}
