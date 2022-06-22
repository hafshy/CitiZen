//
//  MapLocation.swift
//  CitiZen
//
//  Created by Trevincen Tambunan on 22/06/22.
//

import CoreLocation
import MapKit

struct MapLocation: Identifiable {
    let id = UUID()
    let name: String
    let status: String
    let latitude: Double
    let longitude: Double
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
