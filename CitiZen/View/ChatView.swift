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
                //                .background(.blue)
            } else {
                // Photo
            }
            
            if message.senderType == .receive {
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, alignment: message.senderType == .send ? .trailing : .leading)
        .padding(.horizontal, 12)
    }
    
    var body: some View {
        ScrollViewReader { value in
            VStack {
                ScrollView {
                    if (
                        !chats.isEmpty && chats.contains(where: { chat in
                            chat.id == landmarkID
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
                    value.scrollTo(bottomID)
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
                            .focused($isInputActive)
                            .onSubmit {
                                if !viewModel.enteredMessage.isEmpty {
                                    withAnimation {
                                        ChatDataController()
                                            .sendText(landmarkId: landmarkID, landmarkName: "Siola", landmarkIconName: "", isUser: false, text: viewModel.enteredMessage, complete: true, context: moc)
                                        viewModel.enteredMessage = ""
                                        value.scrollTo(bottomID)
                                    }
                                }
                            }
                            .padding(12)
                        Image(systemName: "paperplane.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 20)
                            .padding(.trailing, 12)
                            .foregroundColor(.gray)
                            .onTapGesture {
                                if !viewModel.enteredMessage.isEmpty {
                                    withAnimation {
                                        ChatDataController()
                                            .sendText(landmarkId: landmarkID, landmarkName: "Siola", landmarkIconName: "", isUser: false, text: viewModel.enteredMessage, complete: true, context: moc)
                                        viewModel.enteredMessage = ""
                                        value.scrollTo(bottomID)
                                    }
                                }
                            }
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
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $viewModel.showImagePicker) {
                Text("Sheet")
            }
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(landmarkID: 1)
    }
}
