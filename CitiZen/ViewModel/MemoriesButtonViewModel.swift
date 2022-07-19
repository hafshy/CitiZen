//
//  MemoriesButtonViewModel.swift
//  CitiZen
//
//  Created by Hafshy Yazid Albisthami on 19/07/22.
//

import SwiftUI

class MemoriesButtonViewModel: ObservableObject {
    @Published var landmark: Datum?
    @Published var landmarkID: Int = 0
    
    func loadLandmark() {
        landmark = Landmarks.landmarks.data.first(where: { lm in
            lm.id == landmarkID
        })
    }
}
