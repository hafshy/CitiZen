//
//  ContentView.swift
//  CitiZen
//
//  Created by Kenneth Widjaya on 13/07/22.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: AuthtenticationVM
    
    var body: some View {
            Group {
                // if not logged in show login
                if viewModel.userSession == false {
                    OnBoardingView()
                } else {
                    // else show main interface
                    MapView()
                }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
