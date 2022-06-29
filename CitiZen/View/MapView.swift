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
    @StateObject private var detailViewModel = DetailViewModel()
    
    @State var currentDetailId = 1
    @State var offset: CGFloat = 0
    @State var lastOffset: CGFloat = 0
    
    let notificationViewModel = NotificationManager()
    
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
            .onTapGesture(perform: {
                withAnimation(.spring()) {
                    if offset < 0 {
                        offset = 0
                    }
                }
            })
            
            
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
                    Text("\(savedLocationViewModel.savedLocations.count / Constants.Defaults.totalLandmark)%")
                        .font(.caption2)
                    RoundedRectangle(cornerRadius: 2.5)
                        .frame(width: UIScreen.main.bounds.width / 3.25 * CGFloat(savedLocationViewModel.savedLocations.count) / CGFloat(Constants.Defaults.totalLandmark), height: UIScreen.main.bounds.width / 78)
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
                
                // TODO: Add Achievements Button Here
                Button {
                    // TODO: Add Navigation Here
                                        withAnimation(.spring()) {
                                            offset = -(UIScreen.main.bounds.height - 100) / 2
                                        }
                } label: {
                    Image("trophy")
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFill()
                        .foregroundColor(.black)
                        .frame(width: UIScreen.main.bounds.width / 10, height: UIScreen.main.bounds.width / 10)
                        .frame(width: UIScreen.main.bounds.width / 5.06, height: UIScreen.main.bounds.width / 5.06)
                        .background(Color(.systemGray3))
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8)
                            .stroke(lineWidth: 4)
                            .foregroundColor(.gray))
                }
            }
            .padding()
            
            if offset < 0 {
                CustomBottomSheet(content: {
                    DetailView(offset: $offset, item: detailViewModel.items.data[currentDetailId-1])
                }, offset: $offset, lastOffset: $lastOffset)
                
                ZStack {
                    VStack {
                        Spacer()
                        Rectangle()
                            .frame(width: UIScreen.main.bounds.width, height: 100)
                            .foregroundColor(Color(.systemGray3))
                            .border(.black, width: 1)
                    }
                    .ignoresSafeArea()
                    
                    VStack {
                        Spacer()
                        
                        Button {
                            detailViewModel.openMap(latitude: detailViewModel.items.data[currentDetailId-1].latitude, longitude: detailViewModel.items.data[currentDetailId-1].longitude)
                        } label: {
                            HStack {
                                Image(systemName: "paperplane.fill")
                                    .font(.body)
                                    .foregroundColor(.white)
                                Text("Navigate")
                                    .font(.headline)
                                    .foregroundColor(.white)
                            }
                            .frame(width: 360, height: 48)
                            .background(.blue)
                            .cornerRadius(8)
                            .border(.gray, width: 1)
                        }
                    }
                }
                // TODO: Add Achievements Button Here
                .onAppear{
                    notificationViewModel.requestAuthorization(places: allLocations)
                    UIApplication.shared.applicationIconBadgeNumber = 0
                }
            }
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
