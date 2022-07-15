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
    let challenge: Challenge?
    
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
                    if (
                        chats.isEmpty || !chats.contains(where: { chat in
                            chat.id == landmarkID
                        })
                    ) {
                        if let currentChallenge = challenge {
                            let firstChallenge = currentChallenge.challenges[0]
                            ChatDataController()
                                .sendText(landmarkId: landmarkID, landmarkName: currentChallenge.name, landmarkIconName: currentChallenge.icon, isUser: false, text: firstChallenge.question, complete: 0, context: moc)
                        }
                    }
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
                                                .sendText(landmarkId: landmarkID, landmarkName: "", landmarkIconName: "", isUser: false, text: viewModel.enteredMessage, complete: 0, context: moc)
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
                                .frame(height: 12)
                                .padding(.leading, 12)
                                .foregroundColor(.gray)
                                .onTapGesture {
                                    withAnimation {
                                        viewModel.tempImage = nil
                                        viewModel.enteredMessage = ""
                                    }
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
                                var category = ""
                                var answer: [String] = []
                                let challengeIndex = Int(chats.first(where: { chat in
                                    chat.id == landmarkID
                                })?.completedCount ?? 0)
                                if let challenge = challenge {
                                    category = challenge.challenges[challengeIndex].category
                                    answer = challenge.challenges[challengeIndex].answer
                                }
                                // Send Text
                                if !viewModel.enteredMessage.isEmpty && viewModel.tempImage == nil {
                                    withAnimation {
                                        ChatDataController()
                                            .sendText(
                                                landmarkId: landmarkID,
                                                landmarkName: challenge?.name ?? "",
                                                landmarkIconName: challenge?.icon ?? "",
                                                isUser: true,
                                                text: viewModel.enteredMessage,
                                                complete: challengeIndex,
                                                context: moc
                                            )

                                        print(answer)
                                        print(viewModel.enteredMessage)
                                        print(answer != [])
                                        print((category == "quiz" && answer != [] && answer.contains(where: { ans in
                                            ans == viewModel.enteredMessage
                                        })))
                                        ChatDataController()
                                            .sendText(
                                                landmarkId: landmarkID,
                                                landmarkName: challenge?.name ?? "",
                                                landmarkIconName: challenge?.icon ?? "",
                                                isUser: false,
                                                text: (category == "quiz" && answer != [] && answer.contains(where: { ans in
                                                    ans == viewModel.enteredMessage
                                                })) ? (challenge?.challenges[challengeIndex + 1].question ?? "") : "Salah",
                                                complete: (category == "quiz" && answer != [] && answer.contains(where: { ans in
                                                    ans == viewModel.enteredMessage
                                            })) ? challengeIndex + 1 : challengeIndex,
                                                context: moc
                                            )
                                        viewModel.enteredMessage = ""
                                        value.scrollTo(bottomID)
                                    }
                                }
                                // Send Image
                                if (viewModel.tempImage != nil) {
                                    withAnimation {
                                        ChatDataController()
                                            .sendPhoto(
                                                landmarkId: landmarkID,
                                                landmarkName: challenge?.name ?? "",
                                                landmarkIconName: challenge?.icon ?? "",
                                                photo: viewModel.tempImage!,
                                                complete: challengeIndex,
                                                context: moc
                                            )
                                        ChatDataController()
                                            .sendText(
                                                landmarkId: landmarkID,
                                                landmarkName: challenge?.name ?? "",
                                                landmarkIconName: challenge?.icon ?? "",
                                                isUser: false,
                                                text: (category == "photo") && challengeIndex < 6 ? (challenge?.challenges[challengeIndex + 1].question ?? "") : "Salah",
                                                complete: category == "photo" ? challengeIndex + 1 : challengeIndex,
                                                context: moc
                                            )
                                        viewModel.tempImage = nil
                                        value.scrollTo(bottomID)
                                    }
                                }
                                print(Int(chats.first(where: { chat in
                                    chat.id == landmarkID
                                })?.completedCount ?? -1))
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
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $viewModel.showImagePicker) {
                ImagePicker(image: $viewModel.tempImage, isShown: $viewModel.showImagePicker, sourceType: viewModel.sourceType)
            }
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(landmarkID: 1, challenge: Challenge.challenge.first(where: { challenge in
            challenge.id == 1
        }) ?? nil)
    }
}
