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
                                    Image(savedLocationViewModel.savedLocations.contains(where: { saved in
                                        saved.locationID == location.id
                                    }) ? "bg_pin_yellow" : "bg_pin_gray")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40.0)
                                    
                                    Image(location.category)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 25.0)
                                        .offset(x: 0, y: -6)
                                }
                                .onTapGesture {
                                    //action here
                                    print(location.id)
                                    withAnimation(.spring()) {
                                        currentDetailId = location.id
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
                                    .fontWeight(.bold)
                                
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 2.5)
                                        .frame(width: UIScreen.main.bounds.width / 3.48, height: UIScreen.main.bounds.width / 65)
                                        .foregroundColor(.black)
                                    
                                    RoundedRectangle(cornerRadius: 2.5)
                                        .frame(width: UIScreen.main.bounds.width / 3.48 * CGFloat(savedLocationViewModel.savedLocations.count) / CGFloat(Constants.Defaults.totalLandmark), height: UIScreen.main.bounds.width / 65)
                                        .foregroundColor(.primaryYellow)
                                    
                                }
                                Spacer()
                            }
                        }
                        NavigationLink(destination: AchievementView().environment(
                            \.managedObjectContext,
                             chatDataController.container.viewContext
                        )) {
                            Image("trophy")
                                .resizable()
                                .scaledToFit()
                                .padding(6)
                                .frame(width: UIScreen.main.bounds.width / 6.96, height: UIScreen.main.bounds.width / 6.39)
                                .background(.black)
                                .cornerRadius(8)
                                .overlay(RoundedRectangle(cornerRadius: 8)
                                    .stroke(lineWidth: 4)
                                    .foregroundColor(.black))
                        }
                    }
                    .padding()
                    .background(Color(red: 245 / 255, green: 245 / 255, blue: 245 / 255).opacity(0.9))
                    .cornerRadius(20)
                    
                    Spacer()
                    HStack{
                        Spacer()
                        Button {
                            withAnimation(.spring()) {
                                viewModel.currentCoordinate = MKCoordinateRegion(
                                    center : viewModel.locationManager?.location?.coordinate ?? Constants.Defaults.location,
                                    span: MKCoordinateSpan(
                                        latitudeDelta: 0.01,
                                        longitudeDelta: 0.01
                                    )
                                )
                            }
                        } label: {
                            ZStack{
                                Circle().frame(width: 40, height: 40).foregroundColor(.primaryYellow)
                                Image(systemName: "location.circle.fill").resizable().frame(width: 40, height: 40).foregroundColor(.black).padding()
                            }
                        }
                        
                    }
                }
                .padding()
                .padding(.horizontal)
                
                // MARK: Chat
                VStack {
                    Spacer()
                    NavigationLink(
                        destination:
                            ChatView(landmarkID: notificationViewModel.currentLocationId)
                            .environment(
                                \.managedObjectContext,
                                 chatDataController.container.viewContext
                            )
                    ) {
                        if notificationViewModel.currentLocationId > 0 {
                            MemoriesButtonView(landmarkID: $notificationViewModel.currentLocationId)
                                .environment(
                                    \.managedObjectContext,
                                     chatDataController.container.viewContext
                                )
                        }
                    }
                }
                
                CustomBottomSheet(content: {
                    DetailView(offset: $offset, lastOffset: $lastOffset, item: detailViewModel.items.data[currentDetailId-1])
                }, offset: $offset, lastOffset: $lastOffset)
                
                if offset < 0 {
                    ZStack {
                        VStack {
                            Spacer()
                            Rectangle()
                                .frame(width: UIScreen.main.bounds.width, height: 100)
                                .foregroundColor(.white)
                                .border(.gray, width: 1)
                        }
                        .ignoresSafeArea()
                        
                        VStack {
                            Spacer()
                            
                            Button {
                                detailViewModel.openMap(latitude: detailViewModel.items.data[currentDetailId-1].latitude, longitude: detailViewModel.items.data[currentDetailId-1].longitude)
                            } label: {
                                ZStack {
                                    Rectangle()
                                        .foregroundColor(.primaryYellow)
                                    Text("Navigate")
                                        .font(.headline)
                                        .foregroundColor(.black)
                                }
                                .frame(width: UI_WIDTH/1.19, height: 50)
                                .cornerRadius(14)
                            }
                        }
                    }
                }
                if notificationViewModel.currentLocationId != -1 {
                    Shake(showArrivedPopUp: $notificationViewModel.showPopUp, currenLocationId: $notificationViewModel.currentLocationId, saveViewModel: savedLocationViewModel, Location: $viewModel.allLocations[notificationViewModel.currentLocationId-1])
                }
                
                
            }
            .navigationBarHidden(true)
            .alert(isPresented: $viewModel.isFirstTime){
                Alert(title: Text("Choose your own landmark !"), message: Text("Zoom out, zoom in, and slide the phone screen to find  more landmarks"), dismissButton: .default(Text("OK")))
            }
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
