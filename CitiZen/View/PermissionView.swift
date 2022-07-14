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
            Text("Ok, We need some access!")
            Spacer()
            HStack{
                Image(systemName: "mappin.circle")
                Text("Location")
                Spacer()
            }
            HStack{
                Text("ASDASD")
                Spacer()
            }
            
            
            Divider()
            Spacer()
        }.padding()
    }
}

struct PermissionView_Previews: PreviewProvider {
    static var previews: some View {
        PermissionView()
    }
}
