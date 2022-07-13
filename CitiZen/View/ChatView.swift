//
//  ChatView.swift
//  CitiZen
//
//  Created by Hafshy Yazid Albisthami on 11/07/22.
//

import SwiftUI

struct ChatView: View {
    @StateObject private var viewModel = ChatViewModel()
    @Environment(\.managedObjectContext) var moc
    
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
                    Button {
                        viewModel.showSheet = true
                    } label: {
                        Image(systemName: "camera.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 20)
                            .foregroundColor(.gray)
                    }
                    .confirmationDialog("Pick Image", isPresented: $viewModel.showSheet) {
                        Button("Camera") {
                            viewModel.showImagePicker = true
                            viewModel.sourceType = .camera
                        }
                        Button("Photo Library") {
                            viewModel.showImagePicker = true
                            viewModel.sourceType = .photoLibrary
                        }
                    }
                    HStack {
                        TextField("Message", text: $viewModel.enteredMessage)
                            .padding(12)
                        Image(systemName: "paperplane.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 20)
                            .padding(.trailing, 12)
                            .foregroundColor(.gray)
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
        .sheet(isPresented: $viewModel.showImagePicker) {
            Text("Sheet")
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(landmarkID: 1)
    }
}
