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

let UI_WIDTH = UIScreen.main.bounds.width
let UI_HEIGHT = UIScreen.main.bounds.height

extension Color {
    static let primaryYellow = Color("primary_yellow")
    static let primaryDarkPurple = Color("dark_purple")
}
