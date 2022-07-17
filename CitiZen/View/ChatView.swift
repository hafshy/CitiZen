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
    @FetchRequest(sortDescriptors: []) var chats: FetchedResults<Chat>
    @Namespace var bottomID
    @FocusState var isInputActive: Bool
    
    let landmarkID: Int
    let columns = [GridItem(.flexible(minimum: 10))]
    
    @ViewBuilder
    func BubbleChat(message: Message) -> some View {
        HStack {
            if message.senderType == .send {
                Spacer()
            }
            
            if (message.messageType == .text) {
                ZStack {
                    Text(message.wrappedText)
                        .font(.caption)
                        .padding(.horizontal)
                        .padding(.vertical, 12)
                        .background(
                            message.senderType == .send ?
                                .yellow : .black.opacity(0.2)
                        )
                        .clipShape(CustomEdge(corner: [.topLeft, .topRight, message.senderType == .send ? .bottomLeft : .bottomRight], radius: 12))
                }
                .frame(width: 240, alignment: message.senderType == .send ? .trailing : .leading)
                .padding(.vertical, 8)
            } else {
                // Photo
                ZStack {
                    Image(uiImage: UIImage(data: message.photo!)!)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, alignment: .center)
                        .cornerRadius(16)
                }
                .frame(width: 240, alignment: message.senderType == .send ? .trailing : .leading)
                .padding(.vertical, 8)
            }
            
            if message.senderType == .receive {
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, alignment: message.senderType == .send ? .trailing : .leading)
        .padding(.horizontal, 12)
    }
    
    @ViewBuilder
    func ChatOptions(option: String) -> some View {
        Text(option)
            .padding()
            .background(.black.opacity(0.2))
    }
    
    var body: some View {
        ScrollViewReader { value in
            VStack {
                ScrollView {
                    if (
                        !chats.isEmpty && chats.contains(where: { chat in
                            chat.id == viewModel.landmarkID
                        })
                    ) {
                        LazyVGrid(columns: columns, spacing: 0) {
                            ForEach(chats.first(where: { chat in
                                chat.id == landmarkID
                            })?.messageArray ?? []) { message in
                                BubbleChat(message: message)
                            }
                            EmptyView()
                                .frame(height: 1)
                                .id(bottomID)
                        }
                    }
                }
                .onAppear {
                    viewModel.landmarkID = landmarkID
                    viewModel.loadChallenge()
                    if (
                        chats.isEmpty || !chats.contains(where: { chat in
                            chat.id == landmarkID
                        })
                    ) {
                        viewModel.initiateChallenge(context: moc)
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation {
                            value.scrollTo(bottomID)
                        }
                    }
                }
                
                if Int(chats.first(where: { chat in
                    chat.id == landmarkID
                })?.completedCount ?? 0) >= 5 {
                    HStack {
                        Spacer()
                        Text("You have completed all memories")
                            .foregroundColor(.green)
                        Spacer()
                    }
                    .padding()
                    .background(.thinMaterial)
                } else {
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
                                viewModel.onClickImageSourceOption(sourceType: .camera)
                            }
                            Button("Photo Library") {
                                viewModel.onClickImageSourceOption(sourceType: .photoLibrary)
                            }
                        }
                        
                        HStack {
                            if (viewModel.tempImage == nil) {
                                TextField("Message", text: $viewModel.enteredMessage)
                                    .focused($isInputActive)
                                    .onSubmit {
                                        if !viewModel.enteredMessage.isEmpty {
                                            withAnimation {
                                                let challengeIndex = Int(chats.first(where: { chat in
                                                    chat.id == landmarkID
                                                })?.completedCount ?? 0)
                                                viewModel.sendMessage(completedCount: challengeIndex, context: moc)
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                    withAnimation {
                                                        value.scrollTo(bottomID)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    .padding(12)
                            } else {
                                Image(systemName: "xmark")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 12)
                                    .padding(.leading, 12)
                                    .foregroundColor(.gray)
                                    .onTapGesture {
                                        viewModel.clearField()
                                    }
                                Image(uiImage: viewModel.tempImage ?? UIImage(named: "trophy")!)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, alignment: .leading)
                                    .padding(8)
                                Spacer()
                            }
                            Image(systemName: "paperplane.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 20)
                                .padding(.trailing, 12)
                                .foregroundColor(.gray)
                                .onTapGesture {
                                    let challengeIndex = Int(chats.first(where: { chat in
                                        chat.id == landmarkID
                                    })?.completedCount ?? 0)
                                    viewModel.sendMessage(completedCount: challengeIndex, context: moc)
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        withAnimation {
                                            value.scrollTo(bottomID)
                                        }
                                    }
                                }
                        }
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
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $viewModel.showImagePicker) {
                ImagePicker(image: $viewModel.tempImage, isShown: $viewModel.showImagePicker, sourceType: viewModel.sourceType)
            }
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(landmarkID: 3)
    }
}
