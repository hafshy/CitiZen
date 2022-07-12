//
//  AchievementView.swift
//  CitiZen
//
//  Created by Trevincen Tambunan on 29/06/22.
//

import SwiftUI

struct AchievementView: View {
    let columns = [GridItem(.flexible()),
                       GridItem(.flexible())]
    var body: some View {
            ScrollView {
                LazyVGrid(columns: columns) {
                            ForEach(0..<10) { item in
                                AchievementCardView()
                                
                            }}
                .padding(.horizontal)
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
