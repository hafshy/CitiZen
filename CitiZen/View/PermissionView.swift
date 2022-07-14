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
        VStack{
            Spacer().frame(height: 50)
            Text("Ok, We need some access!").font(.title2)
            Spacer()
            HStack(alignment: .top){
                Image(systemName: "mappin.circle")
                VStack(alignment:.leading){
                    Text("Location")
                    Text("ASASDjhkjhggvhbjnkmjhgfghjkhg")
                }
                Spacer()
            }
            Divider()
            HStack(alignment: .top){
                Image(systemName: "mappin.circle")
                VStack(alignment:.leading){
                    Text("Location")
                    Text("ASASDjhkjhggvhbjnkmjhgfghjkhg")
                }
                Spacer()
            }
            Spacer()
            Button {
                print(123)
                mapViewModel.loadAllLocation()
                mapViewModel.checkLocationService()
                notificationViewModel.requestAuthorization(places: mapViewModel.allLocations)
                viewModel.userSession = true
                LocalStorage.myUserBool = true
            } label: {
                Text("ASD")
            }

        }.padding()
    }
}

//struct PermissionView_Previews: PreviewProvider {
//    static var previews: some View {
//        PermissionView(mapViewModel: <#MapViewModel#>, notificationViewModel: <#NotificationManager#>)
//    }
//}
