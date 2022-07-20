//
//  Constants.swift
//  CitiZen
//
//  Created by Hafshy Yazid Albisthami on 21/06/22.
//

import CoreLocation
import MapKit
import SwiftUI

struct Constants {
    
    struct Defaults {
        static let location = CLLocationCoordinate2D(
            latitude: -7.26133168292024,
            longitude: 112.742845109226
        )
        
        static let mapSpan = MKCoordinateSpan(
            latitudeDelta: 0.01,
            longitudeDelta: 0.01
        )
        
        static let totalLandmark = 10
    }
    
}

extension Color {
    static let primaryYellow = Color(red: 255, green: 204, blue: 0)
}
