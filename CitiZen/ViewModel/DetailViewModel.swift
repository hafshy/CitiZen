//
//  DetailViewModel.swift
//  CitiZen
//
//  Created by Kenneth Widjaya on 28/06/22.
//

import Foundation
import UIKit

class DetailViewModel: ObservableObject {
    @Published var items: Landmarks
    
    init() {
        items = Landmarks.landmarks
    }
    
    func openMap(latitude: Double, longitude: Double) {
        if (UIApplication.shared.canOpenURL(NSURL(string:"http://maps.apple.com")! as URL)) {
            UIApplication.shared.open(NSURL(string:"http://maps.apple.com/?daddr=\(latitude),\(longitude)")! as URL)
        } else {
          NSLog("Can't use Apple Maps");
        }
    }
}
