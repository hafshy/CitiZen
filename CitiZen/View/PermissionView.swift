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
            HStack{
                
                Text("OK!").font(.title).foregroundColor(.yellow)
                Text("We need some access!").font(.title)
            }
            Spacer()
            HStack(alignment: .top){
                Image("location").resizable().scaledToFit().frame(width:30)
                VStack(alignment:.leading){
                    Text("Location").font(.title3).bold()
                    Text("To display fun facts about the user's location").font(.caption)
                }
                Spacer()
            }
            Divider()
            HStack(alignment: .top){
                Image("notification").resizable().scaledToFit().frame(width:30)
                VStack(alignment:.leading){
                    Text("Notification").font(.title3).bold()
                    Text("So we can let you know when you arrive at the landmark").font(.caption)
                }
                Spacer()
            }
            Spacer()
            Spacer()
            Button {
                print(123)
                mapViewModel.loadAllLocation()
                mapViewModel.checkLocationService()
                notificationViewModel.requestAuthorization(places: mapViewModel.allLocations)
                viewModel.userSession = true
                LocalStorage.myUserBool = true
            } label: {
                Text("Allow Access")
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .font(.title3)
                    .padding(16)
                    .frame(maxWidth: .infinity)
                    .frame(height: UIScreen.main.bounds.width/6.09)
                    .background(Color(.systemYellow))
                    .cornerRadius(16)
                    .padding(.horizontal)
            }
        }.padding()
    }
}

//struct PermissionView_Previews: PreviewProvider {
//    static var previews: some View {
//        PermissionView(mapViewModel: <#MapViewModel#>, notificationViewModel: <#NotificationManager#>)
//    }
//}
