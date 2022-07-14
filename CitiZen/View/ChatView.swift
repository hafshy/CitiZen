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
                        if (viewModel.tempImage == nil) {
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
                        } else {
                            Image(systemName: "xmark")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 20)
                                .padding(.leading, 12)
                                .foregroundColor(.gray)
                                .onTapGesture {
                                    viewModel.tempImage = nil
                                    viewModel.enteredMessage = ""
                                }
                            Image(uiImage: viewModel.tempImage ?? UIImage(named: "trophy")!)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, alignment: .leading)
                                .padding()
                            Spacer()
                        }
                        Image(systemName: "paperplane.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 20)
                            .padding(.trailing, 12)
                            .foregroundColor(.gray)
                            .onTapGesture {
                                if !viewModel.enteredMessage.isEmpty && viewModel.tempImage == nil {
                                    withAnimation {
                                        ChatDataController()
                                            .sendText(landmarkId: landmarkID, landmarkName: "Siola", landmarkIconName: "", isUser: false, text: viewModel.enteredMessage, complete: true, context: moc)
                                        viewModel.enteredMessage = ""
                                        value.scrollTo(bottomID)
                                    }
                                }
                                if (viewModel.tempImage != nil) {
                                    withAnimation {
                                        ChatDataController()
                                            .sendPhoto(landmarkId: landmarkID, landmarkName: "Siola", landmarkIconName: "", photo: viewModel.tempImage!, complete: false, context: moc)
                                        viewModel.tempImage = nil
                                        value.scrollTo(bottomID)
                                    }
                                }
                            }
                    }
//                    .frame(height: 36)
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
                ImagePicker(image: $viewModel.tempImage, isShown: $viewModel.showImagePicker, sourceType: viewModel.sourceType)
                    .onDisappear {
                        if viewModel.tempImage != nil {
                            
                        } else {
                            print("NO")
                        }
                    }
            }
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(landmarkID: 1)
    }
}
