//
//  AchievementViewModel.swift
//  CitiZen
//
//  Created by Trevincen Tambunan on 12/07/22.
//

import Foundation

class AchievementViewModel:ObservableObject {
    
    @Published var items: Challenges
    
    init() {
        items = Challenge.challenge
    }
    
}
