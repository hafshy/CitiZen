//
//  MapViewModel.swift
//  CitiZen
//
//  Created by Hafshy Yazid Albisthami on 21/06/22.
//

import Foundation
import CoreLocation
import MapKit

final class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var currentCoordinate = MKCoordinateRegion(
        center: Constants.Defaults.location,
        span: Constants.Defaults.mapSpan
    )
    
    var locationManager: CLLocationManager?
    
    func checkLocationService() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            locationManager!.delegate = self
        } else {
            print("Location Service Disabled")
        }
    }
    
    private func checkLocationPermission() {
        guard let locationManager = locationManager else { return }
        
        switch locationManager.authorizationStatus {
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("Permission Restricted")
        case .denied:
            print("Permission Denied")
        case .authorizedAlways, .authorizedWhenInUse:
            currentCoordinate = MKCoordinateRegion(
                center: locationManager.location!.coordinate,
                span: MKCoordinateSpan(
                    latitudeDelta: 0.01,
                    longitudeDelta: 0.01
                )
            )
        @unknown default:
            break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationPermission()
    }
    
    
}
