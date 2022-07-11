//
//  ChatView.swift
//  CitiZen
//
//  Created by Hafshy Yazid Albisthami on 11/07/22.
//

import SwiftUI

struct ChatView: View {
    @StateObject private var viewModel = ChatViewModel()
    let landmarkID: Int
    
    let columns = [GridItem(.flexible(minimum: 10))]

    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 0) {
                        Text("TEST")
                    }
                }
                HStack {
                    Image(systemName: "camera.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 20)
                    HStack {
                        TextField("Message", text: $viewModel.enteredMessage)
                            .padding(12)
                        Image(systemName: "paperplane.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 20)
                            .padding(.trailing, 12)
                    }
                    .frame(height: 36)
                    .background(
                        Color(.white)
                            .clipShape(
                                RoundedRectangle(cornerRadius:12)
                            )
                    )
                    .padding(.leading, 6)
                }
                .padding()
                .background(.thinMaterial)
            }
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(landmarkID: 1)
    }
}
