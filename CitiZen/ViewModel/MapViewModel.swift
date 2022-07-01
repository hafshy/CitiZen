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
    
    @Published var allLocations:[MapLocation] = []
    
    @Published var currentCoordinate = MKCoordinateRegion(
        center: Constants.Defaults.location,
        span: Constants.Defaults.mapSpan
    )
    
    var locationManager: CLLocationManager?
    
    func checkLocationService() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager!.delegate = self
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        } else {
            print("Location Service Disabled")
        }
    }
    
    // NOTE: If location's not detected, try to
    // -    check Simulators location, make sure it's not None
    // -    restart Simulator and re-run
    //
    // NOTE: Request 'always' will be prompted to users when they are in Geofences Radius
    private func checkLocationPermission() {
        guard let locationManager = locationManager else { return }
        
        switch locationManager.authorizationStatus {
            
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
        case .restricted:
            print("Permission Restricted")
        case .denied:
            print("Permission Denied")
        case .authorizedAlways, .authorizedWhenInUse:
            currentCoordinate = MKCoordinateRegion(
                center: locationManager.location?.coordinate ?? Constants.Defaults.location,
                span: MKCoordinateSpan(
                    latitudeDelta: 0.01,
                    longitudeDelta: 0.01
                )
            )
            locationManager.allowsBackgroundLocationUpdates = true
        @unknown default:
            break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationPermission()
    }
    
    func loadAllLocation(){
        let savedLocation = SavedLocationsViewModel()
        let detailedViewModel = DetailViewModel()
        allLocations = detailedViewModel.items.data.map({ (datum) -> MapLocation in
            MapLocation.init(id: datum.id, name: datum.name, status: savedLocation.savedLocations.contains(where:{
                Int($0.locationID) == datum.id
            }) ? "Visited" : "Not Visited", latitude: datum.latitude, longitude: datum.longitude,icon: datum.icon, category: datum.category)
        })
    }
}
