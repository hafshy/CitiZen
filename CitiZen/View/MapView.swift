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
    @StateObject private var savedLocationViewModel = SavedLocationsViewModel()
    @StateObject private var detailViewModel = DetailViewModel()
    @StateObject private var notificationViewModel = NotificationManager()
    @StateObject private var chatDataController = ChatDataController()
    
    @State var currentDetailId = 1
    @State var offset: CGFloat = 0
    @State var lastOffset: CGFloat = 0
    @State var isOpen = false
    
    var body: some View {
        NavigationView{
            ZStack {
                // MARK: Map Background
                Map(coordinateRegion: $viewModel.currentCoordinate,
                    showsUserLocation: true,
                    annotationItems: viewModel.allLocations,
                    annotationContent: { location in
                    MapAnnotation(coordinate: location.coordinate) {
                        ZStack{
                            VStack{
                                ZStack {
                                    Image("Background Pin")
                                        .resizable()
                                        .renderingMode(.template)
                                        .foregroundColor(savedLocationViewModel.savedLocations.contains(where: { saved in
                                            saved.locationID == location.id
                                        }) ? .yellow : .gray)
                                        .scaledToFit()
                                        .frame(width: 40.0)
                                        
                                    Image(location.category)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 30.0)
                                        .offset(x: 0, y: -4)
                                }
                                .onTapGesture {
                                    //action here
                                    currentDetailId = location.id
                                    withAnimation(.spring()) {
                                        offset = -(UIScreen.main.bounds.height - 100) / 2
                                        lastOffset = -(UIScreen.main.bounds.height - 100) / 2
                                        viewModel.currentCoordinate = MKCoordinateRegion(
                                            center: CLLocationCoordinate2D(
                                                latitude: location.latitude + offset * 0.00001,
                                                longitude: location.longitude
                                        ),
                                            span: Constants.Defaults.mapSpan
                                        )
                                    }
                                }
                                Text(location.name)
                                    .font(.caption2)
                                    .bold()
                            }
                        }
                    }
                })
                .ignoresSafeArea()
                .accentColor(.green)    // TODO: Change Color Scheme
                .onAppear {
                    viewModel.checkLocationService()
                    viewModel.loadAllLocation()
                    UIApplication.shared.applicationIconBadgeNumber = 0
                }
                
                // MARK: City and Progress
                VStack {
                    HStack(alignment: .top) {
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
                                Text("\((savedLocationViewModel.savedLocations.count) * 100 / (Constants.Defaults.totalLandmark))%")
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
                        }
                        NavigationLink(destination: AchievementView()) {
                            Image("trophy")
                                .renderingMode(.template)
                                .resizable()
                                .scaledToFill()
                                .foregroundColor(.yellow)
                                .frame(width: UIScreen.main.bounds.width / 7.3, height: UIScreen.main.bounds.width / 7.3)
                                .frame(width: UIScreen.main.bounds.width / 5.06, height: UIScreen.main.bounds.width / 5.06)
                                .background(.black)
                                .cornerRadius(8)
                                .overlay(RoundedRectangle(cornerRadius: 8)
                                    .stroke(lineWidth: 4)
                                    .foregroundColor(.black))
                        }
                        
                    }
                    Spacer()
                    NavigationLink(
                        destination:
                            ChatView(landmarkID: 1, challenge: Challenge.challenge.first(where: { challenge in
                                challenge.id == 1
                            }) ?? nil)
                            .environment(
                                \.managedObjectContext,
                                 chatDataController.container.viewContext
                            )
                    ) {
                        HStack {
                            Spacer()
                            Text("Chat")
                                .padding(.vertical)
                            Spacer()
                        }
                        .background(.yellow)
                    }
                }
                .padding()
                .padding(.horizontal)
                
                CustomBottomSheet(content: {
                    DetailView(offset: $offset, lastOffset: $lastOffset, item: detailViewModel.items.data[currentDetailId-1])
                }, offset: $offset, lastOffset: $lastOffset)
                
                if offset < 0 {
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
                            }
                        }
                    }
                }
                Shake(showArrivedPopUp: $notificationViewModel.showPopUp, currenLocationId: $notificationViewModel.currentLocationId, saveViewModel: savedLocationViewModel)
            }
            .navigationBarHidden(true)
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
