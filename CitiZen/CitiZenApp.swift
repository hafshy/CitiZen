//
//  CitiZenApp.swift
//  CitiZen
//
//  Created by Hafshy Yazid Albisthami on 21/06/22.
//

import SwiftUI

@main
struct CitiZenApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(AuthtenticationVM.shared)
        }
    }
}
