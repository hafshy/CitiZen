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
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    let landmarkID: Int
    let columns = [GridItem(.flexible(minimum: 10))]
    
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
                            let messages = (chats.first(where: { chat in
                                chat.id == landmarkID
                            })?.messageArray ?? [])
                            let completedCount = Int(chats.first(where: { chat in
                                chat.id == landmarkID
                            })?.completedCount ?? 0)
                            let latestChallengeChoice = viewModel.challenge?.challenges[completedCount].choices ?? []
                            let name = (chats.first(where: { chat in
                                chat.id == landmarkID
                            })?.wrappedLandmarkName)
                            let icon = (chats.first(where: { chat in
                                chat.id == landmarkID
                            })?.wrappedLandmarkIconName)
                            
                            ForEach(messages) { message in
                                BubbleChat(message: message)
                            }
                            
                            if messages.last?.senderType == .receive && messages.last?.text == viewModel.challenge?.challenges[completedCount].question && viewModel.challenge?.challenges[completedCount].category == "quiz" && completedCount < 5 {
                                ForEach(latestChallengeChoice, id:\.self) { choice in
                                    ChatOptions(option: choice)
                                        .onTapGesture {
                                            viewModel.sendAnswer(choice: choice, completed: completedCount, context: moc)
                                        }
                                }
                            }
                            
                            if completedCount == 5 {
                                HStack(alignment: .bottom) {
                                    PhotoCollage(messages: messages, name: name ?? "", icon: icon ?? "", size: 60)
                                        .padding(.leading)
                                    Button {
                                        var tempView: some View {
                                            PhotoCollage(messages: messages, name: name ?? "", icon: icon ?? "", size: 0)
                                        }
                                        if (!viewModel.collageSaved) {
                                            viewModel.saveImage(view: tempView.snapshot())
                                        }
                                    } label: {
                                        Image(systemName: viewModel.collageSaved ? "checkmark.circle" : "arrow.down.circle")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 28)
                                    }
                                    Spacer()
                                }
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
                    viewModel.scrollDown(proxy: value, namespaceId: bottomID)
                }
                
                if Int(chats.first(where: { chat in
                    chat.id == landmarkID
                })?.completedCount ?? 0) >= 5 {
                    HStack {
                        Spacer()
                        Text("Mission Accomplished")
                            .foregroundColor(.primaryYellow)
                        Spacer()
                    }
                    .padding()
                    .background(.black)
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
                                                viewModel.scrollDown(proxy: value, namespaceId: bottomID)
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
                                    viewModel.scrollDown(proxy: value, namespaceId: bottomID)
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
            .navigationTitle(viewModel.challenge?.name ?? "")
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: BackButton().onTapGesture {
                self.presentationMode.wrappedValue.dismiss()
            })
            .sheet(isPresented: $viewModel.showImagePicker) {
                ImagePicker(image: $viewModel.tempImage, isShown: $viewModel.showImagePicker, sourceType: viewModel.sourceType)
            }
        }
    }
    
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
                            Color.primaryYellow : .black.opacity(0.2)
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
                }
                .clipShape(CustomEdge(corner: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 12))
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
        HStack {
            Text(option)
                .font(.caption2)
                .padding(8)
                .background(Color.primaryYellow)
                .clipShape(CustomEdge(corner: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 8))
                .padding(.horizontal, 12)
                .padding(.bottom, 8)
                .frame(width: 300, alignment: .leading)
            Spacer()
        }
        
    }
    
    @ViewBuilder
    func PhotoCollage(messages: [Message], name: String, icon: String, size: CGFloat) -> some View {
        let photoMessage: [Message] = messages.filter { message in
            message.messageType == .photo
        }
        let columns = [
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
        
        if photoMessage.count > 0 {
            VStack {
                LazyVGrid(columns: columns) {
                    ForEach(photoMessage) { message in
                        Image(uiImage: UIImage(data: message.photo!)!)
                            .resizable()
                            .aspectRatio(1.0, contentMode: .fill)
                            .clipShape(CustomEdge(corner: [.allCorners], radius: 12))
                    }
                }
                HStack(alignment: .center) {
                    VStack(alignment: .leading) {
                        Text("Memories at")
                            .font(.callout)
                        Text(name)
                            .font(.title3)
                            .bold()
                            .lineLimit(2)
                    }
                    Spacer()
                    Image(icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: size)
                }
                .padding(.vertical)
            }
            .padding()
            .background(.yellow)
            .frame(width: 280)
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(landmarkID: 3)
    }
}
