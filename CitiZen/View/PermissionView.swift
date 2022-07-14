//
//  PermissionView.swift
//  CitiZen
//
//  Created by Trevincen Tambunan on 14/07/22.
//

import SwiftUI

struct PermissionView: View {
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
            } label: {
                Text("ASD")
            }

        }.padding()
    }
}

struct PermissionView_Previews: PreviewProvider {
    static var previews: some View {
        PermissionView()
    }
}
