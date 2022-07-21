//
//  MemoriesButtonView.swift
//  CitiZen
//
//  Created by Hafshy Yazid Albisthami on 19/07/22.
//

import SwiftUI

struct MemoriesButtonView: View {
    @StateObject private var viewModel = MemoriesButtonViewModel()
    @Binding var landmarkID: Int
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var chats: FetchedResults<Chat>
    
//    let landmarkID: Int
    var body: some View {
        if (chats.first(where: { chat in
            chat.id == landmarkID
        })?.completedCount ?? 0) < 5 {
            let count = String(chats.first(where: { chat in
                chat.id == landmarkID
            })?.completedCount ?? 0)
            HStack {
                Image("siola")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 48)
                    .padding(.trailing)
                VStack(alignment: .leading) {
                    Text(viewModel.landmark?.name ?? "Gaada")
                        .font(.headline)
                        .bold()
                    Text("\(count) / 5 On going missions")
                        .font(.caption2)
                }
                Spacer()
                Image(systemName: "message")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24)
            }
            .foregroundColor(.black)
            .padding()
            .background(Color.primaryYellow)
            .ignoresSafeArea()
            .onAppear {
                viewModel.landmarkID = landmarkID
                viewModel.loadLandmark()
            }
        }
        
    }
}
