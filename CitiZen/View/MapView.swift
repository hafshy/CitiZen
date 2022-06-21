//
//  ContentView.swift
//  CitiZen
//
//  Created by Hafshy Yazid Albisthami on 21/06/22.
//

import SwiftUI
import MapKit
import CoreLocation

struct MapView: View {
    @State private var currentCoordinate = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: -7.285374204077755,
            longitude: 112.63157190701298
        ),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    
    var body: some View {
        Map(coordinateRegion: $currentCoordinate)
            .ignoresSafeArea()
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
