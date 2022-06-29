//
//  MapLocation.swift
//  CitiZen
//
//  Created by Trevincen Tambunan on 22/06/22.
//

import CoreLocation
import MapKit

struct MapLocation: Identifiable {
    var id = UUID()
    var name: String
    var status: String
    var latitude: Double
    var longitude: Double
    var coordinate: CLLocationCoordinate2D
    var region:CLCircularRegion
    var icon:String
    
    init(name:String, status:String, latitude:Double, longitude:Double, icon:String) {
        self.name = name
        self.status = status
        self.latitude = latitude
        self.longitude = longitude
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.region = CLCircularRegion(
            center: self.coordinate,
            radius: 10,
            identifier: UUID().uuidString)
        self.icon = icon
    }
}
