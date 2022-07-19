//
//  MapViewModel.swift
//  CitiZen
//
//  Created by Hafshy Yazid Albisthami on 21/06/22.
//

import Foundation
import CoreLocation
import MapKit
import SwiftUI

final class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    override init() {
        super.init()
        locationManagerMonitoring.delegate = self
    }
    
    @Published var allLocations:[MapLocation] = []
    
    @Published var currentCoordinate = MKCoordinateRegion(
        center: Constants.Defaults.location,
        span: Constants.Defaults.mapSpan
    )
    
    var locationManager: CLLocationManager?
    
    let locationManagerMonitoring = CLLocationManager()
    
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
    
    func checkFirstTime(){
        if(UserDefaults.standard.bool(forKey: "isFirstTime") == false){
            UserDefaults.standard.set(true, forKey: "isFirstTime")
            currentCoordinate = MKCoordinateRegion(
                center: Constants.Defaults.location,
                span: MKCoordinateSpan(
                    latitudeDelta: 0.01,
                    longitudeDelta: 0.01
                )
            )
        }
    }
    
    func loadAllLocation(){
        let savedLocation = SavedLocationsViewModel()
        let detailedViewModel = DetailViewModel()
        allLocations = detailedViewModel.items.data.map({ (datum) -> MapLocation in
            MapLocation.init(id: datum.id, name: datum.name, status: savedLocation.savedLocations.contains(where:{
                Int($0.locationID) == datum.id
            }) ? "Visited" : "Not Visited", latitude: datum.latitude, longitude: datum.longitude,icon: datum.icon, category: datum.category)
        })
        self.monitoring(places: allLocations)
    }
    
    func monitoring(places:[MapLocation]){
        for place in places {
            let region = CLCircularRegion(
                center: place.coordinate,
                radius: 5,
                identifier: String(place.id))
            region.notifyOnExit = true
            region.notifyOnEntry = true
            startMonitoring(geotification: region)
        }
    }

    func startMonitoring(geotification: CLRegion) {
        // 1
        if !CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            return
        } else{
//            print(5555)
        }
        // 2
        let fenceRegion = geotification
        // 3
        locationManagerMonitoring.startMonitoring(for: fenceRegion)
    }

    func stopMonitoring(geotification: [MapLocation]) {
        for location in geotification {
            guard
                let circularRegion = location.region as? CLCircularRegion
            else { continue }
            locationManagerMonitoring.stopMonitoring(for: circularRegion)
        }

    }
}

extension NotificationManager: CLLocationManagerDelegate {
    func locationManager(
        _ manager: CLLocationManager,
        didEnterRegion region: CLRegion
    ) {
        print("Enter")
        if region is CLCircularRegion {
            handleEvent(for: region)
        }
    }

    func locationManager(
        _ manager: CLLocationManager,
        didExitRegion region: CLRegion
    ) {
        print("Exit")
        withAnimation {
            currentLocationId = -1
            showPopUp = false
        }
    }

    func handleEvent(for region: CLRegion) {
        // Show an alert if application is active
        print("aktif")
        print(region.identifier)
        withAnimation {
            currentLocationId = Int(region.identifier) ?? -1
            showPopUp = true
        }
//        if UIApplication.shared.applicationState == .active {
//            print("aktif")
//            print(region.identifier)
//            currentLocationId = Int(region.identifier) ?? -1
//            showPopUp = true
//        }
    }
}
