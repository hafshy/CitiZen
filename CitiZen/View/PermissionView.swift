//
//  PermissionView.swift
//  CitiZen
//
//  Created by Trevincen Tambunan on 14/07/22.
//

import SwiftUI

struct PermissionView: View {
    
    @StateObject var mapViewModel: MapViewModel
    @StateObject var notificationViewModel: NotificationManager
    @EnvironmentObject var viewModel: AuthtenticationVM
    
    var body: some View {
        ZStack{
            VStack(){
                Spacer()
                Rectangle().frame(height:UIScreen.main.bounds.height/1.22).foregroundColor(.yellow)
            }.ignoresSafeArea()
            VStack{
                Text("Allow using my location on the next screen for :").font(.title).bold().padding()
                HStack(){
                    ZStack{
                        Circle().fill(.black).frame(width:55, height:55)
                        Image(systemName: "mappin.and.ellipse")
                            .resizable()
                            .scaledToFit()
                            .frame(width:25)
                            .foregroundColor(.yellow)
                    }
                    Spacer().frame(width:20)
                    VStack(alignment:.leading){
                        Text("Navigate you to the").font(.title2)
                        Text("landmarks").font(.title2)
                    }
                    Spacer()
                }.padding()
                HStack(){
                    ZStack{
                        Circle().fill(.black).frame(width:55, height:55)
                        Image(systemName: "bell.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width:25)
                            .foregroundColor(.yellow)
                    }
                    Spacer().frame(width:20)
                    VStack(alignment:.leading){
                        Text("Alerts when you near").font(.title2)
                        Text("the landmarks").font(.title2)
                    }
                    Spacer()
                }.padding()
                HStack(){
                    ZStack{
                        Circle().fill(.black).frame(width:55, height:55)
                        Image(systemName: "hand.wave.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width:25)
                            .foregroundColor(.yellow)
                    }
                    Spacer().frame(width:20)
                    VStack(alignment:.leading){
                        Text("Better personal").font(.title2)
                        Text("experience").font(.title2)
                    }
                    Spacer()
                }.padding()
                Button {
                    mapViewModel.loadAllLocation()
                    mapViewModel.checkLocationService()
                    notificationViewModel.requestAuthorization(places: mapViewModel.allLocations)
                    viewModel.userSession = true
                    LocalStorage.myUserBool = true
                } label: {
                    Text("Continue")
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                        .font(.title3)
                        .padding(16)
                        .frame(maxWidth: .infinity)
                        .frame(height: UIScreen.main.bounds.width/6.09)
                        .background(.white)
                        .cornerRadius(16)
                        .padding()
                }
                Text("You can change this option later in the Setting app").font(.caption)
                Spacer()
            }.padding().padding(.top, 50)
        }.navigationTitle("LocalHunt")
            .navigationBarBackButtonHidden(true)
    }
}

//struct PermissionView_Previews: PreviewProvider {
//    static var previews: some View {
//        PermissionView(mapViewModel: <#MapViewModel#>, notificationViewModel: <#NotificationManager#>)
//    }
//}
