//
//  AchievementView.swift
//  CitiZen
//
//  Created by Trevincen Tambunan on 29/06/22.
//

import SwiftUI

struct AchievementView: View {
    
    @StateObject private var achievementViewModel = AchievementViewModel()
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var chats: FetchedResults<Chat>
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    let columns = [GridItem(.flexible()),
                   GridItem(.flexible())]
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns,spacing: 15) {
                ForEach(0..<$achievementViewModel.items.count, id: \.self) { item in
                    let completedCount = Int(chats.first(where: { chat in
                        chat.id-1 == item
                    })?.completedCount ?? 0)
                    AchievementCardView(achievement: $achievementViewModel.items[item], completedTask: completedCount)
                    
                }}
            .padding()
        }
        
        .navigationTitle("My Achievement")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: BackButton().onTapGesture {
            self.presentationMode.wrappedValue.dismiss()
        })
    }
}

struct AchievementView_Previews: PreviewProvider {
    static var previews: some View {
        AchievementView()
    }
}
