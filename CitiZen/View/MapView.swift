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
            VStack(spacing: 4) {
                HStack {
                    Text("Surabaya")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.black)
                        .frame(alignment: .topLeading)
                    Spacer()
                }
                // TODO: Add Progress Here @Ken
                HStack {
                    Text("80%")
                        .font(.caption2)
                    RoundedRectangle(cornerRadius: 2.5)
                        .frame(width: UIScreen.main.bounds.width / 3.25 * 80 / 100, height: UIScreen.main.bounds.width / 78)
                            .foregroundColor(.red)
                            .overlay(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 2.5)
                                    .stroke(lineWidth: 1)
                                    .frame(width: UIScreen.main.bounds.width / 3.25, height: UIScreen.main.bounds.width / 78)
                                    .foregroundColor(.gray)
                            }
                    Spacer()
                }
                Spacer()
                
                Image(systemName: "house")
                    .resizable()
                    .scaledToFill()
                    .foregroundColor(.black)
                    .frame(width: UIScreen.main.bounds.width / 5.06, height: UIScreen.main.bounds.width / 5.06)
//                    .background(.white)
            }
            .padding()
            
            // TODO: Add Achievements Button Here
            
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
