//
//  AchievementView.swift
//  CitiZen
//
//  Created by Trevincen Tambunan on 29/06/22.
//

import SwiftUI

struct AchievementView: View {
    
    @StateObject private var achievementViewModel = AchievementViewModel()
    
    let columns = [GridItem(.flexible()),
                   GridItem(.flexible())]
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns,spacing: 15) {
                ForEach(0..<$achievementViewModel.items.count, id: \.self) { item in
                    AchievementCardView(achievement: $achievementViewModel.items[item])
                    
                }}
            .padding()
        }
        
        .navigationTitle("My Achievement")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AchievementView_Previews: PreviewProvider {
    static var previews: some View {
        AchievementView()
    }
}
