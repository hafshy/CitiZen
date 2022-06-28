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
    
    @State var isAlert = false
    @StateObject private var viewModel = MapViewModel()
    @StateObject private var savedLocationViewModel = SavedLocationsViewModel()
    
    let notificationViewModel = NotificationManager()
    
    init(){
        notificationViewModel.monitoring(places: allLocations)
    }
    
    let allLocations = [
        MapLocation(name: "Location 1",status: "Visited", latitude: -7.28842, longitude: 112.63164),
        MapLocation(name: "Location 2",status: "Not Visited", latitude: -7.276025, longitude: 112.645937),
        MapLocation(name: "Location 3",status: "Not Visited", latitude: -7.376025, longitude: 112.645937)
    ]
    
    
    var body: some View {
        ZStack {
            // MARK: Map Background
            Map(coordinateRegion: $viewModel.currentCoordinate,
                showsUserLocation: true,
                annotationItems: allLocations,
                annotationContent: { location in
                MapAnnotation(coordinate: location.coordinate) {
                    VStack{
                        Image(systemName: "mappin.circle.fill")
                            .font(.title)
                            .foregroundColor(location.status=="Visited" ? .red : .gray)
                        
                        Image(systemName: "arrowtriangle.down.fill")
                            .font(.caption)
                            .foregroundColor(location.status=="Visited" ? .red : .gray)
                            .offset(x: 0, y: -5)
                        Text(location.name)
                    }.onTapGesture {
                        //action here
                        print("Clicked")
                    }
                }
            })
            .ignoresSafeArea()
            .accentColor(.green)    // TODO: Change Color Scheme
            .onAppear {
                viewModel.checkLocationService()
            }
            
            // MARK: City and Progress
            VStack() {
                HStack {
                    Text("Surabaya")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.black)
                        .frame(alignment: .topLeading)
                    Spacer()
                }
                Spacer()
                
                // TODO: Add Progress Here @Ken
                
            }
            .padding()
            
            // TODO: Add Achievements Button Here
            .onAppear{
                notificationViewModel.requestAuthorization(places: allLocations)
                UIApplication.shared.applicationIconBadgeNumber = 0
            }
        }
        
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
