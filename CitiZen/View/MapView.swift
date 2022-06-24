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
    @StateObject private var viewModel = MapViewModel()
    
    
    var body: some View {
        ZStack {
            // MARK: Map Background
            Map(coordinateRegion: $viewModel.currentCoordinate, showsUserLocation: true)
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
            Shake()
        }
        
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
