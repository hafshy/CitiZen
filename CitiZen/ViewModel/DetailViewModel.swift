//
//  DetailViewModel.swift
//  CitiZen
//
//  Created by Kenneth Widjaya on 28/06/22.
//

import Foundation

class DetailViewModel: ObservableObject {
    @Published var items: Landmarks
    
    init() {
        items = Landmarks.landmarks
    }
}
